require("config.general_options")
require("config.lazy")
require("config.general_keymaps")
require("config.misc")

local null_ls = require("null-ls")
null_ls.setup({
  sources = {
    null_ls.builtins.diagnostics.credo,
    null_ls.builtins.formatting.mix,
  },
  on_attach = function(client, bufnr)
    if client.server_capabilities.document_formatting then
      vim.api.nvim_command [[augroup Format]]
      vim.api.nvim_command [[autocmd! * <buffer>]]
      vim.api.nvim_command [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()]]
      vim.api.nvim_command [[augroup END]]
    end
  end,
})

-- Configure LSP for Elixir
local nvim_lsp = require('lspconfig')
local mason_lspconfig = require('mason-lspconfig')

mason_lspconfig.setup_handlers {
  function(server_name)
    nvim_lsp[server_name].setup {
      on_attach = function(client, bufnr)
        local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
        buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

        local opts = { noremap = true, silent = true }

        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
        vim.cmd [[ command! Format execute 'lua vim.lsp.buf.format()' ]]

        if client.server_capabilities.documentFormattingProvider then
          vim.api.nvim_command [[augroup Format]]
          vim.api.nvim_command [[autocmd! * <buffer>]]
          vim.api.nvim_command [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]]
          vim.api.nvim_command [[augroup END]]
        end
      end,
      settings = {
        elixirLS = {
          dialyzerEnabled = true,
          fetchDeps = false
        }
      }
    }
  end,
}

vim.api.nvim_create_autocmd("FileType", {
  pattern = "elixir",
  callback = function()
    vim.keymap.set('n', '<leader>cm', function()
        local cursor_pos = vim.api.nvim_win_get_cursor(0)
        vim.cmd('normal! gg')
        local module_line = vim.fn.search('^\\s*defmodule\\s\\+', 'n')

        if module_line == 0 then
          print("👺 No module definition found.")
          return
        end

        local line = vim.api.nvim_buf_get_lines(0, module_line - 1, module_line, false)[1]
        local module_name = line:match('defmodule%s+([%w%.]+)%s+do')

        if module_name then
          vim.fn.setreg('+', module_name)
          print("📋 " .. module_name)
        else
          print("👺 No module name found.")
        end

        vim.api.nvim_win_set_cursor(0, cursor_pos)
      end,
      { noremap = true, silent = true, desc = 'Copy Elixir module name' })
  end
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
  end
})

vim.cmd('command! -nargs=1 -complete=file Diff vert diffsplit <args>')

vim.diagnostic.config({
  virtual_text = {
    prefix = function(diagnostic)
      local severity_map = {
        [vim.diagnostic.severity.ERROR] = "🔴", -- Error
        [vim.diagnostic.severity.WARN] = "⚠️", -- Warning
        [vim.diagnostic.severity.INFO] = "ℹ️", -- Information
        [vim.diagnostic.severity.HINT] = "💡", -- Hint
      }
      return severity_map[diagnostic.severity]
    end,
    source = "if_many",
    format = function(diagnostic)
      return diagnostic.message
    end,
  },
  float = {
    source = "if_many",
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

local emoji_signs = {
  Error = "🚨", -- or "❌", "🔥", "💥"
  Warn = "⚠️", -- or "🚧", "⚡", "🔶"
  Hint = "💡", -- or "🔍", "💭", "✨"
  Info = "ℹ️" -- or "📝", "🔷", "📌"
}
-- 🔧 Apply the diagnostic signs
vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = emoji_signs.Error,
      [vim.diagnostic.severity.WARN] = emoji_signs.Warn,
      [vim.diagnostic.severity.HINT] = emoji_signs.Hint,
      [vim.diagnostic.severity.INFO] = emoji_signs.Info,
    }
  }
})
