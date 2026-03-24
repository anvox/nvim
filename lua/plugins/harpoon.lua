return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")
    harpoon:setup()

    -- 🔭 Define Harpoon Sign
    vim.fn.sign_define("HarpoonSign", { text = "⚓", texthl = "DiagnosticSignInfo", linehl = "", numhl = "" })

    local function update_harpoon_signs()
      local list = harpoon:list()
      local bufnr = vim.api.nvim_get_current_buf()
      local file_path = vim.api.nvim_buf_get_name(bufnr)

      -- Clear existing signs
      vim.fn.sign_unplace("HarpoonSigns", { buffer = bufnr })

      for _, item in ipairs(list.items) do
        -- Convert relative harpoon paths to absolute for comparison
        local full_item_path = vim.fn.fnamemodify(item.value, ":p")
        if full_item_path == file_path then
          if item.context and item.context.row then
            vim.fn.sign_place(0, "HarpoonSigns", "HarpoonSign", bufnr, { lnum = item.context.row, priority = 10 })
          end
        end
      end
    end

    -- Update signs when entering a buffer or after harpoon list changes
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
      callback = update_harpoon_signs,
    })

    -- 🔭 Telescope integration
    local function toggle_telescope(harpoon_files)
      local file_paths = {}
      for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item)
      end

      require("telescope.pickers").new({}, {
        prompt_title = "⚓ Harpoon",
        finder = require("telescope.finders").new_table({
          results = file_paths,
          entry_maker = function(item)
            return {
              value = item.value,
              display = item.value,
              ordinal = item.value,
              filename = item.value,
              harpoon_item = item,
              lnum = item.context and item.context.row or 1,
              col = item.context and item.context.col or 1,
            }
          end,
        }),
        previewer = require("telescope.config").values.grep_previewer({}),
        sorter = require("telescope.config").values.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, map)
          local actions = require("telescope.actions")
          local action_state = require("telescope.actions.state")

          actions.select_default:replace(function()
            local selection = action_state.get_selected_entry()
            actions.close(prompt_bufnr)

            local item = selection.harpoon_item
            vim.api.nvim_command("edit " .. item.value)

            -- Harpoon 2 stores position in context.row and context.col
            if item.context and item.context.row and item.context.col then
              vim.api.nvim_win_set_cursor(0, { item.context.row, item.context.col })
            end
          end)

          -- Delete mapping
          local function delete_harpoon_item()
            local selection = action_state.get_selected_entry()
            if selection then
              harpoon:list():remove(selection.harpoon_item)
              actions.close(prompt_bufnr)
              vim.schedule(function()
                toggle_telescope(harpoon:list())
              end)
            end
          end

          map("i", "<C-d>", function()
            delete_harpoon_item()
          end)

          map("n", "d", function()
            delete_harpoon_item()
          end)

          return true
        end,
      }):find()
    end

    vim.keymap.set("n", "<C-e>", function() toggle_telescope(harpoon:list()) end,
      { desc = "⚓ Harpoon: Telescope Menu" })

    -- ⚓ Harpoon Keymaps
    vim.keymap.set("n", "<leader>a", function()
      harpoon:list():add()
      vim.notify("⚓ Harpoon: Added current file", vim.log.levels.INFO)
    end, { desc = "⚓ Harpoon: Add file" })

    -- 🔢 Jump to harpoon files 1-5
  end,
}
