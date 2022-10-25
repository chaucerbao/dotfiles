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
    if predicate(item) then return item, i end
  end

  return nil, -1
end

local function trim(line) return string.match(line, '^%s*(.*%S)') or '' end

-- Helpers
local function remove_empty_lines(lines)
  local empty_line_regex = '^%s*$'

  return filter(lines, function(line) return not string.find(line, empty_line_regex) end)
end

local function parse_buffer()
  local global_separator_regex = '^%s*=+%s*$'
  local local_separator_regex = '^%s*-+%s*$'
  local buffer_lines = vim.fn.getline(1, '$')
  local selected_index = vim.fn.line('.')

  -- Parse the `global` section
  local _, global_separator_index = find(
    buffer_lines,
    function(line) return string.find(line, global_separator_regex) end
  )

  -- Parse the `selected` section
  local _, local_separator_indexes = filter(
    buffer_lines,
    function(line) return string.find(line, local_separator_regex) or string.find(line, global_separator_regex) end
  )

  -- Move the `selected_index` out of the `global` section
  if selected_index <= global_separator_index then selected_index = global_separator_index + 1 end

  local min_index = 1
  local max_index = #buffer_lines
  for _, separator_index in pairs(local_separator_indexes) do
    -- If the `selected_index` is on a separator, move to the next section
    if selected_index == separator_index and selected_index < #buffer_lines then selected_index = selected_index + 1 end

    if separator_index < selected_index and separator_index > 1 then min_index = separator_index + 1 end
    if separator_index > selected_index and separator_index < max_index then max_index = separator_index - 1 end
  end

  return {
    global = global_separator_index > 1
        and filter(vim.fn.getline(1, global_separator_index - 1), function(line) return not string.find(line, '^#') end)
      or {},

    selected = vim.fn.getline(min_index, max_index),
  }
end

local function apply_variables(global, selected)
  local variables = {}

  -- Parse `global` for variable declarations
  for _, line in pairs(global) do
    local key, value = string.match(line, '^%s*(%S+)%s*=%s*(.+)%s*$')
    if key then variables[key] = value end
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

local function render_client_response(client)
  local name = '[' .. client.name .. ']'
  local winnr = vim.fn.bufwinnr(vim.fn.escape(name, '[]'))

  local response_lines, cmd = client.execute()

  if winnr > 0 then
    -- Focus the existing response window
    vim.cmd(winnr .. 'wincmd w')
  else
    -- Create a new response window
    if client.vertical then
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

  vim.api.nvim_buf_set_lines(0, 0, 0, false, response_lines)

  vim.cmd('normal gg')
  vim.bo.readonly = true

  vim.cmd('wincmd p')

  print(cmd)
end

-- Clients
local curl_client = {
  name = 'HTTP',
  vertical = true,
  execute = function()
    local parsed_buffer = parse_buffer()
    local global, selected = apply_variables(
      map(remove_empty_lines(parsed_buffer.global), trim),
      map(remove_empty_lines(parsed_buffer.selected), trim)
    )

    local cmd_opts = {
      '--silent',
      '--show-error',
      '--location',
      '--include',
    }

    -- Parse `global` lines
    for _, line in pairs(global) do
      if string.find(line, '^-') then
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

      local is_key_value = string.find(selected[1], '%S+=%S+')
      local data = table.concat(selected, is_key_value and '&' or ' ')

      if not is_key_value then
        cmd_opts = filter(cmd_opts, function(opt) return not string.find(string.lower(opt), '^content-type:%s') end)
        table.insert(cmd_opts, '--header "Content-Type: application/json"')
      end

      table.insert(cmd_opts, '--data "' .. string.gsub(data, '"', '\\"') .. '"')
    end

    -- HTTP Method
    table.insert(cmd_opts, '--request ' .. string.upper(method))

    local cmd = trim('curl ' .. table.concat(cmd_opts, ' ') .. ' "' .. url .. '"', '')

    return vim.fn.systemlist(cmd), cmd
  end,
}

local psql_client = {
  name = 'SQL',
  execute = function()
    local parsed_buffer = parse_buffer()
    local global, selected =
      apply_variables(map(remove_empty_lines(parsed_buffer.global), trim), parsed_buffer.selected)

    local cmd_opts = {}

    -- Parse `global` lines
    for _, line in pairs(global) do
      if string.find(line, '^-') then
        table.insert(cmd_opts, line)
      elseif string.find(line, '^%s*%S+://%S+%s*$') then
        table.insert(cmd_opts, '--dbname="' .. line .. '"')
      end
    end

    local cmd = trim('psql ' .. table.concat(cmd_opts, ' '))

    return vim.fn.systemlist(cmd, table.concat(selected, '\n')), cmd
  end,
}

local function fetch(cmd_client)
  if cmd_client then
    render_client_response(cmd_client)
  elseif vim.bo.filetype == 'rest' and vim.fn.executable('curl') then
    render_client_response(curl_client)
  elseif vim.bo.filetype == 'sql' and vim.fn.executable('psql') then
    render_client_response(psql_client)
  end
end

return { fetch = fetch }
