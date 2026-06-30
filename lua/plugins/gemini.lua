return {
  {
    "flyingshutter/gemini-autocomplete.nvim",
    config = function()
      local gemini = require("gemini-autocomplete")

      -- Suppress spammy blacklist warnings on CursorMovedI
      local util = require("gemini-autocomplete.util")
      local original_notify = util.notify
      util.notify = function(msg, level, opts)
        if msg and msg:find("file is blacklisted") then
          return
        end
        original_notify(msg, level, opts)
      end

      gemini.setup({
        -- You can configure defaults here.
        -- By default, completion is enabled.
        completion = {
          enabled = true,
          insert_result_key = "<S-Tab>", -- Key to accept completion
          -- Add filetypes or filenames to the blacklist here:
          blacklist_filetypes = { "help", "qf", "yaml", "toml", "xml" },
          blacklist_filenames = { ".env" },
        },
      })

      -- Keymaps
      vim.keymap.set("n", "<leader>gt", gemini.toggle_enabled, { desc = "[G]emini [T]oggle Autocompletion" })
      vim.keymap.set("n", "<leader>gg", gemini.add_gitfiles, { desc = "[G]emini add [G]itfiles" })
      vim.keymap.set("n", "<leader>ge", gemini.edit_context, { desc = "[G]emini [E]dit Context" })
      vim.keymap.set("n", "<leader>gp", gemini.prompt_code, { desc = "[G]emini [P]rompt Code" })
      vim.keymap.set("n", "<leader>gc", gemini.clear_context, { desc = "[G]emini [C]lear Context" })
      vim.keymap.set("n", "<leader>gm", gemini.choose_model, { desc = "[G]emini Choose [M]odel" })
    end,
  },
}
