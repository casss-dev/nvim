local projectfile = vim.fn.getcwd() .. '/project.godot'

local function file_exists(name)
  local f = io.open(name, 'r')
  return f ~= nil and io.close(f)
end

if file_exists(projectfile) then
  vim.fn.serverstart './godothost'
end
