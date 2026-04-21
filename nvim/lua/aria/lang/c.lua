local M = {}

---@param buf integer
---@param client_id integer
M.set_keymaps_if_has_client = function(buf, client_id)
	local client = vim.lsp.get_client_by_id(client_id)
	if client and client.name == "clangd" then
		vim.keymap.set(
			"n",
			"<leader>sh",
			"<cmd>LspClangdSwitchSourceHeader<cr>",
			{ buf = buf, desc = "Switch source and header", silent = true }
		)
	end
end

if vim.g.aria_configured_lang_c then return M end
vim.g.aria_configured_lang_c = true

vim.lsp.config("clangd", {
	cmd = {
		"clangd",
		"--background-index",
		"--completion-style=detailed",
		"--function-arg-placeholders",
		"--header-insertion=iwyu",
		"--header-insertion-decorators",
		"--enable-config",
		"--log=verbose",
	},
})
vim.lsp.enable("clangd")

return M
