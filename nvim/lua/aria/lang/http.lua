vim.api.nvim_create_autocmd("FileType", {
	once = true,
	pattern = { "http", "rest" },
	callback = function()
		require("kulala").setup({
			global_keymaps = true,
			global_keymaps_prefix = "<leader>R",
			kulala_keymaps_prefix = "",
		})
	end,
})

vim.lsp.enable("kulala_ls")
