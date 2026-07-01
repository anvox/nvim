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
            fetchDeps = true
          }
        }
      }

      vim.lsp.config.gopls = {
        settings = {
          gopls = {
            analyses = {
              unusedparams = true,
            },
            staticcheck = true,
            gofumpt = true,
          },
        },
      }

      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.go",
        callback = function()
          local params = vim.lsp.util.make_range_params()
          params.context = { only = { "source.organizeImports" } }
          local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 1000)
          for cid, res in pairs(result or {}) do
            for _, r in pairs(res.result or {}) do
              if r.edit then
                local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
                vim.lsp.util.apply_workspace_edit(r.edit, enc)
              end
            end
          end
          vim.lsp.buf.format({ async = false })
        end,
      })

      vim.api.nvim_set_hl(0, '@lsp.mod.shadowing', { bold = true, underline = true })
    end
  },
  "nvimtools/none-ls.nvim",
}
