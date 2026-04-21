vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Unmap default lsp keymaps
vim.keymap.del({ "n", "v" }, "gra")
vim.keymap.del("n", "gri")
vim.keymap.del("n", "grn")
vim.keymap.del("n", "grr")
vim.keymap.del("n", "grt")
vim.keymap.del("n", "grx")
vim.keymap.del("n", "gO")

-- Move up and down on wrapped line
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

vim.keymap.set("n", "<leader>sc", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight", silent = true })

vim.keymap.set("n", "<C-o>", "<cmd>e #<cr>", { desc = "Previous buffer", silent = true })

-- Move lines up/down and auto indent
vim.keymap.set("v", "J", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move lines down", silent = true })
vim.keymap.set("v", "K", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move lines up", silent = true })

-- Indent/Unindent and reselect that lines
vim.keymap.set("v", "<", "<gv", { desc = "Unindent lines", silent = true })
vim.keymap.set("v", ">", ">gv", { desc = "Indent lines", silent = true })

local diagnostic_goto = function(next, severity)
	severity = severity and vim.diagnostic.severity[severity] or nil
	return function()
		vim.diagnostic.jump({
			count = next and 1 or -1,
			float = true,
			severity = severity,
		})
	end
end
vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "View Diagnostics" })
vim.keymap.set("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
vim.keymap.set("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })

local opening_brackets = { "{", "[", "(" }
local closing_brackets = { "}", "]", ")" }
for i, b in pairs(opening_brackets) do
	vim.keymap.set("i", b .. "<CR>", b .. "<CR>" .. closing_brackets[i] .. "<ESC>kA<CR>", { desc = "Close bracket on newline" })
end

vim.keymap.set("v", "Y", '"+y', { desc = "Copy to system clipboard" })
vim.keymap.set("n", "Y", '"+y$', { desc = "Copy to system clipboard" })
vim.keymap.set({ "n", "v" }, "P", '"+p', { desc = "Paste from system clipboard" })
