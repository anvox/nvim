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

      -- 🗂️ Tab management keymaps
      vim.keymap.set('n', '<leader>w', buffer_close, { noremap = true, silent = true, desc = '🗂️ Close buffer' })
      vim.keymap.set('n', '<leader>t', ':enew<CR>', { noremap = true, silent = true, desc = '🗂️ New buffer' })

      -- 🔄 Cycle through tabs
      vim.keymap.set('n', '<C-Left>', ':BufferLineCyclePrev<CR>',
        { noremap = true, silent = true, desc = '🔄 Previous tab' })
      vim.keymap.set('n', '<C-Right>', ':BufferLineCycleNext<CR>', { noremap = true, silent = true, desc = '🔄 Next tab' })

      -- 📌 Pin/unpin current tab
      vim.keymap.set('n', '<C-p>', ':BufferLineTogglePin<CR>',
        { noremap = true, silent = true, desc = '📌 Toggle pin tab' })

      -- ⬅️➡️ Move current tab forward/backward
      vim.keymap.set('n', '<C-S-Left>', ':BufferLineMovePrev<CR>',
        { noremap = true, silent = true, desc = '⬅️ Move tab left' })
      vim.keymap.set('n', '<C-S-Right>', ':BufferLineMoveNext<CR>',
        { noremap = true, silent = true, desc = '➡️ Move tab right' })

      require("bufferline").setup({
        options = {
          -- 📌 Enable close icons for pinned buffers
          show_close_icon = true,
          show_buffer_close_icons = true,
          -- 🎯 Better tab picking with numbers
          numbers = "ordinal",
          -- 📌 Show pin indicator
          show_tab_indicators = true,
        },
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
          -- 📌 Pin indicator styling
          indicator_visible = {
            fg = '#ffd700', -- gold color for pin indicator
          },
          indicator_selected = {
            fg = '#ffd700',
          },
        },
      })
    end
  }
}
