return {
  {
    "hedyhli/outline.nvim",
    config = function()
      vim.api.nvim_set_keymap('n', '<leader>o', ':Outline<CR>', { noremap = true, silent = true })
      require("outline").setup {}
    end
  },
  "cappyzawa/trim.nvim",
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false }
  },
  { "lukas-reineke/indent-blankline.nvim", main = "ibl",    opts = {} },
  {
    'MagicDuck/grug-far.nvim',
    config = function()
      vim.api.nvim_set_keymap('n', '<leader>f', ':GrugFar<CR>', { noremap = true, silent = true })
      require('grug-far').setup({
        engine = 'ripgrep'
      });
    end
  },
  { 'echasnovski/mini.pairs',              version = false, opts = {} },
  { 'echasnovski/mini.comment',            opts = {} },
  { 'echasnovski/mini.cursorword',         version = false, opts = {} },
  { 'echasnovski/mini-git',                version = false, main = 'mini.git', opts = {} },
  { 'echasnovski/mini.notify',             version = false, opts = {} },
  { 'echasnovski/mini.diff',               version = false, opts = {} },
}
