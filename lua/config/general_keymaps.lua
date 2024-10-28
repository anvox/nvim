vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

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

vim.api.nvim_set_keymap("n", "ca", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "ca", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "ct", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "ct", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })

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

vim.keymap.set('n', '<C-9>', function()
  local full_path = vim.fn.expand("%:p")
  local cwd = vim.fn.getcwd()
  local relative_path = full_path:sub(#cwd + 2) -- +2 to remove the trailing slash

  vim.fn.setreg("+", relative_path)
  print("📋 " .. relative_path)
end, { desc = "Copy relative path" })

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
