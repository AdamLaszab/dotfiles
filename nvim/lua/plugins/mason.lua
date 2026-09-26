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
				"eslint",
				"jsonls",
				"clangd",
				"rust_analyzer",
			},
			-- mason-lspconfig enables every installed server by default.
			-- rustaceanvim already starts rust_analyzer (lua/plugins/rust.lua);
			-- enabling it here too spawns a second client and duplicates
			-- inline diagnostics / Trouble entries.
			automatic_enable = {
				exclude = { "rust_analyzer" },
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
				"codelldb",
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = { "saghen/blink.cmp", "b0o/schemastore.nvim" },
		config = function()
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			vim.lsp.config("*", { capabilities = capabilities })

			vim.lsp.config("elixirls", {
				cmd = { "elixir-ls" },
				filetypes = { "elixir", "eex", "heex", "surface" },
			})

			-- Schemas for tsconfig.json / package.json / .eslintrc etc.
			vim.lsp.config("jsonls", {
				settings = {
					json = {
						schemas = require("schemastore").json.schemas(),
						validate = { enable = true },
					},
				},
			})

			vim.lsp.enable({
				"lua_ls",
				"elixirls",
				"ts_ls",
				"tailwindcss",
				"html",
				"cssls",
				"eslint",
				"jsonls",
				"clangd",
				-- NOTE: rust_analyzer is NOT enabled here on purpose.
				-- It is managed by mrcjkb/rustaceanvim (lua/plugins/rust.lua),
				-- which provides runnables/debuggables/testables and DAP
				-- integration. Enabling both causes duplicate/conflicting clients.
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
					on_jump = function(_, bufnr)
						vim.diagnostic.open_float({
							bufnr = bufnr,
							scope = "cursor",
							focus = false,
						})
					end,
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
