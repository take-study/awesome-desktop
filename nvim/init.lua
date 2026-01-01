-- Neovim configuration file
-- Basic settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 50
vim.opt.clipboard = "unnamedplus"
vim.opt.relativenumber = true
vim.opt.cursorline = true

vim.o.list = true
vim.o.listchars = "tab:» ,lead:•,trail:•"
-- Leader key
vim.g.mapleader = " "

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

-- Bootstrap plugin manager
require("lazy-bootstrap")

-- Load theme configuration
require("theme").setup()

-- Load keybinds
require("keybind")

vim.fn.setenv("SEARXNG_API_URL", "https://search.hbubli.cc/")
