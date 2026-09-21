return {
	{
		"mason-org/mason.nvim",
		opts = {},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = { "mason-org/mason.nvim" },
		opts = {
			ensure_installed = {
				"lua_ls",
				"elixirls",
				"ts_ls",
				"tailwindcss",
				"html",
				"cssls",
				"clangd",
			},
		},
	},
	{
		-- Auto-installs conform formatters so conform doesn't silently no-op.
		-- NOTE: gofumpt/golines need the Go toolchain (`go`) and ocamlformat
		-- needs `opam` in PATH — Mason builds them via those tools, so they
		-- are intentionally NOT auto-installed. Install the toolchain first,
		-- then `:MasonInstall gofumpt golines ocamlformat` if you need them.
		-- Exotic tools (purstidy, ormolu, asmfmt, gleam, astro) aren't in the
		-- Mason registry: install those manually.
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "mason-org/mason.nvim" },
		opts = {
			ensure_installed = {
				"stylua",
				"black",
				"prettier",
				"goimports-reviser",
				"clang-format",
				"yamlfmt",
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = { "saghen/blink.cmp" },
		config = function()
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			vim.lsp.config("*", { capabilities = capabilities })

			vim.lsp.config("elixirls", {
				cmd = { "elixir-ls" },
				filetypes = { "elixir", "eex", "heex", "surface" },
			})

			vim.lsp.enable({
				"lua_ls",
				"elixirls",
				"ts_ls",
				"tailwindcss",
				"html",
				"cssls",
				"clangd",
			})

			-- NOTE: no vim.lsp.buf.format() on save here.
			-- conform.nvim (format_on_save with lsp_format="fallback") is the
			-- single formatter. Adding a second formatter causes double-edits/races.
			vim.diagnostic.config({
				underline = true,
				update_in_insert = false,
				severity_sort = true,
				virtual_text = {
					spacing = 2,
					source = "if_many",
					prefix = "●",
				},
				virtual_lines = false,
				float = { border = "rounded", source = "if_many" },
				signs = true,
				jump = {
					float = true,
				},
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local opts = { buffer = args.buf, silent = true }
					vim.keymap.set(
						"n",
						"K",
						vim.lsp.buf.hover,
						vim.tbl_extend("force", opts, { desc = "LSP hover" })
					)
					vim.keymap.set(
						"n",
						"gd",
						vim.lsp.buf.definition,
						vim.tbl_extend("force", opts, { desc = "Goto definition" })
					)
					vim.keymap.set(
						{ "n", "v" },
						"<leader>ca",
						vim.lsp.buf.code_action,
						vim.tbl_extend("force", opts, { desc = "Code action" })
					)
				end,
			})
		end,
	},
}
