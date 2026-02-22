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
		local buf = args.buf
		local builtin = require("telescope.builtin")
		local map = vim.keymap.set
		map("n", "<leader>rn", vim.lsp.buf.rename, { buffer = buf, desc = "Code rename" })
		map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { buffer = buf, desc = "Code actions" })
		map("n", "gd", vim.lsp.buf.definition, { buffer = buf, desc = "Go to definition" })
		map("n", "gi", builtin.lsp_implementations, { buffer = buf, desc = "Go to implementations" })
		map("n", "gr", builtin.lsp_references, { buffer = buf, desc = "Go to references" })
		if vim.bo[buf].filetype == "dart" then
			local telescope = require("telescope")
			telescope.load_extension("flutter")
			map("n", "<leader>fl", telescope.extensions.flutter.commands, { buffer = buf, desc = "Flutter commands" })
			map("n", "<leader>fo", "<cmd>FlutterLogToggle<cr>", { buffer = buf, desc = "Open flutter log" })
		end
	end,
	desc = "Map general lsp keymaps",
})
