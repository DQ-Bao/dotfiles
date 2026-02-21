local function map_general_lsp_keymap(buf)
	local map = vim.keymap.set
	local telescope = require("telescope.builtin")
	map("n", "<leader>rn", vim.lsp.buf.rename, { buffer = buf, desc = "Code rename" })
	map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { buffer = buf, desc = "Code actions" })
	map("n", "gd", vim.lsp.buf.definition, { buffer = buf, desc = "Go to definition" })
	map("n", "gi", telescope.lsp_implementations, { buffer = buf, desc = "Go to implementations" })
	map("n", "gr", telescope.lsp_references, { buffer = buf, desc = "Go to references" })
end

return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup({
				registries = {
					"github:mason-org/mason-registry",
					"github:Crashdummyy/mason-registry",
				},
			})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"clangd",
					"rust_analyzer",
					"jdtls",
					"tailwindcss",
					"ts_ls",
					"html",
					"cssls",
					"gopls",
					"pyright",
				},
				automatic_enable = false,
			})
		end,
	},
	{
		"p00f/clangd_extensions.nvim",
		ft = { "c", "cpp" },
		config = function()
			require("clangd_extensions").setup()
			vim.keymap.set("n", "<leader>sh", ":ClangdSwitchSourceHeader<CR>")
			vim.keymap.set("n", "<leader>ih", ":ClangdToggleInlayHints<CR>")
		end,
	},
	{ "mfussenegger/nvim-jdtls" },
	{
		"mrcjkb/rustaceanvim",
		version = "^6", -- Recommended
		lazy = false, -- This plugin is already lazy
	},
	{
		"nvim-flutter/flutter-tools.nvim",
		ft = "dart",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"stevearc/dressing.nvim", -- optional for vim.ui.select
		},
		config = function()
			require("flutter-tools").setup({
				lsp = {
					color = { enabled = true },
					on_attach = function(_, buf)
						map_general_lsp_keymap(buf)
						local map = vim.keymap.set
						local telescope = require("telescope")
						telescope.load_extension("flutter")
						local flutter_commands = telescope.extensions.flutter.commands
						map("n", "<leader>fl", flutter_commands, { buffer = buf, desc = "Flutter commands" })
						map("n", "<leader>fo", "<cmd>FlutterLogToggle<cr>", { buffer = buf, desc = "Open flutter log" })
					end,
					capabilities = require("cmp_nvim_lsp").default_capabilities(),
					settings = {
						showTodos = true,
						completeFunctionCalls = true,
						renameFilesWithClasses = "prompt", -- "always"
						enableSnippets = true,
						updateImportsOnRename = true,
					},
				},
			})
		end,
	},
	{ "seblyng/roslyn.nvim" },
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			vim.g.rustaceanvim = {
				server = {
					on_attach = function(_, buf)
						map_general_lsp_keymap(buf)
					end,
					capabilities = capabilities,
					default_settings = {
						["rust-analyzer"] = {
							cargo = {
								allFeatures = true,
							},
						},
					},
					status_notify_level = false,
				},
			}

			vim.lsp.config("*", {
				on_attach = function(_, buf)
					map_general_lsp_keymap(buf)
				end,
				capabilities = capabilities,
			})

			vim.lsp.enable("clangd")
			vim.lsp.enable("lua_ls")
			vim.lsp.enable("cssls")
			vim.lsp.enable("html")
			vim.lsp.enable("tailwindcss")
			vim.lsp.enable("ts_ls")
			vim.lsp.enable("glsl_analyzer")
			vim.lsp.enable("roslyn")
			vim.lsp.enable("gopls")
			vim.lsp.enable("pyright")
			vim.lsp.enable("zls")
			vim.lsp.enable("kulala_ls")
		end,
	},
}
