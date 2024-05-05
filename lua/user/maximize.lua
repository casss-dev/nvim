local M = {
  'declancm/maximize.nvim',
}

function M.config()
  local m = require 'maximize'
  m.setup {
    default_keymaps = false,
  }
  vim.keymap.set('n', '<leader>mw', m.toggle, { desc = 'toggle [M]aximize [W]indow' })
end

return M
