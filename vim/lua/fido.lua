-- Utilities
local function map(list, transform)
  local remapped_list = {}

  for _, item in pairs(list) do
    table.insert(remapped_list, transform(item))
  end

  return remapped_list
end

local function filter(list, predicate)
  local filtered_list = {}
  local filtered_indexes = {}

  for i, item in pairs(list) do
    if predicate(item) then
      table.insert(filtered_list, item)
      table.insert(filtered_indexes, i)
    end
  end

  return filtered_list, filtered_indexes
end

local function find(list, predicate)
  for i, item in pairs(list) do
    if predicate(item) then
      return item, i
    end
  end

  return nil, -1
end

local function trim(line)
  return string.match(line, '^%s*(.*%S)') or ''
end

-- Helpers
local function remove_empty_lines(lines)
  local empty_line_regex = '^%s*$'

  return filter(lines, function(line)
    return not string.find(line, empty_line_regex)
  end)
end

local function parse_buffer()
  local global_separator_regex = '^%s*=+%s*$'
  local local_separator_regex = '^%s*-+%s*$'
  local buffer_lines = vim.fn.getline(1, '$')
  local selected_index = vim.fn.line('.')

  -- Parse the `global` section
  local _, global_separator_index = find(buffer_lines, function(line)
    return string.find(line, global_separator_regex)
  end)

  -- Parse the `selected` section
  local _, local_separator_indexes = filter(buffer_lines, function(line)
    return string.find(line, local_separator_regex) or string.find(line, global_separator_regex)
  end)

  -- Move the `selected_index` out of the `global` section
  if selected_index <= global_separator_index then
    selected_index = global_separator_index + 1
  end

  local min_index = 1
  local max_index = #buffer_lines
  for _, separator_index in pairs(local_separator_indexes) do
    -- If the `selected_index` is on a separator, move to the next section
    if selected_index == separator_index and selected_index < #buffer_lines then
      selected_index = selected_index + 1
    end

    if separator_index < selected_index and separator_index > 1 then
      min_index = separator_index + 1
    end
    if separator_index > selected_index and separator_index < max_index then
      max_index = separator_index - 1
    end
  end

  local global_lines = global_separator_index > 1 and vim.fn.getline(1, global_separator_index - 1) or {}
  local selected_lines = vim.fn.getline(min_index, max_index)

  return selected_lines, global_lines
end

local function render_response(args)
  local name = '[' .. args.name .. ']'
  local winnr = vim.fn.bufwinnr(vim.fn.escape(name, '[]'))

  if winnr > 0 then
    -- Focus the existing response window
    vim.cmd(winnr .. 'wincmd w')
  else
    -- Create a new response window
    if args.vertical then
      local winwidth = vim.fn.winwidth(0)

      vim.cmd('vnew ' .. name)
      vim.cmd('vertical resize ' .. winwidth / 5 * 2)
    else
      local winheight = vim.fn.winheight(0)

      vim.cmd('new ' .. name)
      vim.cmd('resize ' .. winheight / 4)
    end

    -- Convert to a Scratch buffer
    vim.bo.bufhidden = 'wipe'
    vim.bo.buflisted = false
    vim.bo.buftype = 'nofile'
    vim.bo.swapfile = false
  end

  vim.bo.readonly = false
  vim.cmd('silent normal gg"_dG')

  vim.api.nvim_buf_set_lines(0, 0, 0, false, args.lines)

  vim.cmd('normal gg')
  vim.bo.readonly = true

  vim.cmd('wincmd p')
end

local function apply_variables(global, selected)
  local variables = {}

  -- Parse `global` for variable declarations
  for _, line in pairs(global) do
    local key, value = string.match(line, '^%s*(%S+)%s*=%s*(.+)%s*$')
    if key then
      variables[key] = value
    end
  end

  local function replace_variables(lines)
    return map(lines, function(line)
      local translated_line = line

      for key, value in pairs(variables) do
        translated_line = string.gsub(translated_line, key, value)
      end

      return translated_line
    end)
  end

  return replace_variables(global), replace_variables(selected)
end

local function run_client(args)
  local selected, global = parse_buffer()

  render_response({
    name = args.name,
    vertical = args.vertical,
    lines = args.execute({
      global = global,
      selected = selected,
    }),
  })
end

local function fetch()
  if vim.bo.filetype == 'rest' and vim.fn.executable('curl') then
    run_client({
      name = 'HTTP',
      vertical = true,
      execute = function(args)
        local cmd_opts = {
          '--silent',
          '--show-error',
          '--location',
          '--include',
        }

        local global, selected =
          apply_variables(map(remove_empty_lines(args.global), trim), map(remove_empty_lines(args.selected), trim))

        -- Parse `global` lines
        for _, line in pairs(global) do
          if string.find(line, '^#') then
          elseif string.find(line, '^-') then
            table.insert(cmd_opts, line)
          elseif string.find(line, '^.+:.+$') then
            table.insert(cmd_opts, '--header "' .. line .. '"')
          end
        end

        local method, url = 'GET', selected[1] or ''
        if string.find(url, '%s') then
          method, url = string.match(url, '^(%S+)%s+(.+)$')
          method = string.upper(method)
        end

        -- Request Body
        local data_methods = { POST = true, PUT = true, PATCH = true }
        if #selected > 1 and data_methods[method] then
          table.remove(selected, 1)

          -- Join with `&` or ` `, depending on the shape of the data
          local data = table.concat(selected, string.find(selected[1], '%S+=%S+') and '&' or ' ')
          table.insert(cmd_opts, '--data "' .. string.gsub(data, '"', '\\"') .. '"')
        end

        -- HTTP Method
        table.insert(cmd_opts, '--request ' .. string.upper(method))

        local cmd = trim('curl ' .. table.concat(cmd_opts, ' ') .. ' "' .. url .. '"', '')
        print(cmd)

        return vim.fn.systemlist(cmd)
      end,
    })
  elseif vim.bo.filetype == 'sql' and vim.fn.executable('psql') then
    run_client({
      name = 'SQL',
      execute = function(args)
        local cmd_opts = {
          '--field-separator="x"',
        }

        local global, selected = apply_variables(map(remove_empty_lines(args.global), trim), args.selected)

        -- Parse `global` lines
        for _, line in pairs(global) do
          if string.find(line, '^#') then
          elseif string.find(line, '^-') then
            table.insert(cmd_opts, line)
          elseif string.find(line, '^%s*%S+://%S+%s*$') then
            table.insert(cmd_opts, '--dbname="' .. line .. '"')
          end
        end

        local cmd = trim('psql ' .. table.concat(cmd_opts, ' '))
        print(cmd)

        return vim.fn.systemlist(cmd, table.concat(selected, '\n'))
      end,
    })
  end
end

return { fetch = fetch }
