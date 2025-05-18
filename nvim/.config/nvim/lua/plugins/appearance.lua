return {
  {
    "Mofiqul/vscode.nvim",
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    ---@module "ibl"
    ---@type ibl.config
    opts = {},
    configs = function ()
      require("ibl").setup()
    end
  }
}
