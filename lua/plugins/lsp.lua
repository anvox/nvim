return {
  "neovim/nvim-lspconfig",
  { "zbirenbaum/copilot.lua", opts = {} },
  {
    "zbirenbaum/copilot-cmp",
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
    },
    config = function()
      require("copilot_cmp").setup()
    end
  },
  "nvimtools/none-ls.nvim",
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" },  -- for curl, log wrapper
    },
    build = "make tiktoken",        -- Only on MacOS or Linux
    opts = {
      debug = true,                 -- Enable debugging
      -- See Configuration section for rest
    },
    -- See Commands section for default commands if you want to lazy load on them
  },
}
