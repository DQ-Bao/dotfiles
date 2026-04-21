vim.lsp.config("*", { capabilities = require("cmp_nvim_lsp").default_capabilities() })
local c = require("aria.lang.c")
require("aria.lang.lua")
require("aria.lang.http")
require("aria.lang.rust")
require("aria.lang.csharp")
require("aria.lang.typescript")
vim.lsp.enable("cssls")
vim.lsp.enable("glsl_analyzer")
vim.lsp.enable("gopls")
vim.lsp.enable("html")
vim.lsp.enable("jdtls")
vim.lsp.enable("ols")
vim.lsp.enable("pyright")
vim.lsp.enable("zls")

vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		local treesitter = require("nvim-treesitter")
		local builtin_parsers = { "c", "lua", "markdown", "markdown_inline", "query", "vim", "vimdoc" }
		local lang = vim.treesitter.language.get_lang(args.match)
		if vim.list_contains(treesitter.get_available(), lang) then
			if not vim.tbl_contains(treesitter.get_installed(), lang) and not vim.list_contains(builtin_parsers, lang) then
				treesitter.install(lang):await(function() vim.treesitter.start() end)
			else
				vim.treesitter.start()
			end
		end
	end,
	desc = "Install parser if needed and start treesitter",
})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = args.buf, desc = "Code rename" })
		vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { buffer = args.buf, desc = "Code actions" })
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = args.buf, desc = "Go to definition" })
		vim.keymap.set("n", "gi", builtin.lsp_implementations, { buffer = args.buf, desc = "Go to implementations" })
		vim.keymap.set("n", "gr", builtin.lsp_references, { buffer = args.buf, desc = "Go to references" })
		c.set_keymaps_if_has_client(args.buf, args.data.client_id)
	end,
	desc = "Map lsp keymaps",
})
