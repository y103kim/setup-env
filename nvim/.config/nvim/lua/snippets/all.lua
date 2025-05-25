-- ~/.config/nvim/lua/snippets/all.lua
local ls = require("luasnip")

return {
  -- ISO date
  ls.snippet("today", {
    ls.function_node(function()
      return os.date("%Y-%m-%d")
    end)
  }),

  -- Date and time
  ls.snippet("now", {
    ls.function_node(function()
      return os.date("%Y-%m-%d %H:%M:%S")
    end)
  }),
}
