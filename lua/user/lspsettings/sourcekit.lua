-- vim.cmd set omnifunc=v:lua.vim.lsp.omnifunc once a buffer is opened

local function cps()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  -- capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
  -- capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true
  return capabilities
end

return {
  cmd = { '/usr/bin/sourcekit-lsp' },
  capabilities = cps(),
  -- cmd = { '/Applications/Xcode-beta.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/sourcekit-lsp' },
  -- root_dir = function(filename, bufnr)
  --   -- Below fixes lsp root_dir when modules are nested within xcode projects
  --   -- This default to using the correct root_dir based vim's working directory
  --   local util = require 'lspconfig.util'
  --   return util.root_pattern('Package.swift', '.git')(filename)
  -- end,
}
