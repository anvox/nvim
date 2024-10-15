return {
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

      local builtin = require 'telescope.builtin'

      vim.keymap.set('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      vim.keymap.set({ 'n', 'v' }, '<C-F>', function()
        if vim.fn.mode() == 'v' then
          builtin.live_grep({ default_text = vim.fn.expand("<cword>") })
        else
          builtin.live_grep({})
        end
      end, { desc = 'Search by Grep' })

      vim.keymap.set('n', '<leader><leader>', function()
        require('telescope').extensions['recent-files'].recent_files({
          case_mode = "ignore_case",
        })
      end, { noremap = true, silent = true })
    end,
  },
}
