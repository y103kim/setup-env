return {
  {
    url = "ssh://git.amazon.com:2222/pkg/Vim-code-browse",
    branch = "mainline",
    dependencies = "tpope/vim-fugitive",
    event = "VeryLazy",
  },
  {
    url = "ssh://git.amazon.com:2222/pkg/NvimCodeSearch",
    branch = "mainline",
    dependencies = "ibhagwan/fzf-lua",
    keys = {
      {
        "<leader>as",
        function() require("codesearch.fzf").code_search() end,
        mode = { "n", "v" },
        silent = true,
        desc = "Amazon Code Search",
      },

      -- Search only in current workspace version set
      {
        "<leader>av",
        function() require("codesearch.fzf").vs_code_search() end,
        mode = { "n", "v" },
        silent = true,
        desc = "Amazon Code Search - VersionSet only",
      },
    }
  },
}
