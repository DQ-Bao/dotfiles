local telescope = require("telescope")
local telescope_builtin = require("telescope.builtin")
telescope.setup()
telescope.load_extension("ui-select")
if vim.uv.fs_stat(vim.fn.stdpath("data") .. "/site/pack/core/opt/telescope-fzf-native.nvim/build/libfzf.dll") then
	telescope.load_extension("fzf")
end
vim.keymap.set("n", "<leader>pf", telescope_builtin.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>pb", telescope_builtin.buffers, { desc = "List buffers" })
vim.keymap.set("n", "<leader>pd", telescope_builtin.diagnostics, { desc = "List diagnostics" })
vim.keymap.set("n", "<leader>pg", telescope_builtin.git_files, { desc = "Find files in git repo" })
vim.keymap.set("n", "<leader>ps", telescope_builtin.live_grep, { desc = "Find files by ripgrep" })

local harpoon = require("harpoon")
harpoon:setup()
vim.keymap.set("n", "<leader>pa", function() harpoon:list():add() end, { desc = "Pin buffer" })
vim.keymap.set("n", "<C-n>", function() harpoon:list():next({ ui_nav_wrap = true }) end, { desc = "Next pin" })
vim.keymap.set("n", "<C-p>", function() harpoon:list():prev({ ui_nav_wrap = true }) end, { desc = "Previous pin" })
vim.keymap.set("n", "<leader>pl", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Toggle pin menu" })
