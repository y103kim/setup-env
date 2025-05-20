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
      vim.api.nvim_set_hl(0, "GitBlameColor", { fg = "#444444" })
      vim.api.nvim_set_hl(0, "FlashBackdrop", { fg = "#777777" })
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
    opts = {},
    config = function ()
      require("ibl").setup()
    end
  },
  {
    "rcarriga/nvim-notify",
    lazy = false,
    opts = {
      timeout = 2000,
      on_open = function(win)
        vim.api.nvim_win_set_config(win, { focusable = false })
      end,
      render = "default",
      stages = "fade_in_slide_out",
    },
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      -- add any options here
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function ()
      require("noice").setup({
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        presets = {
          command_palette = true,
          long_message_to_split = true,
          inc_rename = false,
          lsp_doc_border = false,
        },
      })
    end
  },
}
