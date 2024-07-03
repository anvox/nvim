vim.g.have_nerd_font = true
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.opt.colorcolumn = "80"
vim.opt.hlsearch = true
vim.opt.list = true
vim.opt.listchars = { tab = '» ', lead = '·', trail = '·', nbsp = '␣' }
vim.opt.mouse = 'a'
vim.opt.number = true
vim.opt.termguicolors = true
vim.wo.signcolumn = 'yes'

vim.opt.mouse = 'a'
vim.opt.showmode = false
vim.opt.clipboard = 'unnamedplus'
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.inccommand = 'split'
vim.opt.cursorline = true
vim.opt.scrolloff = 0

vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.shiftwidth = 2   -- Number of spaces for each step of (auto)indent
vim.opt.tabstop = 2      -- Number of spaces a tab counts for
vim.opt.softtabstop = 2  -- Number of spaces a tab counts for while editing

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  'nvim-tree/nvim-web-devicons',
  'nvim-tree/nvim-tree.lua',
  -- {
  --   'loctvl842/monokai-pro.nvim',
  --   overrideScheme = function(cs, p, config, hp)
  --     local cs_override = {}
  --     cs_override.editor = {
  --       background = "#212121",
  --     }
  --     return cs_override
  --   end,
  --   lazy = false,    -- make sure we load this during startup if it is your main colorscheme
  --   priority = 1000, -- make sure to load this before all the other start plugins
  --   config = function()
  --     -- load the colorscheme here
  --     vim.cmd([[colorscheme monokai-pro-classic]])
  --   end,
  -- },
  {
    "navarasu/onedark.nvim",
    lazy = false,
    priority = 1000,
  },
  {
    'williamboman/mason.nvim',
    config = function()
      require('mason').setup()
    end
  },
  {
    'williamboman/mason-lspconfig.nvim',
    config = function()
      require('mason-lspconfig').setup()
      require('mason-lspconfig').setup_handlers({
        function(server_name)
          require('lspconfig')[server_name].setup {}
        end,
      })
    end
  },
  "neovim/nvim-lspconfig",
  "zbirenbaum/copilot.lua",
  "jose-elias-alvarez/null-ls.nvim",
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    opts = {
      ensure_installed = { 'bash', 'diff', 'html', 'lua', 'luadoc', 'markdown', "elixir", "eex", "heex", "javascript", "typescript" },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
    config = function(_, opts)
      -- [[ Configure Treesitter ]] See `:help nvim-treesitter`

      -- Prefer git instead of curl in order to improve connectivity in some environments
      require('nvim-treesitter.install').prefer_git = true
      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup(opts)

      -- There are additional nvim-treesitter modules that you can use to interact
      -- with nvim-treesitter. You should go explore a few and see what interests you:
      --
      --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
      --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
      --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    end,
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
      { 'nvim-tree/nvim-web-devicons',            enabled = vim.g.have_nerd_font },
      { 'mollerhoj/telescope-recent-files.nvim' }
      -- { 'smartpde/telescope-recent-files' },
    },
    config = function()
      require('telescope').setup {
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        -- defaults = {
        --   mappings = {
        --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
        --   },
        -- },
        -- pickers = {}
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')
      pcall(require('telescope').load_extension, 'projects')
      pcall(require("telescope").load_extension, 'recent-files')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })
      vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
    end,
    pickers = {
      find_files = {
        on_input_filter_cb = function(prompt)
          local file, line = prompt:match("(.+):(%d+)$")
          if file and line then
            return { prompt = file }
          end
        end,
        attach_mappings = function(prompt_bufnr, map)
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
  },
  {
    'ahmedkhalf/project.nvim',
    config = function()
      require("project_nvim").setup({})
    end,
  },
  "hedyhli/outline.nvim",
  "romgrk/barbar.nvim",
  'echasnovski/mini.comment',
  'lewis6991/gitsigns.nvim',
  "cappyzawa/trim.nvim",
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false }
  },
  { "lukas-reineke/indent-blankline.nvim", main = "ibl",          opts = {} },
  "elixir-editors/vim-elixir",
  { "windwp/nvim-autopairs",               event = "InsertEnter", config = true },
  "nvim-lualine/lualine.nvim"
})

require('onedark').setup {
  style = 'darker'
}
require('onedark').load()
require("outline").setup({})
require('nvim-tree').setup({
  actions = {
    open_file = {
      quit_on_open = true,
    },
  },
  -- Remove the on_attach function if you have it
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
require('copilot').setup({})
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
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>',
          '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wa',
          '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wr',
          '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wl',
          '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>D',
          '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>',
          opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>',
          opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca',
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
    vim.keymap.set('n', '<leader>df', '<cmd>lua vim.lsp.buf.definition()<CR>', { buffer = true })
    vim.keymap.set('n', '<leader>dr', '<cmd>lua vim.lsp.buf.references()<CR>', { buffer = true })
    vim.keymap.set('n', '<leader>dj', '<cmd>lua vim.diagnostic.goto_next()<CR>', { buffer = true })
    vim.keymap.set('n', '<leader>dk', '<cmd>lua vim.diagnostic.goto_prev()<CR>', { buffer = true })
    vim.keymap.set('n', '<leader>dd', '<cmd>lua vim.lsp.buf.hover()<CR>', { buffer = true })
    vim.keymap.set('n', '<leader>di', '<cmd>lua vim.lsp.buf.implementation()<CR>', { buffer = true })
    vim.keymap.set('n', '<leader>cm', ':CopyElixirModule<CR>', { noremap = true, silent = true })
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
    if choice == 1 then     -- Yes
      vim.cmd('write')
    elseif choice == 2 then -- No
      vim.cmd('set nomodified')
    else                    -- Cancel
      return
    end
  end

  if #vim.fn.getbufinfo({ buflisted = 1 }) > 1 then
    vim.cmd('BufferClose')
  else
    -- vim.cmd('quit')
    vim.cmd('BufferClose')
    vim.cmd('enew')
    vim.cmd('setlocal bufhidden=wipe')
  end
end
vim.keymap.set('n', '<leader>w', buffer_close, { noremap = true, silent = true })
vim.keymap.set('n', '<C-b>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
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
vim.api.nvim_set_keymap('n', '<leader>d', 'yyp', { noremap = true })
vim.api.nvim_set_keymap('v', '<leader>d', 'yP', { noremap = true })

vim.keymap.set('n', '<leader><leader>', function()
  require('telescope').extensions['recent-files'].recent_files({})
end, { noremap = true, silent = true })

-- Map Ctrl+Backspace to delete word backwards in insert mode
vim.keymap.set('i', '<C-BS>', '<C-W>', { noremap = true })

-- Map Ctrl+Backspace to delete word backwards in normal mode
vim.keymap.set('n', '<C-BS>', 'db', { noremap = true })

-- Map Ctrl+Backspace to delete word backwards in command mode
vim.keymap.set('c', '<C-BS>', '<C-W>', { noremap = true })

vim.api.nvim_create_user_command('CopyElixirModule', function()
  -- Save the current cursor position
  local cursor_pos = vim.api.nvim_win_get_cursor(0)

  -- Move to the start of the file
  vim.cmd('normal! gg')

  -- Search for the module definition
  local module_line = vim.fn.search('^\\s*defmodule\\s\\+', 'n')

  if module_line == 0 then
    print("No module definition found.")
    return
  end

  -- Get the line content
  local line = vim.api.nvim_buf_get_lines(0, module_line - 1, module_line, false)[1]

  -- Extract the module name
  local module_name = line:match('defmodule%s+([%w%.]+)%s+do')

  if module_name then
    -- Copy to system clipboard
    vim.fn.setreg('+', module_name)
    print("Copied to clipboard: " .. module_name)
  else
    print("Couldn't extract module name.")
  end

  -- Restore the cursor position
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

-- Keymaps for quick access
-- vim.keymap.set('n', '<leader>cpf', function() copy_file_path("full") end, { desc = "Copy full path" })
vim.keymap.set('n', '<C-9>', function() copy_file_path("relative") end, { desc = "Copy relative path" })
-- vim.keymap.set('n', '<leader>9n', function() copy_file_path("filename") end, { desc = "Copy filename" })
-- vim.keymap.set('n', '<leader>9d', function() copy_file_path("directory") end, { desc = "Copy directory path" })

-- Function to create mappings for multiple modes
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

-- Map 'd' to delete to the black hole register (delete without yanking)
vim.keymap.set({ 'n', 'v' }, 'd', '"_d', { noremap = true })

-- Map 'dd' to delete line to the black hole register
vim.keymap.set('n', 'dd', '"_dd', { noremap = true })

-- Map 'D' to delete to end of line to the black hole register
vim.keymap.set('n', 'D', '"_D', { noremap = true })

-- Map 'x' to cut (delete and yank)
vim.keymap.set({ 'n', 'v' }, 'x', 'd', { noremap = true })

-- Map 'xx' to cut (delete and yank) the entire line
vim.keymap.set('n', 'xx', 'dd', { noremap = true })

-- Map 'X' to cut (delete and yank) to end of line
vim.keymap.set('n', 'X', 'D', { noremap = true })

-- Optionally, remap the original 'x' behavior to something else if you want to preserve it
-- vim.keymap.set({'n', 'v'}, '<leader>x', 'x', { noremap = true })
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
      { 'mode', fmt = function(str) return str:sub(1, 3) end } },
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
