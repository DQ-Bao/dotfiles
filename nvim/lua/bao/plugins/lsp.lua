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
		"mfussenegger/nvim-jdtls",
	},
	{
		"mrcjkb/rustaceanvim",
		version = "^6",
		lazy = false,
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
			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local on_attach = function(_, _)
				local map = vim.keymap.set
				local telescope = require("telescope.builtin")
				map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Code rename" })
				map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })
				map("n", "gd", vim.lsp.buf.definition, { desc = "Code go to definition" })
				map("n", "gi", telescope.lsp_implementations, { desc = "Code go to implementations" })
				map("n", "gr", telescope.lsp_references, { desc = "Code go to references" })
				map("n", "K", vim.lsp.buf.hover, { desc = "Code hover" })
			end

			lspconfig.lua_ls.setup({
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

			lspconfig.clangd.setup({
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

			vim.g.rustaceanvim = {
				on_attach = on_attach,
				capabilities = capabilities,
				server = {
					default_settings = {
						["rust_analyzer"] = {
							cargo = {
								allFeatures = true,
							},
						},
					},
				},
			}

			lspconfig.omnisharp.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				filetypes = { "cs" },
			})

			local html_css_cap = require("cmp_nvim_lsp").default_capabilities()
			html_css_cap.textDocument.completion.completionItem.snippetSupport = true
			lspconfig.cssls.setup({
				on_attach = on_attach,
				capabilities = html_css_cap,
			})

			lspconfig.html.setup({
				on_attach = on_attach,
				capabilities = html_css_cap,
			})

			lspconfig.tailwindcss.setup({
				on_attach = on_attach,
				capabilities = capabilities,
			})

			lspconfig.ts_ls.setup({
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
