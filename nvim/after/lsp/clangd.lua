return {
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
}
