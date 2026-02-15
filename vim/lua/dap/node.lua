local key = 'pwa-node'

local configuration = {
  {
    type = key,
    request = 'attach',
    name = 'Attach to Node Debugger',
    address = 'localhost',
    port = function()
      return tonumber(vim.fn.input('Attach Port: ', '9229'))
    end,
    cwd = '${workspaceFolder}',
    restart = true,
  },
}

return {
  adapters = {
    [key] = {
      type = 'server',
      host = 'localhost',
      port = '${port}',
      executable = {
        command = 'js-debug-adapter',
        args = { '${port}' },
      },
    },
  },

  configurations = { javascript = configuration, typescript = configuration },
}
