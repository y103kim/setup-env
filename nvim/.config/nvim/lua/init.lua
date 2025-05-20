require("config.lazy")

-- default setup
vim.opt.autoindent = true
vim.opt.cindent = true
vim.opt.smartindent = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.undofile = true
vim.opt.termguicolors = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true


-- basic key maps
vim.keymap.set("n", "<C-h>", "<cmd>BufferLineCyclePrev<cr>")
vim.keymap.set("n", "<C-l>", "<cmd>BufferLineCycleNext<cr>")
vim.keymap.set('n', '<C-j>', '<C-w>w')
vim.keymap.set('n', '<C-k>', '<C-w>W')
vim.keymap.set("n", "<leader>cv", ":FzfLua files search_paths=~/.config/nvim/lua fd_opt='-e lua' query=lua<CR>")
vim.keymap.set("n", "<leader>q", ":BufDel<cr>")

-- set system clipboard
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- goto
vim.keymap.set("n", "<leader>gi", vim.diagnostic.open_float)
vim.keymap.set("n", "<leader>gu", vim.cmd.UndotreeToggle)
