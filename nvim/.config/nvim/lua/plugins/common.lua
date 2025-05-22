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
  { "mg979/vim-visual-multi" },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    },
    lazy = false, -- neo-tree will lazily load itself
    opts = { },
  }
}
