return {
	-- main branch: rewrite compatible with Neovim 0.12.
	-- master is frozen and its query predicates crash on 0.12
	-- ("attempt to call method 'range' (a nil value)" in K hover floats).
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").setup()
		require("nvim-treesitter").install({
			-- core (hover floats render markdown)
			"bash",
			"lua",
			"markdown",
			"markdown_inline",
			"vim",
			"vimdoc",
			-- your stack
			"astro",
			"c",
			"cpp",
			"css",
			"eex",
			"elixir",
			"gleam",
			"go",
			"haskell",
			"heex",
			"html",
			"javascript",
			"json",
			"ocaml",
			"purescript",
			"python",
			"rust",
			"typescript",
			"tsx",
			"yaml",
		})
		-- Highlighting is NOT automatic on main: start it per filetype.
		-- pcall so filetypes without a parser are silently skipped.
		vim.api.nvim_create_autocmd("FileType", {
			callback = function(args)
				pcall(vim.treesitter.start, args.buf)
			end,
		})
	end,
}

