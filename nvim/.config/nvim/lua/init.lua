require("config.lazy")

-- default setup
vim.o.autoindent = true
vim.o.cindent = true
vim.o.smartindent = true

vim.o.number = true
vim.o.relativenumber = true

vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.expandtab = true

vim.opt.termguicolors = true

vim.keymap.set("n", "<C-h>", "<cmd>BufferLineCyclePrev<cr>")
vim.keymap.set("n", "<C-l>", "<cmd>BufferLineCycleNext<cr>")
