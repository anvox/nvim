return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- Configure LSP keybindings on attach
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local bufnr = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)

          vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

          local opts = { buffer = bufnr, noremap = true, silent = true }

          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
          vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
          vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
          vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)

          vim.api.nvim_buf_create_user_command(bufnr, 'Format', function()
            vim.lsp.buf.format()
          end, {})
        end,
      })

      -- Configure LSP servers
      vim.lsp.config('*', {
        root_markers = { '.git' },
      })

      vim.lsp.config.elixirls = {
        settings = {
          elixirLS = {
            dialyzerEnabled = true,
            fetchDeps = false
          }
        }
      }
    end
  },
  { "zbirenbaum/copilot.lua", opts = {} },
  {
    "zbirenbaum/copilot-cmp",
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
    },
    config = function()
      require("copilot_cmp").setup()
    end
  },
  "nvimtools/none-ls.nvim",
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" },  -- for curl, log wrapper
    },
    build = "make tiktoken",        -- Only on MacOS or Linux
    opts = {
      debug = true,                 -- Enable debugging
      -- See Configuration section for rest
    },
    -- See Commands section for default commands if you want to lazy load on them
  },
}
