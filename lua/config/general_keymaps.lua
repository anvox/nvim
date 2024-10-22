vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Elixir

vim.api.nvim_create_user_command('CopyElixirModule', function()
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
end, {})

-- Look like sublime text
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

vim.keymap.set('i', '<C-BS>', '<C-W>', { noremap = true, desc = "Delete word" })
vim.keymap.set('n', '<C-BS>', 'db', { noremap = true, desc = "Delete word" })
vim.keymap.set('c', '<C-BS>', '<C-W>', { noremap = true, desc = "Delete word" })
vim.api.nvim_set_keymap('n', '<C-d>', 'yyp', { noremap = true, desc = "Duplicate current line(s)" })
vim.api.nvim_set_keymap('v', '<C-d>', 'yP', { noremap = true, desc = "Duplicate current line(s)" })
vim.api.nvim_set_keymap('v', '<C-S-J>', 'J',
  { noremap = true, silent = true, desc = "Join selected lines in visual mode" })

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

vim.keymap.set('n', '<Home>', goto_beginning_of_text, { noremap = true, silent = true })
vim.keymap.set('i', '<Home>', function()
  goto_beginning_of_text()
  vim.cmd('startinsert')
end, { noremap = true, silent = true })
vim.keymap.set('v', '<Home>', goto_beginning_of_text, { noremap = true, silent = true })

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
