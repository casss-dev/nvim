-- vim.cmd set omnifunc=v:lua.vim.lsp.omnifunc once a buffer is opened
return {
  cmd = { '/usr/bin/sourcekit-lsp' },
  -- cmd = { '/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/sourcekit-lsp' },
  -- root_dir = function(filename, bufnr)
  --   -- Below fixes lsp root_dir when modules are nested within xcode projects
  --   -- This default to using the correct root_dir based vim's working directory
  --   local util = require 'lspconfig.util'
  --   return util.root_pattern('Package.swift', '.git')(filename)
  -- end,
}
