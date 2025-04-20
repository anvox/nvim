return {
  {
    "navarasu/onedark.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      require('onedark').setup {
        style = 'dark',
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
  -- {
  --   'projekt0n/github-nvim-theme',
  --   name = 'github-theme',
  --   lazy = false,    -- make sure we load this during startup if it is your main colorscheme
  --   priority = 1000, -- make sure to load this before all the other start plugins
  --   config = function()
  --     require('github-theme').setup({
  --       options = {
  --         transparent = false
  --       }
  --     })
  --
  --     vim.cmd('colorscheme github_dark_default')
  --   end,
  -- }
}
