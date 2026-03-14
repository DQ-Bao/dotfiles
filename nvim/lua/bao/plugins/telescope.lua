return {
	{
		"nvim-telescope/telescope.nvim",
		version = "*",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
		config = function()
			require("telescope").setup()
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>pf", builtin.find_files, { desc = "Find files" })
			vim.keymap.set("n", "<leader>pb", builtin.buffers, { desc = "List buffers" })
			vim.keymap.set("n", "<leader>pd", builtin.diagnostics, { desc = "List diagnostics" })
			vim.keymap.set("n", "<leader>pg", builtin.git_files, { desc = "Find files in git repo" })
			vim.keymap.set("n", "<leader>ps", builtin.live_grep, { desc = "Find files by ripgrep" })
		end,
	},
	{
		"stevearc/dressing.nvim",
		opts = {},
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		dependencies = { "nvim-telescope/telescope.nvim" },
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
				},
			})
			require("telescope").load_extension("ui-select")
		end,
	},
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local harpoon = require("harpoon")
			harpoon:setup()
			vim.keymap.set("n", "<leader>pa", function()
				harpoon:list():add()
			end, { desc = "Pin buffer" })
			vim.keymap.set("n", "<C-n>", function()
				harpoon:list():next({ ui_nav_wrap = true })
			end, { desc = "Next pin" })
			vim.keymap.set("n", "<C-p>", function()
				harpoon:list():prev({ ui_nav_wrap = true })
			end, { desc = "Previous pin" })
			vim.keymap.set("n", "<leader>pl", function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end, { desc = "Toggle pin menu" })
		end,
	},
}
