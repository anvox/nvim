return {
  'nvim-tree/nvim-web-devicons',
  {
    'nvim-tree/nvim-tree.lua',
    opts = {
      actions = {
        open_file = {
          quit_on_open = true,
        },
      },
      sort = {
        sorter = "case_sensitive",
      },
      view = {
        width = 30,
      },
      renderer = {
        group_empty = true,
      },
      filters = {
        dotfiles = false,
        git_ignored = false,
        custom = { "^\\.git$", "^\\.elixir_ls$", "^\\.elixir-tools$", "^_build$", "^deps$", "^node_modules$", "^\\.DS_Store$", "^dist$" },
      },
    }
  },
  {
    "navarasu/onedark.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      require('onedark').setup {
        style = 'warmer'
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
  "romgrk/barbar.nvim",
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    }
  },
}
