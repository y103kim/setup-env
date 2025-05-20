return {
  { "folke/which-key.nvim" },
  { "mbbill/undotree" },
  { 'ojroques/nvim-bufdel' },
  {
    'gelguy/wilder.nvim',
    config = function ()
      local wilder = require('wilder')
      wilder.setup({modes = {':', '/', '?'}})

      wilder.set_option('pipeline', {
        wilder.branch(
          wilder.cmdline_pipeline(),
          wilder.python_search_pipeline({
            pattern = 'fuzzy',
          })
        ),
      })
      wilder.set_option('renderer', wilder.popupmenu_renderer(
        wilder.popupmenu_border_theme({
          highlighter = wilder.basic_highlighter(),
          left = {' ', wilder.popupmenu_devicons()},
          right = {' ', wilder.popupmenu_scrollbar()},
          border = 'rounded',
        })
      ))
    end
  },
}
