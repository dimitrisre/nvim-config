return {
		{ "williamboman/mason.nvim" },
		{ "williamboman/mason-lspconfig.nvim" },
		{ "neovim/nvim-lspconfig" },
		{ "nvim-telescope/telescope-ui-select.nvim" },
		{ "nvimtools/none-ls.nvim" },
		{ "hrsh7th/nvim-cmp" },
		{
			"L3MON4D3/LuaSnip",
			dependencies = { "saadparwaiz1/cmp_luasnip", "rafamadriz/friendly-snippets" },
		},
		{ "hrsh7th/cmp-nvim-lsp" },
		{
			"christoomey/vim-tmux-navigator",
			cmd = {
				"TmuxNavigateLeft",
				"TmuxNavigateDown",
				"TmuxNavigateUp",
				"TmuxNavigateRight",
				"TmuxNavigatePrevious",
			},
			keys = {
				{ "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
				{ "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
				{ "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
				{ "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
				{ "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
			},
		},
		{
			"goolord/alpha-nvim",
			dependencies = {
				"echasnovski/mini.icons",
				"nvim-lua/plenary.nvim",
			},
			config = function()
				require("alpha").setup(require("alpha.themes.theta").config)
			end,
		},
}	
