vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			runtime = { version = "Lua 5.1" },
			diagnostics = { globals = { "vim" } },
			workspace = {
				library = {
					vim.env.VIMRUNTIME,
					vim.env.VIMRUNTIME .. "/lua",
				},
				-- library = (function()
				-- 	local libs = { vim.env.VIMRUNTIME, vim.env.VIMRUNTIME .. "/lua" }
				-- 	for _, plugin in ipairs(vim.pack.get()) do
				-- 		local lib_path = plugin.path .. "/lua"
				-- 		if vim.fn.isdirectory(lib_path) then table.insert(libs, lib_path) end
				-- 	end
				-- 	return libs
				-- end)(),
			},
		},
	},
})
vim.lsp.enable("lua_ls")
