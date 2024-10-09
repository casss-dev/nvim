local opts = function(desc)
  return { noremap = true, silent = true, desc = desc or '' }
end

local keymap = vim.keymap.set

-- Make wrapped lines easier to navigate
vim.api.nvim_create_autocmd('FileType', {
  callback = function(ev)
    -- print('Event fired: s', vim.inspect(ev))
    if ev.match == 'markdown' then
      keymap('n', 'j', 'gj', opts())
      keymap('n', 'k', 'gk', opts())
    end
  end,
})

keymap('n', '<leader>so', '<cmd>so %<CR>', opts '[S]ource this file')

-- MARK: Buffers

-- Save buffer
keymap('n', '<leader>z', '<cmd>w<CR>', opts 'Save current buffer')

-- Delete buffer
keymap('n', '<m-d>', '<cmd>:bd<CR>', opts 'Deletes the current buffer')

keymap('n', '<m-D>', '<cmd> :%bd|e# <CR>', opts 'Delete all buffers, then open last buffer')

-- Exit highlight
keymap('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- MARK: LSP

-- Diagnostic keymaps
keymap('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
keymap('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
keymap('n', '<leader>de', vim.diagnostic.open_float, { desc = 'Show [D]iagnostic [E]rror messages' })
-- keymap('n', '<leader>dq', vim.diagnostic.setloclist, { desc = 'Open [D]iagnostic [Q]uickfix list' })
keymap('n', '<leader>dq', vim.diagnostic.setqflist, { desc = 'Open [D]iagnostic [Q]uickfix list' })
keymap('n', '<leader>cp', '<cmd>cp<CR>', opts 'Previous quick fix item')
keymap('n', '<leader>cn', '<cmd>cn<CR>', opts 'Next quick fix item')
keymap('n', '<leader>li', '<cmd>LspInfo<CR>', opts 'Show [L]sp [I]nfo')
keymap('n', '<leader>lld', '<cmd>LspLog<CR>', opts 'Show [L]sp [L]ogs')
keymap('n', '<leader>lcl', vim.lsp.codelens.run, opts 'Run [L]sp [C]ode [L]ens')

-- MARK: Windows

keymap('n', '<m-c>', '<C-w>c', opts '[C]lose window')

-- Arrow keys resize windows
keymap('n', '<left>', '5<C-w><')
keymap('n', '<right>', '5<C-w>>')
keymap('n', '<up>', '5<C-w>+')
keymap('n', '<down>', '5<C-w>-')

-- keymap('n', '<leader>mw', '<C-w>T', opts '[M]aximize [W]indow')

-- See `:help wincmd` for a list of all window commands
keymap('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
keymap('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
keymap('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
keymap('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

keymap('n', '<m-l>', '<cmd>vsplit<CR>', opts 'Split window left')
keymap('n', '<m-j>', '<cmd>split<CR>', opts 'Split window bottom')
-- NOTE: '<m-h>' == 'alt'

-- MARK: Center screen

-- Center screen when search scrolling
keymap('n', 'n', 'nzz', opts())
keymap('n', 'N', 'Nzz', opts())
keymap('n', '*', '*zz', opts())
keymap('n', '#', '#zz', opts())

-- MARK: Insert

keymap('i', 'kj', '<ESC>', opts 'Exits insert mode')
keymap('i', '<C-k>', '_', opts 'inserts an underscore')

-- MARK: Visual

local function search()
  local reg = vim.fn.getreg 'p'
  vim.notify(reg)
  -- os.execute('google ' .. reg)
  -- io.popen('google' .. reg)
  os.execute 'python -c "print("hello")"'
end

-- keymap('v', '<C-x>', search, opts 'Search with selection')

-- Stay in indent mode
-- Replace all in buffer
keymap('v', '<C-r>', function()
  return 'y:%s/<C-r><C-w>/'
end, { expr = true })

-- MARK: Keep yank after pasting
keymap('x', 'p', [["_dP]])

-- MARK: Auto newline commas

keymap('n', '<C-m>', 'va(:s/(/(\\r<CR>vf):s/)/\\r)<CR>kv$:s/,<Space>/,\\r/g<CR>j', opts 'Add new line after trailing commas')

vim.fn.setreg('m', 'F(a\r<C-c>')

-- MARK: Terminal

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.

-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
-- keymap('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

keymap('n', '<m-h>', ':terminal<CR>', { desc = 'Open new terminal' })
keymap('t', '<C-\\><C-\\>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
