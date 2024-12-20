-- Autocompletion
local M = {
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
    -- Snippet Engine & its associated nvim-cmp source
    {
      'L3MON4D3/LuaSnip',
      build = (function()
        -- Build Step is needed for regex support in snippets.
        -- This step is not supported in many windows environments.
        -- Remove the below condition to re-enable on windows.
        if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
          return
        end
        return 'make install_jsregexp'
      end)(),
      dependencies = {
        -- `friendly-snippets` contains a variety of premade snippets.
        --    See the README about individual language/framework/plugin snippets:
        --    https://github.com/rafamadriz/friendly-snippets
        -- {
        --   'rafamadriz/friendly-snippets',
        --   config = function()
        --     require('luasnip.loaders.from_vscode').lazy_load()
        --   end,
        -- },
      },
    },
    { 'saadparwaiz1/cmp_luasnip', event = 'InsertEnter' },

    -- Adds other completion capabilities.
    --  nvim-cmp does not ship with all sources by default. They are split
    --  into multiple repos for maintenance purposes.
    { 'hrsh7th/cmp-nvim-lsp', event = 'InsertEnter' },
    { 'hrsh7th/cmp-path', event = 'InsertEnter' },
    {
      'hrsh7th/cmp-buffer',
      event = 'InsertEnter',
    },
  },
  config = function()
    -- See `:help cmp`
    local cmp = require 'cmp'

    -- MARK: LuaSnip Config

    local luasnip = require 'luasnip'
    luasnip.config.setup {
      -- history = true, -- will let you go back to a snippet
      updateevents = 'TextChanged,TextChangedI', -- shows you in real time rep()
      enable_autosnippets = true,
    }

    require('luasnip.loaders.from_vscode').lazy_load { paths = { '~/.config/nvim/lua/user/snippets/' } }

    -- Refresh snippets
    vim.keymap.set('n', '<leader>ls', function()
      require('luasnip.loaders.from_vscode').load { paths = { '~/.config/nvim/lua/user/snippets/' } }
      print 'Sourced snippets! ✂️'
    end, { desc = 'source [L]ua [S]nippets' })

    local check_backspace = function()
      local col = vim.fn.col '.' - 1
      return col == 0 or vim.fn.getline('.'):sub(col, col):match '%s'
    end

    -- MARK: Rest CMP Config

    local icons = require 'user.icons'

    cmp.setup {
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },

      -- For an understanding of why these mappings were
      -- chosen, you will need to read `:help ins-completion`
      --
      -- No, but seriously. Please read `:help ins-completion`, it is really good!
      mapping = cmp.mapping.preset.insert {
        -- Select the [n]ext item
        ['<C-n>'] = cmp.mapping.select_next_item(),
        -- Select the [p]revious item
        ['<C-p>'] = cmp.mapping.select_prev_item(),

        -- Scroll the documentation window [b]ack / [f]orward
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),

        -- Accept ([y]es) the completion.
        --  This will auto-import if your LSP supports it.
        --  This will expand snippets if the LSP sent a snippet.
        ['<CR>'] = cmp.mapping.confirm { select = true },

        -- Manually trigger a completion from nvim-cmp.
        --  Generally you don't need this, because nvim-cmp will display
        --  completions whenever it has completion options available.
        ['<C-Space>'] = cmp.mapping.complete {},

        -- Think of <c-l> as moving to the right of your snippet expansion.
        --  So if you have a snippet that's like:
        --  function $name($args)
        --    $body
        --  end
        --
        -- <c-l> will move you to the right of each of the expansion locations.
        -- <c-h> is similar, except moving you backwards.
        ['<C-l>'] = cmp.mapping(function()
          if luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          end
        end, { 'i', 's' }),
        ['<C-h>'] = cmp.mapping(function()
          if luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          end
        end, { 'i', 's' }),

        -- NOTE: Super tab from https://github.com/LunarVim/Launch.nvim/blob/master/lua/user/cmp.lua
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expandable() then
            luasnip.expand()
          -- elseif luasnip.expand_or_jumpable() then
          --   luasnip.expand_or_jump()
          elseif check_backspace() then
            fallback()
          -- require("neotab").tabout()
          else
            fallback()
            -- require("neotab").tabout()
          end
        end, {
          'i',
          's',
        }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          -- elseif luasnip.jumpable(-1) then
          --   luasnip.jump(-1)
          else
            fallback()
          end
        end, {
          'i',
          's',
        }),

        -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
        --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
      },
      sources = {
        { name = 'nvim_lsp' },
        { name = 'nvim_lua' },
        { name = 'luasnip' },
        { name = 'path' },
        { name = 'buffer' },
      },
      confirm_opts = {
        behavior = cmp.ConfirmBehavior.Replace,
        select = false,
      },
      window = {
        completion = {
          border = 'rounded',
          scrollbar = false,
        },
        documentation = {
          border = 'rounded',
        },
      },
      formatting = {
        expandable_indicator = true,
        fields = { 'kind', 'abbr', 'menu' },
        format = function(entry, vim_item)
          vim_item.kind = icons.kind[vim_item.kind]
          vim_item.menu = ({
            nvim_lsp = icons.ui.Tree,
            nvim_lua = '',
            luasnip = icons.ui.Pencil,
            buffer = '',
            path = '',
            emoji = '',
          })[entry.source.name]

          -- if entry.source.name == 'emoji' then
          --   vim_item.kind = icons.misc.Smiley
          --   vim_item.kind_hl_group = 'CmpItemKindEmoji'
          -- end

          -- if entry.source.name == 'cmp_tabnine' then
          --   vim_item.kind = icons.misc.Robot
          --   vim_item.kind_hl_group = 'CmpItemKindTabnine'
          -- end

          return vim_item
        end,
      },
    }
  end,
}
return M
