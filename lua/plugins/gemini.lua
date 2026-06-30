return {
  {
    "flyingshutter/gemini-autocomplete.nvim",
    config = function()
      local gemini = require("gemini-autocomplete")
      gemini.setup({
        -- You can configure defaults here.
        -- By default, completion is enabled.
        completion = {
          enabled = true,
          insert_result_key = "<S-Tab>", -- Key to accept completion
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
