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

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.wrap = false
vim.opt.colorcolumn = "100"

require("config.lazy")


-- basic key maps
vim.keymap.set("n", "<C-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Previous buffer" })
vim.keymap.set("n", "<C-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
vim.keymap.set('n', '<C-j>', '<C-w>w', { desc = "Next window" })
vim.keymap.set('n', '<C-k>', '<C-w>W', { desc = "Previous window" })
local findCfgs = "<cmd>FzfLua files search_paths=~/.config/nvim/lua fd_opt='-e lua' query=lua<CR>"
vim.keymap.set("n", "<leader>cv", findCfgs, { desc = "Config: find files" })
vim.keymap.set("n", "<leader>q", "<cmd>BufDel<cr>", { desc = "Close buffer" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines (keep cursor)" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down (center)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up (center)" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search (center)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search (center)" })
local dismiss_noice = function() require("noice").cmd("dismiss") end
vim.keymap.set("n", "<esc>", dismiss_noice, { desc = "Dismiss notifications" })

-- clipboard, yank
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste without yank" })
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to clipboard" })
vim.keymap.set("v", "<c-c>", [["+y]], { desc = "Copy to clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank line to clipboard" })

-- goto
vim.keymap.set("n", "<leader>gi", vim.diagnostic.open_float, { desc = "Show diagnostic info" })
vim.keymap.set("n", "<leader>gu", vim.cmd.UndotreeToggle, { desc = "Toggle undotree" })
vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = "Git Status" })
vim.keymap.set("n", "<leader>gf", "<cmd>FzfLua git_files<cr>", { desc = "Git files" })
vim.keymap.set("n", "<leader>gF", "<cmd>FzfLua files<cr>", { desc = "All files" })
vim.keymap.set("n", "<leader>gr", "<cmd>FzfLua live_grep<cr>", { desc = "Live grep" })
vim.keymap.set("n", "<leader>gR", "<cmd>FzfLua grep_project<cr>", { desc = "Grep project" })

-- run
local replace_word_cmd = [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]]
vim.keymap.set("n", "<leader>rr", replace_word_cmd, { desc = "Replace word under cursor" })
local incRename = function() return ":IncRename " .. vim.fn.expand("<cword>") end
vim.keymap.set("n", "<leader>rn", incRename, { expr = true })
vim.keymap.set('n', '<leader>ru', vim.cmd.UndotreeToggle, { desc = "Toggle undotree" })
vim.keymap.set('n', '<leader>ra', '<cmd>ClaudeCode<CR>', { desc = 'Toggle Claude Code' })
vim.keymap.set('n', '<C-\\>', '<cmd>ClaudeCode<CR>', { desc = 'Toggle Claude Code' })
vim.keymap.set("n", "<leader>rf", "<cmd>Neotree toggle<CR>", { desc = "NeoTree" })

local fmt = function() require("conform").format({ async = true }) end
vim.keymap.set({ "n", "v" }, "<leader>f", fmt, { desc = "Format buffer" })
