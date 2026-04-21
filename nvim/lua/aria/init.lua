require("aria.options")
require("aria.keymaps")

vim.pack.add({
	"https://github.com/rebelot/kanagawa.nvim",
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/nvim-mini/mini.icons",
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/stevearc/oil.nvim",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/L3MON4D3/LuaSnip",
	"https://github.com/hrsh7th/nvim-cmp",
	"https://github.com/hrsh7th/cmp-nvim-lsp",
	"https://github.com/hrsh7th/cmp-buffer",
	"https://github.com/hrsh7th/cmp-path",
	"https://github.com/hrsh7th/cmp-cmdline",
	"https://github.com/saadparwaiz1/cmp_luasnip",
	"https://github.com/rafamadriz/friendly-snippets",
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/mfussenegger/nvim-lint",
	"https://github.com/nvim-telescope/telescope.nvim",
	"https://github.com/nvim-telescope/telescope-fzf-native.nvim",
	"https://github.com/nvim-telescope/telescope-ui-select.nvim",
	{ src = "https://github.com/ThePrimeagen/harpoon", version = "harpoon2" },
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/stevearc/dressing.nvim",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/mfussenegger/nvim-jdtls",
	{ src = "https://github.com/mrcjkb/rustaceanvim", version = vim.version.range("^9") },
	"https://github.com/mistweaverco/kulala.nvim",
	"https://github.com/seblyng/roslyn.nvim",
	"https://github.com/sindrets/diffview.nvim",
	"https://github.com/NeogitOrg/neogit",
	"https://github.com/folke/which-key.nvim",
})

vim.cmd.colorscheme("kanagawa")

require("aria.ui")
require("mason").setup({
	registries = {
		"github:mason-org/mason-registry",
		"github:Crashdummyy/mason-registry",
	},
})
require("aria.explorer")
require("aria.completion")
require("aria.format_lint")
require("aria.navigation")
require("aria.lang")
