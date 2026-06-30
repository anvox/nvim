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
              local ok, gemini_config = pcall(require, "gemini-autocomplete.config")
              local ok_gemini, gemini = pcall(require, "gemini-autocomplete")
              if not (ok and ok_gemini) then return "" end

              local gemini_model = gemini_config.get_config().model.model_id
              local pos = string.find(gemini_model, '-')
              local short_name = pos and string.sub(gemini_model, pos + 1) or gemini_model

              if gemini.is_enabled() then
                return "♊ " .. short_name
              else
                return "♊ (off)"
              end
            end,
            color = function()
              local ok_gemini, gemini = pcall(require, "gemini-autocomplete")
              if ok_gemini and gemini.is_enabled() then
                return { fg = "#7ed6a5" } -- Green when enabled
              else
                return { fg = "#808080" } -- Gray when disabled
              end
            end,
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
