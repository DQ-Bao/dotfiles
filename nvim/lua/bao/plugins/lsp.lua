return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
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
					"omnisharp",
				},
				automatic_enable = false,
			})
		end,
	},
	{
		"p00f/clangd_extensions.nvim",
		lazy = false,
		config = function()
			require("clangd_extensions").setup()
			vim.keymap.set("n", "<leader>sh", ":ClangdSwitchSourceHeader<CR>")
			vim.keymap.set("n", "<leader>ih", ":ClangdToggleInlayHints<CR>")
		end,
	},
	{
		"Hoffs/omnisharp-extended-lsp.nvim",
		lazy = false,
	},
	{
		"mfussenegger/nvim-jdtls",
	},
	{
		"mrcjkb/rustaceanvim",
		version = "^6", -- Recommended
		lazy = false, -- This plugin is already lazy
	},
	{
		"nvim-flutter/flutter-tools.nvim",
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"stevearc/dressing.nvim", -- optional for vim.ui.select
		},
		config = function()
			require("flutter-tools").setup({
				lsp = {
					color = { enabled = true },
					on_attach = function(_, buf)
						local map = vim.keymap.set
						local telescope = require("telescope.builtin")
						require("telescope").load_extension("flutter")

						map("n", "<leader>rn", vim.lsp.buf.rename, { buffer = buf, desc = "Code rename" })
						map(
							{ "n", "v" },
							"<leader>ca",
							vim.lsp.buf.code_action,
							{ buffer = buf, desc = "Code actions" }
						)
						map("n", "gd", vim.lsp.buf.definition, { buffer = buf, desc = "Go to definition" })
						map("n", "gi", telescope.lsp_implementations, { buffer = buf, desc = "Go to implementations" })
						map("n", "gr", telescope.lsp_references, { buffer = buf, desc = "Go to references" })
						map(
							"n",
							"<leader>fl",
							require("telescope").extensions.flutter.commands,
							{ buffer = buf, desc = "Flutter commands" }
						)
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
	{
		"rest-nvim/rest.nvim",
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/nvim-cmp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/nvim-cmp",
			"L3MON4D3/LuaSnip",
		},
		config = function()
			local function on_attach(_, buf)
				local map = vim.keymap.set
				local telescope = require("telescope.builtin")

				map("n", "<leader>rn", vim.lsp.buf.rename, { buffer = buf, desc = "Code rename" })
				map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { buffer = buf, desc = "Code actions" })
				map("n", "gd", vim.lsp.buf.definition, { buffer = buf, desc = "Go to definition" })
				map("n", "gi", telescope.lsp_implementations, { buffer = buf, desc = "Go to implementations" })
				map("n", "gr", telescope.lsp_references, { buffer = buf, desc = "Go to references" })
			end
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			vim.g.rustaceanvim = {
				server = {
					on_attach = on_attach,
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

			vim.lsp.config("clangd", {
				on_attach = on_attach,
				capabilities = capabilities,
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

			vim.lsp.config("lua_ls", {
				on_attach = on_attach,
				capabilities = capabilities,
				settings = {
					Lua = {
						runtime = { version = "Lua 5.1" },
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							library = {
								vim.env.VIMRUNTIME,
								vim.env.VIMRUNTIME .. "/lua",
							},
						},
					},
				},
			})
			vim.lsp.enable("lua_ls")

			local html_css_cap = require("cmp_nvim_lsp").default_capabilities()
			html_css_cap.textDocument.completion.completionItem.snippetSupport = true
			vim.lsp.config("cssls", {
				on_attach = on_attach,
				capabilities = html_css_cap,
			})
			vim.lsp.enable("cssls")

			vim.lsp.config("html", {
				on_attach = on_attach,
				capabilities = html_css_cap,
			})
			vim.lsp.enable("html")

			vim.lsp.config("tailwindcss", {
				on_attach = on_attach,
				capabilities = capabilities,
			})
			vim.lsp.enable("tailwindcss")

			vim.lsp.config("ts_ls", {
				on_attach = on_attach,
				capabilities = capabilities,
				settings = {
					single_file_support = false,
					settings = {
						typescript = {
							inlayHints = {
								includeInlayParameterNameHints = "literal",
								includeInlayParameterNameHintsWhenArgumentMatchesName = false,
								includeInlayFunctionParameterTypeHints = true,
								includeInlayVariableTypeHints = false,
								includeInlayPropertyDeclarationTypeHints = true,
								includeInlayFunctionLikeReturnTypeHints = true,
								includeInlayEnumMemberValueHints = true,
							},
						},
						javascript = {
							inlayHints = {
								includeInlayParameterNameHints = "all",
								includeInlayParameterNameHintsWhenArgumentMatchesName = false,
								includeInlayFunctionParameterTypeHints = true,
								includeInlayVariableTypeHints = true,
								includeInlayPropertyDeclarationTypeHints = true,
								includeInlayFunctionLikeReturnTypeHints = true,
								includeInlayEnumMemberValueHints = true,
							},
						},
					},
				},
			})
			vim.lsp.enable("ts_ls")

			vim.lsp.config("glsl_analyzer", {
				on_attach = on_attach,
				capabilities = capabilities,
			})
			vim.lsp.enable("glsl_analyzer")

			vim.lsp.config("omnisharp", {
				on_attach = function(_, buf)
					local map = vim.keymap.set
					local omni = require("omnisharp_extended")

					map("n", "<leader>rn", vim.lsp.buf.rename, { buffer = buf, desc = "Code rename" })
					map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { buffer = buf, desc = "Code actions" })
					map("n", "gd", omni.telescope_lsp_definition, { buffer = buf, desc = "Go to definition" })
					map("n", "gi", omni.telescope_lsp_implementation, { buffer = buf, desc = "Go to implementations" })
					map("n", "gr", omni.telescope_lsp_references, { buffer = buf, desc = "Go to references" })
				end,
				capabilities = capabilities,
				settings = {
					FormattingOptions = {
						EnableEditorConfigSupport = true,
						OrganizeImports = true,
					},
					MsBuild = {
						Enabled = true,
						LoadProjectsOnDemand = true,
					},
					RoslynExtensionsOptions = {
						EnableAnalyzersSupport = true,
						EnableDecompilationSupport = true,
						EnableImportCompletion = true,
					},
				},
			})
			vim.lsp.enable("omnisharp")

			vim.lsp.config("gopls", {
				on_attach = on_attach,
				capabilities = capabilities,
			})
			vim.lsp.enable("gopls")

			local cmp = require("cmp")
			local cmp_select = { behavior = cmp.SelectBehavior.Select }
			cmp.setup({
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
				}, {
					{ name = "buffer" },
					{ name = "path" },
				}),
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-k>"] = cmp.mapping.select_prev_item(cmp_select),
					["<C-j>"] = cmp.mapping.select_next_item(cmp_select),
					["<C-y>"] = cmp.mapping.confirm({ select = true }),
					["<C-Space>"] = cmp.mapping.complete(),
				}),
				sorting = {
					comparators = {
						cmp.config.compare.offset,
						cmp.config.compare.exact,
						cmp.config.compare.recently_used,
						require("clangd_extensions.cmp_scores"),
						cmp.config.compare.kind,
						cmp.config.compare.sort_text,
						cmp.config.compare.length,
						cmp.config.compare.order,
					},
				},
			})
		end,
	},
}
