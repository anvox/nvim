return {
  {
    "navarasu/onedark.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      require('onedark').setup {
        style = 'darker',
        code_style = {
          comments = 'italic',
          keywords = 'none',
          functions = 'italic,bold',
          strings = 'none',
          variables = 'none'
        },
        colors = {
          bg0 = '#141619',
          bg1 = '#1a1d23',
          bg2 = '#1f2329',
        },
      }
      require("onedark").load()
    end,
  },
  {
    'ahmedkhalf/project.nvim',
    config = function()
      require("project_nvim").setup({
        detection_methods = { "pattern", "lsp" }
      })
    end,
  },
}
