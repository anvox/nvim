-- 🤖 brew install tree-sitter
return {
  {
    "romus204/tree-sitter-manager.nvim",
    config = function()
      require("tree-sitter-manager").setup({
        auto_install = true,
        ensure_installed = {
          "bash",
          "diff",
          "html",
          "lua",
          "luadoc",
          "markdown",
          "elixir",
          "eex",
          "heex",
          "javascript",
          "typescript",
          "terraform",
          "hcl",
        },
      })
    end,
  },
}
