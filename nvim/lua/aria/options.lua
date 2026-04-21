vim.o.showmode = false
vim.o.nu = true
vim.o.relativenumber = true

vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.smartindent = true

vim.o.scrolloff = 8
vim.o.signcolumn = "number"

vim.o.completeopt = "menu,menuone,fuzzy,popup,noselect"
vim.o.confirm = true -- confirm prompt to save file before quit
vim.o.cursorline = true
vim.o.cursorlineopt = "number"
vim.o.pumblend = 10 -- transparent popup menu
vim.o.pumheight = 20 -- max items in popup menu
vim.o.virtualedit = "block"
vim.o.winborder = "rounded"

vim.diagnostic.config({
	virtual_text = true,
	severity_sort = true,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.HINT] = " ",
			[vim.diagnostic.severity.INFO] = " ",
		},
	},
})
