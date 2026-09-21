return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>f",
			function()
				require("conform").format({ async = true, lsp_format = "fallback" })
			end,
			mode = { "n", "v" },
			desc = "Format buffer",
		},
	},
	config = function()
		vim.g.disable_autoformat = false
		require("conform").setup({
			formatters_by_ft = {
				purescript = { "purstidy", stop_after_first = true },
				lua = { "stylua", stop_after_first = true },
				ocaml = { "ocamlformat", stop_after_first = true },
				python = { "black" },
				rust = { "rustfmt" },
				javascript = { "prettier", stop_after_first = true },
				javascriptreact = { "prettier", stop_after_first = true },
				typescript = { "prettier", stop_after_first = true },
				typescriptreact = { "prettier", stop_after_first = true },
				astro = { "astro", stop_after_first = true },
				go = { "gofumpt", "golines", "goimports-reviser" },
				c = { "clang_format" },
				cpp = { "clang_format" },
				haskell = { "ormolu" },
				yaml = { "yamlfmt" },
				html = { "prettier" },
				json = { "prettier" },
				markdown = { "prettier" },
				gleam = { "gleam" },
				asm = { "asmfmt" },
				css = { "prettier", stop_after_first = true },
			},
			-- Single source of truth for format-on-save.
			-- Conform creates its own BufWritePre autocmd from this;
			-- do NOT add another manual BufWritePre calling conform.format(),
			-- and do NOT call vim.lsp.buf.format() on save elsewhere.
			format_on_save = function(bufnr)
				if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
					return
				end
				return {
					timeout_ms = 500,
					lsp_format = "fallback",
				}
			end,
		})

		vim.api.nvim_create_user_command("FormatDisable", function(args)
			if args.bang then
				vim.b.disable_autoformat = true
			else
				vim.g.disable_autoformat = true
			end
		end, { desc = "Disable autoformat-on-save", bang = true })
		vim.api.nvim_create_user_command("FormatEnable", function()
			vim.b.disable_autoformat = false
			vim.g.disable_autoformat = false
		end, { desc = "Re-enable autoformat-on-save" })
	end,
}
