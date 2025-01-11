return {
	"stevearc/oil.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {},
	config = function()
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
				is_always_hidden = function(name, bufnr)
					return name == ".."
				end,
			},
			keymaps = {
				["`"] = {
					function()
						local cwd = vim.fn.getcwd()
						vim.ui.input({
							prompt = "Change directory: ",
							default = cwd .. "/",
						}, function(input)
							if input then
								vim.cmd("OilCd " .. input)
							end
						end)
					end,
					desc = "Change directory",
				},
			},
		})
		vim.keymap.set("n", "<leader>pv", ":Oil<CR>", {})
	end,
}
