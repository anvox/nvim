return {
  'nvim-tree/nvim-web-devicons',
  {
    'nvim-tree/nvim-tree.lua',
  },
  {
    "navarasu/onedark.nvim",
    lazy = false,
    priority = 1000,
  },
  {
    'ahmedkhalf/project.nvim',
    config = function()
      require("project_nvim").setup({
        detection_methods = { "pattern", "lsp" }
      })
    end,
  },
  "romgrk/barbar.nvim",
  'lewis6991/gitsigns.nvim',
  "nvim-lualine/lualine.nvim",
}
