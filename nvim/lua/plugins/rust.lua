return {
	-- The community-recommended Rust setup. rustaceanvim manages
	-- rust-analyzer (installed via Mason above) and wires up
	-- runnables/debuggables/testables + codelldb DAP automatically.
	-- Do NOT also enable "rust_analyzer" in mason.lua's vim.lsp.enable().
	{
		"mrcjkb/rustaceanvim",
		version = "^6",
		lazy = false,
		init = function()
			vim.g.rustaceanvim = {
			tools = {
				-- Prefer clippy for fly-check diagnostics when available.
				enable_clippy = true,
			},
				server = {
					-- Merge blink.cmp capabilities like mason.lua does for other servers.
					capabilities = require("blink.cmp").get_lsp_capabilities(),
					on_attach = function(_, bufnr)
						local opts = { buffer = bufnr, silent = true }
						vim.keymap.set(
							"n",
							"<leader>rr",
							"<CMD>RustLsp runnables<CR>",
							vim.tbl_extend("force", opts, { desc = "Rust runnables" })
						)
						vim.keymap.set(
							"n",
							"<leader>rt",
							"<CMD>RustLsp testables<CR>",
							vim.tbl_extend("force", opts, { desc = "Rust testables" })
						)
						vim.keymap.set(
							"n",
							"<leader>rd",
							"<CMD>RustLsp debuggables<CR>",
							vim.tbl_extend("force", opts, { desc = "Rust debuggables" })
						)
						vim.keymap.set(
							"n",
							"<leader>re",
							"<CMD>RustLsp explainError<CR>",
							vim.tbl_extend("force", opts, { desc = "Explain Rust error" })
						)
						vim.keymap.set("n", "J", "<CMD>RustLsp joinLines<CR>", vim.tbl_extend("force", opts, { desc = "Join lines" }))
						vim.keymap.set(
							"n",
							"<leader>ro",
							"<CMD>RustLsp openDocs<CR>",
							vim.tbl_extend("force", opts, { desc = "Open Rust docs" })
						)
						-- Inlay hints are a big part of the Rust DX (types, params).
						if vim.lsp.inlay_hint then
							vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
						end
					end,
					settings = {
						["rust-analyzer"] = {
							cargo = {
								allFeatures = true,
								buildScripts = { enable = true },
							},
							check = {
								command = "clippy",
								allTargets = true,
							},
							procMacro = { enable = true },
							diagnostics = { enable = true },
							inlayHints = {
								bindingModeHints = { enable = true },
								closingBraceHints = { minLines = 25 },
								lifetimeElisionHints = { enable = "skip_trivial" },
							},
						},
					},
				},
				-- codelldb is installed by Mason (see mason.lua).
				-- rustaceanvim auto-detects it at
				-- ~/.local/share/nvim/mason/bin/codelldb, no manual path needed.
			}
		end,
	},
	-- DAP client. rustaceanvim's :RustLsp debuggables needs this;
	-- without it codelldb has nothing to drive.
	{
		"mfussenegger/nvim-dap",
		keys = {
			{ "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
			{ "<leader>dc", function() require("dap").continue() end, desc = "Debug continue" },
			{ "<leader>dso", function() require("dap").step_over() end, desc = "Step over" },
			{ "<leader>dsi", function() require("dap").step_into() end, desc = "Step into" },
			{ "<leader>dsO", function() require("dap").step_out() end, desc = "Step out" },
			{ "<leader>dr", function() require("dap").repl.open() end, desc = "Open debug REPL" },
		},
	},
	-- Cargo.toml helpers: version lenses, upgrade actions, LSP completion.
	{
		"saecki/crates.nvim",
		event = { "BufRead Cargo.toml" },
		opts = {
			lsp = {
				enabled = true,
				actions = true,
				completion = true,
				hover = true,
			},
			-- NOTE: no `completion.cmp` — that nvim-cmp source is deprecated
			-- and you use blink.cmp, which is fed via the in-process LSP above.
			completion = {
				crates = { enabled = true },
			},
		},
		keys = {
			{
				"<leader>cu",
				function() require("crates").upgrade_all_crates() end,
				ft = "toml",
				desc = "Upgrade all crates",
			},
			{
				"<leader>cU",
				function() require("crates").update_all_crates() end,
				ft = "toml",
				desc = "Update all crates",
			},
			{
				"<leader>cH",
				function() require("crates").open_homepage() end,
				ft = "toml",
				desc = "Open crate homepage",
			},
		},
	},
}
