return {
  'nvim-tree/nvim-web-devicons',
  {
    'nvim-tree/nvim-tree.lua',
    opts = {},
    config = function()
      vim.cmd([[
        highlight NvimTreeFolderIcon guifg=#7aa2f7
        highlight NvimTreeFolderName guifg=#7aa2f7
        highlight NvimTreeIndentMarker guifg=#3b4261
        highlight NvimTreeNormal guibg=NONE
        highlight NvimTreeCursorLine guibg=#2d3343
        highlight NvimTreeVertSplit guifg=#1f2335
        highlight NvimTreeEndOfBuffer guifg=#1f2335
        highlight NvimTreeOpenedFolderName guifg=#7aa2f7
      ]])
      require('nvim-tree').setup({
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
      })
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
