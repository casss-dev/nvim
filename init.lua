require 'user.launch'
require 'user.core.options'
require 'user.core.keymaps'
require 'user.core.autocmds'
require 'user.themes'

spec 'user.autotab'
spec 'user.comment'
spec 'user.gitsigns'
spec 'user.whichkey'
spec 'user.telescope'

spec 'user.arrow'
-- spec 'user.harpoon' -- using arrow instead

spec 'user.cmp'
spec 'user.lsp'
spec 'user.debug'
spec 'user.java-lsp'
spec 'user.format'
spec 'user.todo'
spec 'user.mini'
spec 'user.treesitter'
spec 'user.oil'
-- spec 'user.neo-tree'

-- spec 'user.terminal' -- messes up godot server go to file

spec 'user.autopairs'
spec 'user.hop'
spec 'user.breadcrumbs'
spec 'user.navic'
spec 'user.tmux'
spec 'user.maximize'
spec 'user.symbol-outline'
spec 'user.multi-cursors'
spec 'user.macro-recorder'

require 'user.godot'

-- MARK: Extras
spec 'user.extras.zen-mode'
spec 'user.extras.ufo'
spec 'user.extras.xcodebuild'
spec 'user.extras.obsidian'
spec 'user.extras.colorizer'

-- MARK: Screen savers
-- spec 'user.extras.donut'

require 'user.lazy'
require 'current-theme'

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
