return {
  {
    "fdschmidt93/telescope-egrepify.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
  },
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      {
        'nvim-tree/nvim-web-devicons',
        enabled = vim.g.have_nerd_font
      },
      { 'mollerhoj/telescope-recent-files.nvim' }
    },
    config = function()
      require('telescope').setup {
        defaults = {
          file_ignore_patterns = {},
          file_sorter = require('telescope.sorters').get_fuzzy_file,
          generic_sorter = require('telescope.sorters').get_generic_fuzzy_sorter,
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
          ['recent-files'] = {
            -- Add these settings for recent-files
            only_cwd = true,
            sorting = "mru",
            case_mode = "ignore_case",
            use_file_sorter = true,
          },
        },
        pickers = {
          find_files = {
            find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*", "-L" },
            case_mode = "ignore_case",
            on_input_filter_cb = function(prompt)
              local file, line = prompt:match("(.+):(%d+)$")
              if file and line then
                return { prompt = file }
              end
            end,
            attach_mappings = function(prompt_bufnr, map)
              local actions = require('telescope.actions')
              local action_state = require('telescope.actions.state')
              actions.select_default:replace(function()
                local prompt = action_state.get_current_line()
                local file, line = prompt:match("(.+):(%d+)$")
                actions.close(prompt_bufnr)
                if file and line then
                  vim.cmd('edit ' .. file)
                  vim.api.nvim_win_set_cursor(0, { tonumber(line), 0 })
                else
                  actions.select_default()
                end
              end)
              return true
            end,
          },
        },
      }

      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')
      pcall(require('telescope').load_extension, 'projects')
      pcall(require("telescope").load_extension, 'recent-files')
      pcall(require("telescope").load_extension, 'egrepify')
      pcall(require("telescope").load_extension, 'egrepify')
      pcall(require("telescope").load_extension, 'auto-session')

      local builtin = require 'telescope.builtin'

      vim.keymap.set('n', '<leader>fp', '<cmd>Telescope projects<cr>', { desc = '🚀 Switch Projects' })
      vim.keymap.set('n', '<leader><leader>', function()
        require('telescope').extensions['recent-files'].recent_files({
          case_mode = "ignore_case",
        })
      end, { noremap = true, silent = true, desc = 'Recent files' })
      vim.keymap.set('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })
      vim.keymap.set({ 'n', 'v' }, '<C-F>', function()
        local telescope = require("telescope")
        if vim.fn.mode() == 'v' then
          telescope.extensions.egrepify.egrepify({
            default_text = vim.fn.expand("<cword>"),
            -- Additional options for better experience
            only_sort_text = true,   -- Only sort the text, not the filename
            word_match = "-w",       -- Match whole words
            case_sensitive = false,  -- Case insensitive search
            fuzzy = false,           -- Exact match by default
            use_regex = false,       -- Don't use regex by default
            duplicate_files = false, -- Don't show duplicate files
          })
        else
          telescope.extensions.egrepify.egrepify({
            -- Same additional options
            only_sort_text = true,
            word_match = "-w",
            case_sensitive = false,
            fuzzy = false,
            use_regex = false,
            duplicate_files = false,
          })
        end
      end, { desc = 'Search by Egrepify' })
      vim.keymap.set('n', 'bb', function()
        require('telescope.builtin').buffers({
          show_all_buffers = true,
          sort_lastused = true,
          ignore_current_buffer = false,
        })
      end, { noremap = true, silent = true, desc = 'Buffers' })
    end,
  },
}
