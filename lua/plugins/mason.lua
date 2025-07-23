-- Temporary lock version until these issue fixed
-- https://github.com/ayamir/nvimdots/issues/1461
-- https://github.com/mason-org/mason-lspconfig.nvim/issues/545
return {
  {
    'williamboman/mason.nvim',
    version = "1.11.0",
    config = function()
      require('mason').setup()
    end
  },
  {
    'williamboman/mason-lspconfig.nvim',
    version = "1.32.0",
    opts = {
      ensure_installed = { "elixirls", "ts_ls" }
    },
    config = function()
      require('mason-lspconfig').setup()
      require('mason-lspconfig').setup_handlers({
        function(server_name)
          require('lspconfig')[server_name].setup {}
        end,
      })
    end
  },
  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "nvimtools/none-ls.nvim",
    },
    config = function()
      require("mason-null-ls").setup({
        ensure_installed = { "prettierd" },
        automatic_installation = true,
      })
    end,
  }
}
