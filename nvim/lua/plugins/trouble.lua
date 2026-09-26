return {
	{
		"folke/trouble.nvim",
		cmd = "Trouble",
		dependencies = { "nvim-neotest/nvim-nio" },
		opts = {},
		keys = {
			{
				"<leader>xx",
				"<CMD>Trouble diagnostics toggle<CR>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>xX",
				"<CMD>Trouble diagnostics toggle filter.severity=1<CR>",
				desc = "Errors only (Trouble)",
			},
			{
				"<leader>xd",
				"<CMD>Trouble diagnostics toggle filter.buf=0<CR>",
				desc = "Buffer diagnostics (Trouble)",
			},
			{
				"<leader>xq",
				"<CMD>Trouble quickfix toggle<CR>",
				desc = "Quickfix list (Trouble)",
			},
			{
				"<leader>xl",
				"<CMD>Trouble loclist toggle<CR>",
				desc = "Location list (Trouble)",
			},
			{
				"<leader>cs",
				"<CMD>Trouble lsp_document_symbols toggle<CR>",
				desc = "Document symbols (Trouble)",
			},
			-- Muscle-memory alias for your old <leader>fd (was Telescope).
			{
				"<leader>fd",
				"<CMD>Trouble diagnostics toggle<CR>",
				desc = "List diagnostics (Trouble)",
			},
		},
	},
}
