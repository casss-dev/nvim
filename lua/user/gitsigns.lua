local M = {
  'lewis6991/gitsigns.nvim',
  event = 'VeryLazy',
}

function M.config()
  local gitsigns = require 'gitsigns'

  gitsigns.setup {
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
    numhl = true,
    current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
    -- current_line_blame_opts = {
    --   virt_text = true,
    --   virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
    --   delay = 1000,
    --   ignore_whitespace = false,
    --   virt_text_priority = 100,
    -- },
  }

  local opts = function(desc)
    return { noremap = true, silent = true, desc = desc or '' }
  end

  local keymap = vim.keymap.set

  keymap('n', '<leader>gh', '<cmd>Git preview_hunk<CR>', opts '[G]it [P]review hunk')
  keymap('n', '<leader>gn', '<cmd>Git next_hunk<CR>', opts '[G]it [N]ext hunk')
  keymap('n', '<leader>gp', '<cmd>Git prev_hunk<CR>', opts '[G]it [P]revious hunk')
  keymap('n', '<leader>grh', '<cmd>Git reset_hunk<CR>', opts '[G]it [R]eset hunk')
  keymap('n', '<leader>gd', '<cmd>Git diffthis<CR>', opts '[G]it [D]iff this')

  keymap('n', '<leader>gtd', gitsigns.toggle_deleted, opts '[G]it [T]oggle [D]eleted')
end

return M
