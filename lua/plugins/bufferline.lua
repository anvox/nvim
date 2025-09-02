return {
  {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      local function buffer_close()
        -- 📌 Simple approach: try closing and let bufferline handle pinned buffers
        -- Or manually track pinned buffers with a custom approach
        local bufnr = vim.api.nvim_get_current_buf()

        -- Check if we have a custom pin marker (you can set this when pinning)
        local is_pinned = vim.b[bufnr].is_pinned or false

        if is_pinned then
          vim.notify("🚫 Cannot close pinned buffer", vim.log.levels.WARN)
          return
        end

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
      vim.keymap.set('n', '<leader>w', buffer_close,
        { noremap = true, silent = true, desc = '🗂️ Close buffer (skip pinned)' })
      vim.keymap.set('n', '<leader>t', ':enew<CR>', { noremap = true, silent = true, desc = '🗂️ New buffer' })

      -- 🧹 Close all unpinned tabs
      vim.keymap.set('n', '<leader>W', ':BufferLineGroupClose ungrouped<CR>',
        { noremap = true, silent = true, desc = '🧹 Close unpinned tabs' })

      -- 🔄 Cycle through tabs
      vim.keymap.set('n', '<C-Left>', ':BufferLineCyclePrev<CR>',
        { noremap = true, silent = true, desc = '🔄 Previous tab' })
      vim.keymap.set('n', '<C-Right>', ':BufferLineCycleNext<CR>', { noremap = true, silent = true, desc = '🔄 Next tab' })

      -- 📌 Pin/unpin current tab with custom tracking
      vim.keymap.set('n', '<C-p>', function()
        local bufnr = vim.api.nvim_get_current_buf()
        local is_currently_pinned = vim.b[bufnr].is_pinned or false

        -- Toggle the pin state
        vim.cmd('BufferLineTogglePin')

        -- Update our custom tracking
        vim.b[bufnr].is_pinned = not is_currently_pinned

        -- Provide feedback
        if vim.b[bufnr].is_pinned then
          vim.notify("📌 Buffer pinned", vim.log.levels.INFO)
        else
          vim.notify("📌 Buffer unpinned", vim.log.levels.INFO)
        end
      end, { noremap = true, silent = true, desc = '📌 Toggle pin tab' })

      -- ⬅️➡️ Move current tab forward/backward
      vim.keymap.set('n', '<C-S-Left>', ':BufferLineMovePrev<CR>',
        { noremap = true, silent = true, desc = '⬅️ Move tab left' })
      vim.keymap.set('n', '<C-S-Right>', ':BufferLineMoveNext<CR>',
        { noremap = true, silent = true, desc = '➡️ Move tab right' })

      for i = 1, 9 do
        vim.keymap.set('n', '<A-' .. i .. '>', '<cmd>BufferLineGoToBuffer ' .. i .. '<cr>',
          { desc = '🔢 Go to buffer ' .. i })
      end

      require("bufferline").setup({
        options = {
          -- 📌 Enable close icons for pinned buffers
          show_close_icon = true,
          show_buffer_close_icons = true,
          -- 🎯 Better tab picking with numbers
          numbers = "ordinal",
          -- 📌 Show pin indicator
          show_tab_indicators = true,
          indicator = {
            style = 'underline',
          }
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
