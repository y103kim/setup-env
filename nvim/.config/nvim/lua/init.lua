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
vim.o.undofile = true

vim.opt.termguicolors = true

-- basic key maps
vim.keymap.set("n", "<C-h>", "<cmd>BufferLineCyclePrev<cr>")
vim.keymap.set("n", "<C-l>", "<cmd>BufferLineCycleNext<cr>")
vim.keymap.set('n', '<C-j>', '<C-w>w')
vim.keymap.set('n', '<C-k>', '<C-w>W')
vim.keymap.set("n", "<leader>cv", ":FzfLua files search_paths=~/.config/nvim/lua fd_opt='-e lua' query=lua<CR>")

-- set system clipboard
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

-- goto
vim.keymap.set("n", "<leader>gi", vim.diagnostic.open_float)
vim.keymap.set("n", "<leader>gu", vim.cmd.UndotreeToggle)
