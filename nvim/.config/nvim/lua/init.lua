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

require("config.lazy")

-- basic key maps
vim.keymap.set("n", "<C-h>", "<cmd>BufferLineCyclePrev<cr>")
vim.keymap.set("n", "<C-l>", "<cmd>BufferLineCycleNext<cr>")
vim.keymap.set('n', '<C-j>', '<C-w>w')
vim.keymap.set('n', '<C-k>', '<C-w>W')
vim.keymap.set("n", "<leader>cv", "<cmd>FzfLua files search_paths=~/.config/nvim/lua fd_opt='-e lua' query=lua<CR>")
vim.keymap.set("n", "<leader>q", "<cmd>BufDel<cr>")

-- set system clipboard
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- goto
vim.keymap.set("n", "<leader>gi", vim.diagnostic.open_float)
vim.keymap.set("n", "<leader>gu", vim.cmd.UndotreeToggle)
vim.keymap.set('n', '<leader>ga', '<cmd>ClaudeCode<CR>', { desc = 'Toggle Claude Code' })

-- find
vim.keymap.set("n", "<leader>ff", "<cmd>FzfLua git_files<cr>")
vim.keymap.set("n", "<leader>fF", "<cmd>FzfLua files<cr>")
vim.keymap.set("n", "<leader>fr", "<cmd>FzfLua live_grep<cr>")
vim.keymap.set("n", "<leader>fR", "<cmd>FzfLua grep_project<cr>")

-- git keymaps (from git.lua)
vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = "Git Status" })
