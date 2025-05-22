return {
  {
    'nvim-focus/focus.nvim',
    version = '*',
    config = function()
      require("focus").setup()
    end,
  },
  {
    "greggh/claude-code.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim", -- Required for git operations
    },
    config = function()
      require("claude-code").setup({
        git = { use_git_root = false }
      })
    end
  },
  { "folke/which-key.nvim" },
  { "mbbill/undotree" },
  { 'ojroques/nvim-bufdel' },
  {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    config = function()
      local mc = require("multicursor-nvim")
      mc.setup()
    end
  }
}