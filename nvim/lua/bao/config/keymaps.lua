vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Unmap default lsp keymaps
vim.keymap.del("n", "grn")
vim.keymap.del({ "n", "v" }, "gra")
vim.keymap.del("n", "grr")
vim.keymap.del("n", "gri")
vim.keymap.del("n", "gO")

-- Better up and down on wrapped line
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

vim.keymap.set("n", "<leader>sc", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight", silent = true })

vim.keymap.set("n", "<C-n>", "<cmd>bn<cr>", { desc = "Next buffer", silent = true })
vim.keymap.set("n", "<C-p>", "<cmd>bp<cr>", { desc = "Previous buffer", silent = true })
vim.keymap.set("n", "<C-o>", "<cmd>e #<cr>", { desc = "Previous buffer", silent = true })
vim.keymap.set("n", "<C-x>", "<cmd>bd<cr>", { desc = "Delete buffer", silent = true })

-- Move lines up/down and auto indent
vim.keymap.set(
	"v",
	"J",
	":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv",
	{ desc = "Move line down", silent = true }
)
vim.keymap.set(
	"v",
	"K",
	":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv",
	{ desc = "Move line up", silent = true }
)

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
vim.keymap.set("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
vim.keymap.set("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
vim.keymap.set("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
vim.keymap.set("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

local opening_brackets = { "{", "[", "(" }
local closing_brackets = { "}", "]", ")" }
for key, c in pairs(opening_brackets) do
	vim.keymap.set("i", c .. "<CR>", c .. "<CR>" .. closing_brackets[key] .. "<ESC>kA<CR>", {})
end

vim.keymap.set("v", "Y", '"+y', {})
vim.keymap.set("n", "Y", '"+y$', {})
vim.keymap.set({ "n", "v" }, "P", '"+p', {})
