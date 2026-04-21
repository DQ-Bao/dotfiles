require("mini.icons").setup()
require("lualine").setup({
	options = { theme = "kanagawa", always_show_tabline = false },
	sections = {
		lualine_c = { { "filename", path = 3 } },
		lualine_x = { "encoding", "fileformat", "filetype", "filesize" },
	},
	tabline = { lualine_a = { { "tabs", mode = 2, use_mode_colors = true, show_modified_status = false } } },
})
