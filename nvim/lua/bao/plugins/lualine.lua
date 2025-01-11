return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		options = {
			icons_enabled = true,
			theme = "kanagawa",
		},
		sections = {
			lualine_c = {
				{
					"filename",
					path = 2,
					symbols = { unnamed = vim.fn.getcwd() },
				},
			},
		},
	},
}
