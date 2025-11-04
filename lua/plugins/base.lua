return {
  {
    "navarasu/onedark.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      require('onedark').setup {
        style = 'warm',
        code_style = {
          comments = 'italic',
          keywords = 'none',
          functions = 'italic,bold',
          variables = 'none'
        },
        colors = {
          bg0 = '#141619',
          bg1 = '#1a1d23',
          bg2 = '#1f2329',
        },
        highlights = {
          ColorColumn = { bg = '#4a4a4a' },
          String = { fg = '#d4d4d4' },
          ['@string'] = { fg = '#d4d4d4' },
          Visual = { bg = '#434752' }
        }
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
  {
    'rmagatti/auto-session',
    config = function()
      require('auto-session').setup({
        auto_session_suppress_dirs = { '~/', '~/Downloads', '/' },
        -- This makes it work seamlessly with project.nvim
        auto_session_use_git_branch = false,    -- optional: per-branch sessions
        auto_session_enable_last_session = false, -- let project.nvim handle switching
      })
    end
  }
} 
