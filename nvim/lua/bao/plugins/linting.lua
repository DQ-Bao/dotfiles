return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")
		lint.linters_by_ft = {
			c = { "cpplint" },
			cpp = { "cpplint" },
		}
		local lint_augroup = vim.api.nvim_create_augroup("Linting", { clear = true })

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				lint.try_lint()
			end,
		})

		vim.keymap.set("n", "<leader>ml", function()
			lint.try_lint()
		end, { desc = "Linting" })
	end,
}
