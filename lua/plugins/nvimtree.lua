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
    },
    config = function()
      vim.keymap.set('n', '<C-0>', function()
        local nvim_tree = require('nvim-tree.api')
        local current_file = vim.fn.expand('%:p')

        if not nvim_tree.tree.is_visible() then
          nvim_tree.tree.open()
        end

        nvim_tree.tree.find_file(current_file)
      end, { noremap = true, silent = true })
      vim.keymap.set('n', '<leader>b', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
    end
  },
}
