return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("telescope").setup()
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>pf", builtin.find_files, { desc = "Find files" })
			vim.keymap.set("n", "<leader>pb", builtin.buffers, { desc = "List buffers" })
			vim.keymap.set("n", "<leader>pd", builtin.diagnostics, { desc = "List diagnostics" })
			vim.keymap.set("n", "<leader>pg", builtin.git_files, { desc = "Find files in git repo" })
			vim.keymap.set("n", "<leader>ps", function()
				builtin.grep_string({ search = vim.fn.input("Grep > ") })
			end, { desc = "Find files by grep" })
		end,
	},
	{
		"stevearc/dressing.nvim",
		opts = {},
	},
}
