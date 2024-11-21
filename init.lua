-- Bootstrap lazy.nvim
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set number")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		{ "rose-pine/neovim", name = "rose-pine" },
		{ "binhtran432k/dracula.nvim", lazy = false, priority = 1000, opts = {} },
		{ "marko-cerovac/material.nvim" },
		{ "nvim-telescope/telescope.nvim", tag = "0.1.8", dependencies = { "nvim-lua/plenary.nvim" } },
		{
			"nvim-treesitter/nvim-treesitter",
			build = ":TSUpdate",
			config = function()
				local configs = require("nvim-treesitter.configs")

				configs.setup({
					ensure_installed = {
						"scala",
						"rust",
						"c",
						"lua",
						"vim",
						"vimdoc",
						"query",
						"elixir",
						"heex",
						"javascript",
						"html",
					},
					sync_install = false,
					highlight = { enable = true },
					indent = { enable = true },
				})
			end,
		},
		{
			"nvim-neo-tree/neo-tree.nvim",
			branch = "v3.x",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"nvim-tree/nvim-web-devicons",
				"MunifTanjim/nui.nvim",
--				"3rd/image.nvim",
			},
		},
		{ "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },
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
		-- add your plugins here
	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	install = {
		colorscheme = { "rose-pine" },
	},
	-- automatically check for plugin updates
	checker = { enabled = true },
})

require("rose-pine").setup()
require("lualine").setup({
	options = {
		theme = "dracula",
	},
})
require("mason").setup()

vim.cmd("colorscheme rose-pine")
--vim.g.material_style = "deep ocean"

local builtin = require("telescope.builtin")
require("telescope").setup({
	extensions = {
		["ui-select"] = {
			require("telescope.themes").get_dropdown({
				-- even more opts
			}),

			-- pseudo code / specification for writing custom displays, like the one
			-- for "codeactions"
			-- specific_opts = {
			--   [kind] = {
			--     make_indexed = function(items) -> indexed_items, width,
			--     make_displayer = function(widths) -> displayer
			--     make_display = function(displayer) -> function(e)
			--     make_ordinal = function(e) -> string
			--   },
			--   -- for example to disable the custom builtin "codeactions" display
			--      do the following
			--   codeactions = false,
			-- }
		},
	},
})
require("telescope").load_extension("ui-select")
require("mason-lspconfig").setup({
	ensure_installed = { "lua_ls", "rust_analyzer", "dockerls", "pylyzer", "sqls" },
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()
local lspconfig = require("lspconfig")
lspconfig.rust_analyzer.setup({
	-- Server-specific settings. See `:help lspconfig-setup`
	settings = {
		["rust-analyzer"] = {},
	},
	capabilities = capabilities,
})
lspconfig.lua_ls.setup({ capabilities = capabilities })
lspconfig.dockerls.setup({ capabilities = capabilities })
lspconfig.java_language_server.setup({ capabilities = capabilities })
lspconfig.pylyzer.setup({ capabilities = capabilities })
lspconfig.sqls.setup({ capabilities = capabilities })

local null_ls = require("null-ls")
null_ls.setup({
	sources = {
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.rustywind,
		null_ls.builtins.formatting.sqlfmt,
	},
})
local cmp = require("cmp")
require("luasnip.loaders.from_vscode").lazy_load()
cmp.setup({

	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			--vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
			require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
			-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
			-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
			-- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
		end,
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		--{ name = "vsnip" }, -- For vsnip users.
		{ name = "luasnip" }, -- For luasnip users.
		-- { name = 'ultisnips' }, -- For ultisnips users.
		-- { name = 'snippy' }, -- For snippy users.
	}, {
		{ name = "buffer" },
	}),
})

--require("alpha-nvim").setup(require("alpha").setup(require("alpha.themes.theta").config).config)

--local dashboard = require("alpha.themes.startify")

-- Custom section for buttons
--dashboard.section.buttons.val = {
--	dashboard.button("f", "  Find File", ":Telescope find_files<CR>"),
--	dashboard.button("r", "  Recently Used Files", ":Telescope oldfiles<CR>"),
--	dashboard.button("n", "  New File", ":enew<CR>"),
--}

-- Set the header
--dashboard.section.header.val = {
--	"Welcome to Neovim",
--}

-- Apply configuration
--alpha.setup(dashboard.config)
vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
--vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
vim.keymap.set("n", "<C-p>", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<C-n>", ":Neotree filesystem reveal left<CR>", {})
vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
