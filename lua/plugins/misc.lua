return {
  {
    "hedyhli/outline.nvim",
    config = function()
      vim.api.nvim_set_keymap('n', '<leader>o', ':Outline<CR>', { noremap = true, silent = true })
      require("outline").setup {}
    end
  },
  { 'echasnovski/mini.comment', opts = {} },
  "cappyzawa/trim.nvim",
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false }
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {}
  },
  { "windwp/nvim-autopairs",    event = "InsertEnter", config = true },
  {
    'MagicDuck/grug-far.nvim',
    config = function()
      vim.api.nvim_set_keymap('n', '<leader>f', ':GrugFar<CR>', { noremap = true, silent = true })
      require('grug-far').setup({
        engine = 'astgrep'
      });
    end
  },
  {
    "RRethy/vim-illuminate",
    config = function()
      require('illuminate').configure();
    end
  }
}
