vim.api.nvim_create_autocmd("FileType", {
	once = true,
	pattern = { "cs" },
	callback = function() require("roslyn").setup() end,
})

vim.lsp.config("roslyn", {
	settings = {
		["csharp|background_analysis"] = {
			dotnet_analyzer_diagnostics_scope = "fullSolution",
			dotnet_compiler_diagnostics_scope = "fullSolution",
		},
		["csharp|code_lens"] = {
			dotnet_enable_references_code_lens = true,
			dotnet_enable_tests_code_lens = false,
		},
		["csharp|completion"] = {
			dotnet_provide_regex_completions = true,
			dotnet_show_completion_items_from_unimported_namespaces = true,
			dotnet_show_name_completion_suggestions = true,
		},
		["csharp|symbol_search"] = {
			dotnet_search_reference_assemblies = true,
		},
		["csharp|formatting"] = {
			dotnet_organize_imports_on_format = true,
		},
	},
})

vim.lsp.enable("roslyn")
