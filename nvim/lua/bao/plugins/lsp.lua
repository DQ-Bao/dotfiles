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

			vim.lsp.config("*", { capabilities = capabilities })
			vim.lsp.enable("clangd")
			vim.lsp.enable("cmake")
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
			vim.lsp.enable("ols")
		end,
	},
}
