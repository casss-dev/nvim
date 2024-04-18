local M = {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim' },
  event = 'VeryLazy',
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

  keymap('n', '<m-m>', function()
    harpoon:list():add()
    vim.notify 'Harpooned file 𐃆  '
  end, opts '[M]ark file in harpoon list')

  keymap('n', '<leader>hd', function()
    harpoon:list():remove()
  end, opts '[H]arpoon [D]elete current buffer')

  keymap('n', '<leader>hc', function()
    harpoon:list():clear()
    vim.notify 'Cleared harpoon list 🧹'
  end, opts '[H]arpoon [C]lear all')

  keymap('n', '<tab>', function()
    harpoon.ui:toggle_quick_menu(harpoon:list())
    -- toggle_telescope(harpoon:list())
  end, opts 'Toggle [H]arpoon [Q]uick menu')

  keymap('n', '<leader>1', function()
    harpoon:list():select(1)
  end, opts '[1]st harpoon item')
  keymap('n', '<leader>2', function()
    harpoon:list():select(2)
  end, opts '[2]nd hapoon item')
  keymap('n', '<leader>3', function()
    harpoon:list():select(3)
  end, opts '[3]rd harpoon item')
  keymap('n', '<leader>4', function()
    harpoon:list():select(4)
  end, opts '[4]th harpoon item')

  keymap('n', '<S-h>', function()
    harpoon:list():prev { ui_nav_wrap = true }
  end, opts 'Toggle [P]revious buffer in harpoon list')
  keymap('n', '<S-l>', function()
    harpoon:list():next { ui_nav_wrap = true }
  end, opts 'Toggle [N]ext buffer in harpoon list')
end

return M
