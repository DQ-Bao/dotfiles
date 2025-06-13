vim.api.nvim_create_user_command("OilCd", function(args)
	vim.cmd("Oil " .. args.args)
	vim.cmd("cd " .. args.args)
end, { nargs = 1 })

vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = "java",
	callback = function()
		require("bao.config.jdtls_conf").setup_jdtls()
	end,
	desc = "Start jdtls",
})
