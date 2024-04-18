-- Shows nested objects at the top of a buffer
local M = {
  'LunarVim/breadcrumbs.nvim',
}

function M.config()
  require('breadcrumbs').setup()
end

return M
