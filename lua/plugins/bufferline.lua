return {
  {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      local function buffer_close()
        if vim.bo.modified then
          local choice = vim.fn.confirm("Save changes?", "&Yes\n&No\n&Cancel")
          if choice == 1 then
            vim.cmd('write')
          elseif choice == 2 then
            vim.cmd('set nomodified')
          else
            return
          end
        end

        if #vim.fn.getbufinfo({ buflisted = 1 }) > 1 then
          vim.cmd(':bd')
        else
          vim.cmd(':bd')
          vim.cmd('enew')
          vim.cmd('setlocal bufhidden=wipe')
        end
      end
      vim.keymap.set('n', '<leader>w', buffer_close, { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<S-Tab>', ':BufferLineCycleNext<CR>', { noremap = true, silent = true })
      vim.keymap.set('n', '<leader>t', ':enew<CR>', { noremap = true, silent = true })

      require("bufferline").setup({
        highlights = {
          background = {
            fg = '#909090', -- inactive buffer text
          },
          buffer_visible = {
            fg = '#909090', -- visible but not selected
          },
          close_button = {
            fg = '#b0b0b0',
          },
          close_button_visible = {
            fg = '#c8c8c8',
          },
        },
      })
    end
  }
}
