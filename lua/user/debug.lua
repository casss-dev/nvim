-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

local M = {
  'mfussenegger/nvim-dap',
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    -- 'leoluz/nvim-dap-go',
  },
}

function M.config()
  local dap = require 'dap'
  local dapui = require 'dapui'

  require('mason-nvim-dap').setup {
    -- Makes a best effort to setup the various debuggers with
    -- reasonable debug configurations
    automatic_installation = true,

    -- You can provide additional configuration to the handlers,
    -- see mason-nvim-dap README for more information
    handlers = {},

    -- You'll need to check that you have the required things installed
    -- online, please don't ask me how to install them :)
    ensure_installed = {
      -- Update this to ensure that you have the debuggers for the langs you want
      -- 'delve',
    },
  }

  -- Basic debugging keymaps, feel free to change to your liking!
  vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })

  vim.keymap.set('n', '<F6>', function()
    dap.terminate()
    dapui.close()
  end, { desc = 'Debug: Terminate' })

  vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
  vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
  vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })

  vim.keymap.set('n', '<leader>bb', dap.toggle_breakpoint, { desc = 'Debug: Toggle breakpoint' })
  vim.keymap.set('n', '<leader>bx', dap.clear_breakpoints, { desc = 'Debug: Clear breakpoints' })

  vim.keymap.set('n', '<leader>bl', function()
    dap.list_breakpoints(true)
  end, { desc = 'Debug: List breakpoints' })

  vim.keymap.set('n', '<leader>bc', function()
    dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
  end, { desc = 'Debug: Set Breakpoint' })

  -- Dap UI setup
  -- For more information, see |:h dapui.setup()|
  dapui.setup()

  -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
  vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })

  dap.listeners.after.event_initialized['dapui_config'] = dapui.open
  dap.listeners.before.event_terminated['dapui_config'] = dapui.close
  dap.listeners.before.event_exited['dapui_config'] = dapui.close

  -- Godot stuff
  dap.adapters.godot = {
    type = 'server',
    host = '127.0.0.1',
    port = 6006,
  }

  dap.configurations.gdscript = {
    {
      type = 'godot',
      request = 'launch',
      name = 'Launch scene',
      project = '${workspaceFolder}',
      -- launch_scene = true,
    },
  }
end

return M
