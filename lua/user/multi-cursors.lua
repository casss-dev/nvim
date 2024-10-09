local M = {
  'brenton-leighton/multiple-cursors.nvim',
  version = '*', -- Use the latest tagged version
  opts = {}, -- This causes the plugin setup function to be called
  keys = {
    { '<C-m-j>', '<Cmd>MultipleCursorsAddDown<CR>', mode = { 'n', 'x' }, desc = 'Add cursor and move down' },
    { '<C-m-k>', '<Cmd>MultipleCursorsAddUp<CR>', mode = { 'n', 'x' }, desc = 'Add cursor and move up' },

    { '<m-Up>', '<Cmd>MultipleCursorsAddUp<CR>', mode = { 'n', 'i', 'x' }, desc = 'Add cursor and move up' },
    { '<m-Down>', '<Cmd>MultipleCursorsAddDown<CR>', mode = { 'n', 'i', 'x' }, desc = 'Add cursor and move down' },

    { '<C-LeftMouse>', '<Cmd>MultipleCursorsMouseAddDelete<CR>', mode = { 'n', 'i' }, desc = 'Add or remove cursor' },

    { '<Leader>a', '<Cmd>MultipleCursorsAddMatches<CR>', mode = { 'n', 'x' }, desc = 'Add cursors to cword' },
    { '<Leader>A', '<Cmd>MultipleCursorsAddMatchesV<CR>', mode = { 'n', 'x' }, desc = 'Add cursors to cword in previous area' },

    { '<Leader>dd', '<Cmd>MultipleCursorsAddJumpNextMatch<CR>', mode = { 'n', 'x' }, desc = 'Add cursor and jump to next cword' },
    { '<Leader>dn', '<Cmd>MultipleCursorsJumpNextMatch<CR>', mode = { 'n', 'x' }, desc = 'Jump to next cword' },

    { '<Leader>lll', '<Cmd>MultipleCursorsLock<CR>', mode = { 'n', 'x' }, desc = 'Lock virtual cursors' },
  },
}

return M
