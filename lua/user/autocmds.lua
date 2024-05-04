-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  desc = 'Sets custom markdown options, when a markdown file is opened',
  group = vim.api.nvim_create_augroup('custom-markdown-options', {}),
  callback = function(ev)
    -- print('Event fired: s', vim.inspect(ev))
    if ev.match == 'markdown' then
      vim.cmd 'set wrap'
      vim.cmd 'set linebreak'
    end
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  desc = 'Sets custom markdown options, when a swift file is opened',
  group = vim.api.nvim_create_augroup('custom-swift', {}),
  callback = function(ev)
    if ev.match == 'swift' then
      vim.keymap.set('i', [[<c-\>]], '\\()', { desc = 'Interpolate string' })
    end
  end,
})
