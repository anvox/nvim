return {
  {
    "hedyhli/outline.nvim",
    opts = {},
    config = function()
      vim.api.nvim_set_keymap('n', '<leader>o', ':Outline<CR>', { noremap = true, silent = true })
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
}
