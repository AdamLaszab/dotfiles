return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"elixirls",
					"ts_ls",
					"tailwindcss",
					"html",
					"cssls",
				},
			})
		end,
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
			})

			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*",
				callback = function(args)
					local clients = vim.lsp.get_clients({ bufnr = args.buf })
					if #clients > 0 then
						vim.lsp.buf.format({ bufnr = args.buf })
					end
				end,
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local opts = { buffer = args.buf }
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
				end,
			})
		end,
	},
}
