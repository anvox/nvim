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

      -- TSX Component snippet following the component ordering guide
      ls.add_snippets("typescriptreact", {
        s("rfc", {
          t("const "),
          i(1, "ComponentName"),
          t({ " = () => {", "  // 1. 🎨 Styles", "  " }),
          i(2),
          t({ "", "", "  // 2. 🌐 Contexts", "  " }),
          i(3),
          t({ "", "", "  // 3. 🔄 Recoils (State Management)", "  " }),
          i(4),
          t({ "", "", "  // 4. 🪝 Hooks (Custom Hooks)", "  " }),
          i(5),
          t({ "", "", "  // 5. 🌍 Endpoints (API calls setup)", "  " }),
          i(6),
          t({ "", "", "  // 6. 📊 States (Local Component State)", "  " }),
          i(7),
          t({ "", "", "  // 7. 📌 Refs", "  " }),
          i(8),
          t({ "", "", "  // 8. 🔧 Variables (Computed values, constants)", "  " }),
          i(9),
          t({ "", "", "  // 9. 🎛️ Handlers (Event handlers, functions)", "  " }),
          i(10),
          t({ "", "", "  // 10. ⚡️ Effects (useEffect hooks)", "  " }),
          i(11),
          t({ "", "", "  // 11. 🎭 Renders (Conditional rendering logic)", "  " }),
          i(12),
          t({ "", "", "  // 12. 🔄 Return Statement", "  return (", "    <>", "      " }),
          i(0, "Content"),
          t({ "", "    </>", "  );", "};", "", "export default " }),
          f(function(args) return args[1][1] end, {1}),
          t(";")
        }),

        -- Individual section snippets
        s("rfc-styles", {
          t("// 1. 🎨 Styles"),
          t({ "", "" }),
          i(0)
        }),

        s("rfc-contexts", {
          t("// 2. 🌐 Contexts"),
          t({ "", "" }),
          i(0)
        }),

        s("rfc-recoils", {
          t("// 3. 🔄 Recoils (State Management)"),
          t({ "", "" }),
          i(0)
        }),

        s("rfc-hooks", {
          t("// 4. 🪝 Hooks (Custom Hooks)"),
          t({ "", "" }),
          i(0)
        }),

        s("rfc-endpoints", {
          t("// 5. 🌍 Endpoints (API calls setup)"),
          t({ "", "" }),
          i(0)
        }),

        s("rfc-states", {
          t("// 6. 📊 States (Local Component State)"),
          t({ "", "" }),
          i(0)
        }),

        s("rfc-refs", {
          t("// 7. 📌 Refs"),
          t({ "", "" }),
          i(0)
        }),

        s("rfc-variables", {
          t("// 8. 🔧 Variables (Computed values, constants)"),
          t({ "", "" }),
          i(0)
        }),

        s("rfc-handlers", {
          t("// 9. 🎛️ Handlers (Event handlers, functions)"),
          t({ "", "" }),
          i(0)
        }),

        s("rfc-effects", {
          t("// 10. ⚡️ Effects (useEffect hooks)"),
          t({ "", "" }),
          i(0)
        }),

        s("rfc-renders", {
          t("// 11. 🎭 Renders (Conditional rendering logic)"),
          t({ "", "" }),
          i(0)
        }),

        s("rfc-return", {
          t("// 12. 🔄 Return Statement"),
          t({ "", "return (", "  <>" }),
          i(0, "Content"),
          t({ "", "  </>" }),
          t({ "", ");" })
        })
      })
    end,
  },
}
