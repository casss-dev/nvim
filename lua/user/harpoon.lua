local M = {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim' },
  event = 'VimEnter',
}

function M.config()
  local harpoon = require 'harpoon'
  harpoon:setup()

  -- basic telescope configuration
  local conf = require('telescope.config').values
  local function toggle_telescope(harpoon_files)
    local file_paths = {}
    for _, item in ipairs(harpoon_files.items) do
      table.insert(file_paths, item.value)
    end

    require('telescope.pickers')
      .new({}, {
        prompt_title = 'Harpoon',
        finder = require('telescope.finders').new_table {
          results = file_paths,
        },
        previewer = conf.file_previewer {},
        sorter = conf.generic_sorter {},
      })
      :find()
  end

  local opts = function(desc)
    return { noremap = true, silent = true, desc = desc or '' }
  end

  local keymap = vim.keymap.set

  keymap('n', '<leader>ha', function()
    harpoon:list():add()
  end, opts '[H]arpoon will [A]dd the current buffer to the quick menu')
  keymap('n', '<leader>hq', function()
    toggle_telescope(harpoon:list())
  end, opts 'Toggle [H]arpoon [Q]uick menu')

  keymap('n', '<leader>h1', function()
    harpoon:list():select(1)
  end, opts '[H]arpoon select 1')
  keymap('n', '<leader>h2', function()
    harpoon:list():select(2)
  end, opts '[H]arpoon select 2')
  keymap('n', '<leader>h3', function()
    harpoon:list():select(3)
  end, opts '[H]arpoon select 3')
  keymap('n', '<leader>h4', function()
    harpoon:list():select(4)
  end, opts '[H]arpoon select 4')

  keymap('n', '<C-S-P>', function()
    harpoon:list():prev()
  end, opts 'Toggle [P]revious buffer in harpoon list')
  keymap('n', '<C-S-N>', function()
    harpoon:list():next()
  end, opts 'Toggle [N]ext buffer in harpoon list')
end

return M
