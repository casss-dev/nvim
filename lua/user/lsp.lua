-- LSP Configuration & Plugins
local M = {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    -- Automatically install LSPs and related tools to stdpath for Neovim
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',

    -- Useful status updates for LSP.
    -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
    { 'j-hui/fidget.nvim', opts = {} },

    -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    { 'folke/neodev.nvim', opts = {} },
  },
}

local function on_attach(event)
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local map = function(keys, func, desc)
    vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
  end

  -- Jump to the definition of the word under your cursor.
  --  This is where a variable was first declared, or where a function is defined, etc.
  --  To jump back, press <C-t>.
  map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

  map('g<C-d>', function()
    require('telescope.builtin').lsp_definitions { jump_type = 'tab' }
  end, '[G]oto [D]efinition in new tab')

  -- Find references for the word under your cursor.
  map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

  -- Jump to the implementation of the word under your cursor.
  --  Useful when your language has ways of declaring types without an actual implementation.
  map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

  -- Shows a window with more info on errors, warnings, etc...
  map('gl', vim.diagnostic.open_float, 'Opens floating diagnostic window')

  -- Jump to the type of the word under your cursor.
  --  Useful when you're not sure what type a variable is and you want to see
  --  the definition of its *type*, not where it was *defined*.
  map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

  -- Fuzzy find all the symbols in your current document.
  --  Symbols are things like variables, functions, types, etc.
  map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

  -- workspace management. Necessary for multi-module projects
  map('<space>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd')

  map('<space>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove')

  map('<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist')

  -- Fuzzy find all the symbols in your current workspace.
  --  Similar to document symbols, except searches over your entire project.
  map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- Rename the variable under your cursor.
  --  Most Language Servers support renaming across files, etc.
  map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

  -- Execute a code action, usually your cursor needs to be on top of an error
  -- or a suggestion from your LSP for this to activate.
  map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  -- Opens a popup that displays documentation about the word under your cursor
  --  See `:help K` for why this keymap.
  map('K', vim.lsp.buf.hover, 'Hover Documentation')

  -- NOTE: This is not Goto Definition, this is Goto Declaration.
  --  For example, in C this would take you to the header.
  map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

  map('<leader>lr', function()
    vim.cmd 'LspRestart'
    vim.cmd 'LspStart'
  end, '[L]SP start')

  -- The following two autocommands are used to highlight references of the
  -- word under your cursor when your cursor rests there for a little while.
  --    See `:help CursorHold` for information about when this is executed
  --
  -- When you move your cursor, the highlights will be cleared (the second autocommand).
  local client = vim.lsp.get_client_by_id(event.data.client_id)

  if client.server_capabilities.inlayHintProvider and client.supports_method 'textDocument/inlayHint' and vim.lsp.buf.inlay_hint then
    vim.lsp.buf.inlay_hint(event.buf, true)
  end

  -- if client.supports_method 'textDocument/inlayHint' then
  --   vim.lsp.inlay_hint.enable(bufnr, true)
  -- end

  if client and client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
      buffer = event.buf,
      callback = vim.lsp.buf.document_highlight,
    })

    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
      buffer = event.buf,
      callback = vim.lsp.buf.clear_references,
    })
  end
end

function M.common_capabilities()
  -- LSP servers and clients are able to communicate to each other what features they support.
  --  By default, Neovim doesn't support everything that is in the LSP specification.
  --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
  --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  return capabilities
end

-- A user command to list the lsp server capabilities of the current buffer
local function create_list_capabilities_cmd()
  vim.api.nvim_create_user_command('LspCapabilities', function()
    local curBuf = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_active_clients { bufnr = curBuf }

    for _, client in pairs(clients) do
      if client.name ~= 'null-ls' then
        local capAsList = {}
        for key, value in pairs(client.server_capabilities) do
          if value and key:find 'Provider' then
            local capability = key:gsub('Provider$', '')
            table.insert(capAsList, '- ' .. capability)
          end
        end
        table.sort(capAsList) -- sorts alphabetically
        local msg = '# ' .. client.name .. '\n' .. table.concat(capAsList, '\n')
        vim.notify(msg, 'trace', {
          on_open = function(win)
            local buf = vim.api.nvim_win_get_buf(win)
            vim.api.nvim_buf_set_option(buf, 'filetype', 'markdown')
          end,
          timeout = 14000,
        })
        vim.fn.setreg('+', 'Capabilities = ' .. vim.inspect(client.server_capabilities))
      end
    end
  end, {})
end

function M.config()
  -- Brief aside: **What is LSP?**
  --
  -- LSP is an initialism you've probably heard, but might not understand what it is.
  --
  -- LSP stands for Language Server Protocol. It's a protocol that helps editors
  -- and language tooling communicate in a standardized fashion.
  --
  -- In general, you have a "server" which is some tool built to understand a particular
  -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
  -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
  -- processes that communicate with some "client" - in this case, Neovim!
  --
  -- LSP provides Neovim with features like:
  --  - Go to definition
  --  - Find references
  --  - Autocompletion
  --  - Symbol Search
  --  - and more!
  --
  -- Thus, Language Servers are external tools that must be installed separately from
  -- Neovim. This is where `mason` and related plugins come into play.
  --
  -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
  -- and elegantly composed help section, `:help lsp-vs-treesitter`

  --  This function gets run when an LSP attaches to a particular buffer.
  --  That is to say, every time a new file is opened that is associated with
  --  an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
  --  function will be executed to configure the current buffer
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
    callback = on_attach,
  })

  local icons = require 'user.icons'

  local default_diagnostic_config = {
    signs = {
      active = true,
      values = {
        { name = 'DiagnosticSignError', text = icons.diagnostics.Error },
        { name = 'DiagnosticSignWarn', text = icons.diagnostics.Warning },
        { name = 'DiagnosticSignHint', text = icons.diagnostics.Hint },
        { name = 'DiagnosticSignInfo', text = icons.diagnostics.Information },
      },
    },
    virtual_text = true,
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = {
      focusable = true,
      style = 'minimal',
      border = 'rounded',
      source = 'always',
      header = '',
      prefix = '',
    },
  }

  vim.diagnostic.config(default_diagnostic_config)

  for _, sign in ipairs(vim.tbl_get(vim.diagnostic.config(), 'signs', 'values') or {}) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
  end

  -- Rounded borders
  vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' })
  vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' })
  require('lspconfig.ui.windows').default_options.border = 'rounded'

  -- Enable the following language servers
  --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
  --
  --  Add any additional override configuration in the following tables. Available keys are:
  --  - cmd (table): Override the default command used to start the server
  --  - filetypes (table): Override the default list of associated filetypes for the server
  --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
  --  - settings (table): Override the default settings passed when initializing the server.
  --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
  local servers = {
    'lua_ls',
    'pyright',
    'jsonls',
    'bashls',
  }

  -- Ensure the servers and tools above are installed
  --  To check the current status of installed tools and/or manually install
  --  other tools, you can run
  --    :Mason
  --
  --  You can press `g?` for help in this menu.
  require('mason').setup {
    ui = {
      border = 'rounded',
    },
  }

  -- You can add other tools here that you want Mason to install
  -- for you, so that they are available from within Neovim.
  local ensure_installed = servers -- vim.tbl_keys(servers or {})
  vim.list_extend(ensure_installed, {
    'stylua', -- Used to format Lua code
  })
  require('mason-tool-installer').setup { ensure_installed = ensure_installed }

  -- Creates specific opts for an LSP
  local function make_opts(server_name)
    local opts = {
      on_attach = M.on_attach,
      capabilities = M.common_capabilities(),
    }
    local require_ok, settings = pcall(require, 'user.lspsettings.' .. server_name)
    if require_ok then
      opts = vim.tbl_deep_extend('force', settings, opts)
    end
    return opts
  end

  require('mason-lspconfig').setup {
    handlers = {
      function(server_name)
        local opts = make_opts(server_name)
        if server_name == 'lua_ls' then
          require('neodev').setup {}
        end
        -- This handles overriding only values explicitly passed
        -- by the server configuration above. Useful when disabling
        -- certain features of an LSP (for example, turning off formatting for tsserver)
        -- server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
        require('lspconfig')[server_name].setup(opts)
      end,
    },
  }

  -- For LSPs not included in mason or ensured to be installed...
  local custom_servers = {
    'sourcekit',
    'gdscript',
    -- 'cssls', -- NOTE: I guess you don't need to manually do this, you can just use Mason
  }
  for _, server in ipairs(custom_servers) do
    local opts = make_opts(server)
    require('lspconfig')[server].setup(opts)
  end

  create_list_capabilities_cmd()
end

return M
