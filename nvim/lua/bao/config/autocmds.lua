vim.api.nvim_create_user_command("OilCd", function(args)
	vim.cmd("Oil " .. args.args)
	vim.cmd("cd " .. args.args)
end, { nargs = 1 })

vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = "java",
	callback = function()
		require("bao.config.jdtls_conf").setup_jdtls()
	end,
	desc = "Start jdtls",
})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local map = vim.keymap.set
		local telescope = require("telescope.builtin")

		map("n", "<leader>rn", vim.lsp.buf.rename, { buffer = args.buf, desc = "Code rename" })
		map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { buffer = args.buf, desc = "Code actions" })
		map("n", "gd", vim.lsp.buf.definition, { buffer = args.buf, desc = "Code go to definition" })
		map("n", "gi", telescope.lsp_implementations, { buffer = args.buf, desc = "Code go to implementations" })
		map("n", "gr", telescope.lsp_references, { buffer = args.buf, desc = "Code go to references" })
		map("n", "K", vim.lsp.buf.hover, { buffer = args.buf, desc = "Code hover" })
	end,
})
