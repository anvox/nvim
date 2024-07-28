return {
  "neovim/nvim-lspconfig",
  "zbirenbaum/copilot.lua",
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
  "jose-elias-alvarez/null-ls.nvim",
}
