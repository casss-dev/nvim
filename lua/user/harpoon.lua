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
    local function make_finder()
      local file_paths = {}
      for i, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, i, item.value)
      end
      return require('telescope.finders').new_table {
        results = file_paths,
      }
    end
    local themes = require 'telescope.themes'
    require('telescope.pickers')
      .new(themes.get_dropdown { preview = false }, {
        prompt_title = 'Harpoon',
        finder = make_finder(),
        -- previewer = conf.file_previewer {},
        sorter = conf.generic_sorter {},
        attach_mappings = function(prompt_buffer_number, map)
          map(
            'i',
            '<m-d>', -- your mapping here
            function()
              local state = require 'telescope.actions.state'
              local selected_entry = state.get_selected_entry()
              local current_picker = state.get_current_picker(prompt_buffer_number)

              harpoon:list():remove_at(selected_entry.index)
              current_picker:refresh(make_finder())
            end
          )
          return true
        end,
      })
      :find()
  end

  -- harpoon:extend {
  --   UI_CREATE = function(cx)
  --     vim.keymap.set('n', '<C-v>', function()
  --       harpoon.ui:select_menu_item { vsplit = true }
  --     end, { buffer = cx.bufnr })
  --
  --     vim.keymap.set('n', '<C-x>', function()
  --       harpoon.ui:select_menu_item { split = true }
  --     end, { buffer = cx.bufnr })
  --
  --     vim.keymap.set('n', '<C-t>', function()
  --       harpoon.ui:select_menu_item { tabedit = true }
  --     end, { buffer = cx.bufnr })
  --
  --     vim.keymap.set('n', 'dd', function()
  --       print(vim.inspect(cx))
  --     end)
  --   end,
  -- }

  local opts = function(desc)
    return { noremap = true, silent = true, desc = desc or '' }
  end

  local keymap = vim.keymap.set

  keymap('n', '<leader>ha', function()
    harpoon:list():add()
  end, opts '[H]arpoon [A]dd to quick menu')

  keymap('n', '<leader>hd', function()
    harpoon:list():remove()
  end, opts '[H]arpoon [D]elete current buffer')

  keymap('n', '<leader>hc', function()
    require('harpoon.list'):clear()
  end, opts '[H]arpoon [C]lear all')

  keymap('n', '<leader>hq', function()
    -- harpoon.ui:toggle_quick_menu(harpoon:list())
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
