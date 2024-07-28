return {
  {
    "hedyhli/outline.nvim",
    opts = {}
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
