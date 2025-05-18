return {
  {
    'akinsho/bufferline.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      "Mofiqul/vscode.nvim",
    },
    config = function ()
      require("bufferline").setup{
        options = {
          separator_style = "slant",
        },
      }
      require('vscode').setup{
        -- transparent = true,
        italic_comments = true,
        underline_links = true,
      }
      vim.cmd.colorscheme "vscode"
      vim.api.nvim_set_hl(0, "BufferLineFill", {  fg = 'NONE', bg = "#111111" })
    end
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function ()
      require("lualine").setup{
        options = {
          theme = 'vscode',
        }
      }
    end
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    ---@module "ibl"
    ---@type ibl.config
    opts = {},
    config = function ()
      require("ibl").setup()
    end
  },
}
