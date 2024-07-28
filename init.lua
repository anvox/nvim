require("config.general_options")
require("config.lazy")
require("config.general_keymaps")
require("config.misc")

require('onedark').setup {
  style = 'warmer'
}
require('onedark').load()
require("outline").setup({})
require('nvim-tree').setup({
  actions = {
    open_file = {
      quit_on_open = true,
    },
  },
})
require('mini.comment').setup()
require('gitsigns').setup({
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
})
require("ibl").setup()
require('copilot').setup({
  suggestion = { enabled = false },
  panel = { enabled = false },
})
local null_ls = require("null-ls")
null_ls.setup({
  sources = {
    null_ls.builtins.diagnostics.credo,
    null_ls.builtins.formatting.mix
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

mason_lspconfig.setup {
  ensure_installed = { "elixirls" }
}

mason_lspconfig.setup_handlers {
  function(server_name)
    nvim_lsp[server_name].setup {
      on_attach = function(client, bufnr)
        local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
        buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

        local opts = { noremap = true, silent = true }

        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>',
          opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>',
          opts)
        -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>',
        --   '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
        -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wa',
        --   '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
        -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wr',
        --   '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
        -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wl',
        --   '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
        -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>D',
        --   '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>',
          opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>',
          opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-a>',
          '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>e',
          '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>',
          opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>',
          opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>q',
          '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
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
    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', { buffer = true })
    vim.keymap.set('n', 'gf', '<cmd>lua vim.lsp.buf.references()<CR>', { buffer = true })
    vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_next()<CR>', { buffer = true })
    vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', { buffer = true })
    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', { buffer = true })
    vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', { buffer = true })
    vim.keymap.set('n', 'cm', ':CopyElixirModule<CR>', { noremap = true, silent = true })
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
    vim.cmd('BufferClose')
  else
    vim.cmd('BufferClose')
    vim.cmd('enew')
    vim.cmd('setlocal bufhidden=wipe')
  end
end
vim.keymap.set('n', '<leader>w', buffer_close, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>b', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-0>', function()
  local nvim_tree = require('nvim-tree.api')
  local current_file = vim.fn.expand('%:p')

  if not nvim_tree.tree.is_visible() then
    nvim_tree.tree.open()
  end

  nvim_tree.tree.find_file(current_file)
end, { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<S-Tab>', ':BufferNext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>o', ':Outline<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-d>', 'yyp', { noremap = true })
vim.api.nvim_set_keymap('v', '<C-d>', 'yP', { noremap = true })

vim.keymap.set('n', '<leader><leader>', function()
  require('telescope').extensions['recent-files'].recent_files({})
end, { noremap = true, silent = true })
vim.keymap.set('i', '<C-BS>', '<C-W>', { noremap = true })
vim.keymap.set('n', '<C-BS>', 'db', { noremap = true })
vim.keymap.set('c', '<C-BS>', '<C-W>', { noremap = true })
vim.api.nvim_create_user_command('CopyElixirModule', function()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  vim.cmd('normal! gg')
  local module_line = vim.fn.search('^\\s*defmodule\\s\\+', 'n')

  if module_line == 0 then
    print("No module definition found.")
    return
  end

  local line = vim.api.nvim_buf_get_lines(0, module_line - 1, module_line, false)[1]
  local module_name = line:match('defmodule%s+([%w%.]+)%s+do')

  if module_name then
    vim.fn.setreg('+', module_name)
    print("Copied to clipboard: " .. module_name)
  else
    print("Couldn't extract module name.")
  end

  vim.api.nvim_win_set_cursor(0, cursor_pos)
end, {})

local function copy_file_path(format)
  local formats = {
    full = "%:p",
    relative = "%:.",
    filename = "%:t",
    directory = "%:p:h",
  }
  local path = vim.fn.fnamemodify(vim.fn.expand("%"), formats[format] or formats.relative)
  vim.fn.setreg("+", path)
  print("📋 " .. path)
end

vim.api.nvim_create_user_command('CopyPath', function(opts)
  copy_file_path(opts.args)
end, {
  nargs = "?",
  complete = function()
    return { "full", "relative", "filename", "directory" }
  end
})

vim.keymap.set('n', '<C-9>', function() copy_file_path("relative") end, { desc = "Copy relative path" })

local function map_word_motion(modes, lhs, rhs_normal, rhs_insert)
  for _, mode in ipairs(modes) do
    if mode == 'i' then
      vim.keymap.set(mode, lhs, rhs_insert, { noremap = true, silent = true })
    else
      vim.keymap.set(mode, lhs, rhs_normal, { noremap = true, silent = true })
    end
  end
end

map_word_motion({ 'n', 'v', 'i' }, '<C-Left>', 'b', '<C-\\><C-O>b')
map_word_motion({ 'n', 'v', 'i' }, '<C-Right>', 'w', '<C-\\><C-O>w')
vim.keymap.set('n', '<2-LeftMouse>', 'viw', { noremap = true, desc = "Select word on double click" })
vim.keymap.set({ 'n', 'v' }, 'd', '"_d', { noremap = true })
vim.keymap.set('n', 'dd', '"_dd', { noremap = true })
vim.keymap.set('n', 'D', '"_D', { noremap = true })
vim.keymap.set({ 'n', 'v' }, 'x', 'd', { noremap = true })
vim.keymap.set('n', 'xx', 'dd', { noremap = true })
vim.keymap.set('n', 'X', 'D', { noremap = true })

require('lualine').setup {
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
      { 'mode',
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
    lualine_c = {
      {
        'filename',
        path = 1,
      }
    },
    lualine_x = { 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' }
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

-- Function definition
function goto_beginning_of_text()
  local line = vim.api.nvim_get_current_line()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local first_non_blank = vim.fn.match(line, "\\S") + 1

  if col == 0 then
    vim.api.nvim_win_set_cursor(0, { row, first_non_blank - 1 })
  elseif col == first_non_blank - 1 then
    vim.api.nvim_win_set_cursor(0, { row, 0 })
  else
    vim.api.nvim_win_set_cursor(0, { row, first_non_blank - 1 })
  end
end

-- Keymaps
vim.keymap.set('n', '<Home>', goto_beginning_of_text, { noremap = true, silent = true })
vim.keymap.set('i', '<Home>', function()
  goto_beginning_of_text()
  vim.cmd('startinsert')
end, { noremap = true, silent = true })
vim.keymap.set('v', '<Home>', goto_beginning_of_text, { noremap = true, silent = true })

require("nvim-tree").setup({
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = false,
    git_ignored = false,
    custom = { "^\\.git$", "^\\.elixir_ls$", "^\\.elixir-tools$", "^_build$", "^deps$", "^node_modules$", "^\\.DS_Store$", "^dist$" },
  },
})

vim.keymap.set('n', '<leader>t', ':enew<CR>', { noremap = true, silent = true })

local function toggle_quickfix()
  local qf_exists = false
  for _, win in pairs(vim.fn.getwininfo()) do
    if win.quickfix == 1 then
      qf_exists = true
    end
  end
  if qf_exists == true then
    vim.cmd "cclose"
  else
    vim.cmd "copen"
  end
end

vim.keymap.set('n', '<leader>q', toggle_quickfix, { noremap = true, silent = true, desc = "Toggle quickfix window" })
vim.api.nvim_set_keymap('v', '<C-S-J>', 'J', { noremap = true, silent = true })
