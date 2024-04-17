local M = {
  'smoka7/hop.nvim',
  version = '*',
  opts = {},
  event = 'VimEnter',
}

function M.config()
  local hop = require 'hop'
  hop.setup {}

  local opts = { noremap = true, silent = true, desc = '[J]ump to any word' }
  vim.keymap.set('n', '<leader>j', '<cmd>HopWord<CR>', opts)
end

return M
