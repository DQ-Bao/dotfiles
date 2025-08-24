vim.g.netrw_browse_split = 0
vim.g.netrw_localmovecmd = "mv"
vim.g.netrw_localmovecmdopt = ""
vim.g.netrw_localcopycmd = "cp"
vim.g.netrw_localcopycmdopt = ""

vim.opt.shell = "cmd"

vim.opt.showmode = false
vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "number"

vim.opt.completeopt = "menu,menuone,fuzzy,popup,noselect"
vim.opt.confirm = true -- confirm prompt to save file before quit
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"
vim.opt.pumblend = 10 -- transparent popup menu
vim.opt.pumheight = 20 -- max items in popup menu
vim.opt.virtualedit = "block"
vim.opt.winborder = "rounded"

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
