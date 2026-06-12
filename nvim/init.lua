vim.g.mapleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")

vim.opt.background = "dark"
vim.opt.termguicolors = true
vim.api.nvim_set_hl(0, "Cursor", { bg = "#F0FF00" })
vim.opt.guicursor = "n-v-c:block-Cursor/lCursor"
vim.opt.termguicolors = true
vim.api.nvim_set_hl(0, "TermCursor", { bg = "#F0FF00" })

vim.opt.cursorline = true

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.signcolumn = "yes:1"

vim.keymap.set("n", "<F2>", "i<CR><Esc>")
-- Navigate vim panes better
vim.keymap.set("n", "<C-h>", ":TmuxNavigateLeft<CR>")
vim.keymap.set("n", "<C-j>", ":TmuxNavigateDown<CR>")
vim.keymap.set("n", "<C-k>", ":TmuxNavigateUp<CR>")
vim.keymap.set("n", "<C-l>", ":TmuxNavigateRight<CR>")
-- Windows clipboard integration
vim.keymap.set("v", "<leader>y", '"+y', { noremap = true, silent = true }) -- Copy to Windows clipboard
vim.keymap.set("n", "<leader>p", '"+p', { noremap = true, silent = true }) -- Paste from Windows clipboard

-- Save quit keybinds
vim.keymap.set("n", "<leader>w", ":w<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>q", ":wq<CR>", { noremap = true, silent = true })

-- telescope binds
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
vim.keymap.set("n", "<leader>ld", builtin.diagnostics, { desc = "List diagnostics" })

-- oil.nvim binds
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
