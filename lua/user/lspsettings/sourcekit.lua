-- vim.cmd set omnifunc=v:lua.vim.lsp.omnifunc once a buffer is opened
return {
  cmd = { '/usr/bin/sourcekit-lsp' },
  -- cmd = { '/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/sourcekit-lsp' },
}
