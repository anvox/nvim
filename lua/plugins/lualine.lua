return {
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        }
      },
      sections = {
        lualine_a = {
          {
            'mode',
            fmt = function(str)
              local mode_map = {
                ['NORMAL'] = '🔍',
                ['INSERT'] = '✏️',
                ['VISUAL'] = '👁️',
                ['V-LINE'] = '📑',
                ['V-BLOCK'] = '🟦',
                ['COMMAND'] = '💻',
                ['REPLACE'] = '🔄',
                ['TERMINAL'] = '🖥️',
              }
              return mode_map[str] or str
            end
          } },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { { 'filename', path = 1 } },
        lualine_x = {
          {
            function()
              local get_clients = vim.lsp.get_clients or vim.lsp.get_active_clients
              local client = get_clients({ name = "copilot" })[1]
              if client == nil then return "" end
              if vim.tbl_isempty(client.requests or {}) then
                return " Copilot"
              else
                return "⣾ Copilot"
              end
            end,
            color = { fg = "#6dbd6b" },
          }
        },
        lualine_y = {},
        lualine_z = {
          {
            function()
              local line = vim.fn.line('.')
              local col = vim.fn.col('.')
              local total = vim.fn.line('$')
              return string.format("%4d|%-4d/%4d", col, line, total)
            end
          }
        }
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = {}
    }
  },
}
