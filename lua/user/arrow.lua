local M = {
  'otavioschwanck/arrow.nvim',
}

function M.config()
  local arrow = require 'arrow'
  local arrowP = require 'arrow.persist'

  arrow.setup {
    show_icons = true,
    separate_by_branch = true, -- Bookmarks will be separated by git branch
    leader_key = "'", -- Recommended to be a single key
    hide_handbook = false, -- set to true to hide the shortcuts on menu.
    buffer_leader_key = 'm', -- Per Buffer Mappings
    window = { -- controls the appearance and position of an arrow window (see nvim_open_win() for all options)
      width = 'auto',
      height = 'auto',
      relative = 'cursor',
      row = 0,
      col = 0,
      border = 'rounded',
    },
  }

  vim.keymap.set('n', 'H', arrowP.previous)
  vim.keymap.set('n', 'L', arrowP.next)
  vim.keymap.set('n', '<C-p>', arrowP.toggle)

  vim.api.nvim_create_autocmd('BufWritePost', {
    desc = 'Add file to arrow',
    group = vim.api.nvim_create_augroup('add file to arrow on write', {}),
    callback = function(ev)
      local file = ev.file
      arrowP.save(file)
      -- print('Event fired: ', vim.inspect(ev))
    end,
  })
end

return M
