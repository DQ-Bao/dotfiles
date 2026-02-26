return {
	"stevearc/oil.nvim",
	dependencies = {
		"nvim-mini/mini.icons",
		"nvim-tree/nvim-web-devicons",
	},
	opts = {},
	config = function()
		require("mini.icons").setup()
		require("oil").setup({
			columns = {
				"icon",
				"permissions",
				"size",
				"mtime",
			},
			win_options = {
				wrap = true,
			},
			view_options = {
				show_hidden = true,
				is_always_hidden = function(name, _)
					return name == ".."
				end,
			},
			keymaps = {
				["<leader>y"] = {
					function()
						local oil = require("oil")
						local entry = oil.get_cursor_entry()
						if not entry then
							return
						end
						local path = oil.get_current_dir() .. entry.name
						vim.fn.setreg("+", path)
					end,
					desc = "Copy path",
				},
			},
		})
		vim.keymap.set("n", "<leader>pv", ":Oil<CR>", {})
	end,
}
