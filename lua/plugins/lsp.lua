return {
  "neovim/nvim-lspconfig",
  "zbirenbaum/copilot.lua",
  {
    "zbirenbaum/copilot-cmp",
    config = function()
      require("copilot_cmp").setup()
    end
  },
  "jose-elias-alvarez/null-ls.nvim",
}
