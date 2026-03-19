return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")
    harpoon:setup()

    -- ⚓ Harpoon Keymaps
    vim.keymap.set("n", "<leader>a", function()
      harpoon:list():add()
      vim.notify("⚓ Harpoon: Added current file", vim.log.levels.INFO)
    end, { desc = "⚓ Harpoon: Add file" })

    vim.keymap.set("n", "<C-e>", function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = "⚓ Harpoon: Open Menu" })

    -- 🔢 Jump to harpoon files 1-5
    vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end, { desc = "⚓ Harpoon: Select 1" })
    vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end, { desc = "⚓ Harpoon: Select 2" })
    vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end, { desc = "⚓ Harpoon: Select 3" })
    vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end, { desc = "⚓ Harpoon: Select 4" })
    vim.keymap.set("n", "<leader>5", function() harpoon:list():select(5) end, { desc = "⚓ Harpoon: Select 5" })

    -- 🔄 Toggle previous & next buffers stored within Harpoon list
    vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end, { desc = "⚓ Harpoon: Previous" })
    vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end, { desc = "⚓ Harpoon: Next" })

    -- 🔭 Telescope integration
    local function toggle_telescope(harpoon_files)
      local file_paths = {}
      for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
      end

      require("telescope.pickers").new({}, {
        prompt_title = "⚓ Harpoon",
        finder = require("telescope.finders").new_table({
          results = file_paths,
        }),
        previewer = require("telescope.config").values.file_previewer({}),
        sorter = require("telescope.config").values.generic_fuzzy_sorter({}),
      }):find()
    end

    vim.keymap.set("n", "<leader>fe", function() toggle_telescope(harpoon:list()) end,
      { desc = "⚓ Harpoon: Telescope Menu" })
  end,
}
