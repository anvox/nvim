return {
  {
    "L3MON4D3/LuaSnip",
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
    config = function(_, opts)
      require("luasnip").setup(opts)

      local ls = require("luasnip")
      local s = ls.snippet
      local t = ls.text_node
      local f = ls.function_node
      local i = ls.insert_node

      local function module_name(_, _)
        local file_path = vim.fn.expand("%:p")
        local lib_index = string.find(file_path, "lib/")
        if lib_index then
          local relative_path = string.sub(file_path, lib_index + 4, -4) -- Remove "lib/" and ".ex"
          local parts = vim.split(relative_path, "/")
          local module_parts = {}
          for i = 1, #parts do
            local part = parts[i]
            module_parts[i] = part:gsub("^%l", string.upper):gsub("_(%l)", function(l) return l:upper() end)
          end
          return table.concat(module_parts, ".")
        end
        return "ModuleName"
      end

      ls.add_snippets("elixir", {
        s("defmod", {
          t("defmodule "),
          f(module_name, {}),
          t({ " do", "  " }),
          i(0),
          t({ "", "end" })
        })
      })

      ls.add_snippets("elixir", {
        s("inspect", {
          t("IO.inspect("),
          i(1),
          t(", label: \"🚀=============\")")
        })
      })
    end,
  },
}
