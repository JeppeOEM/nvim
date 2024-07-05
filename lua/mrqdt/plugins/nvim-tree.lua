local function open_with_feh(node)
  local filepath = node.absolute_path
  vim.cmd("!feh " .. filepath)
end

-- Function to open file at cursor
local function open_file_at_cursor()
  local current_buf = vim.api.nvim_get_current_buf()
  local node = require("nvim-tree.lib").get_node_for_buf(current_buf)
  if node and node.absolute_path then
    vim.cmd("edit " .. node.absolute_path)
  end
end

return {
  "nvim-tree/nvim-tree.lua",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    local nvimtree = require("nvim-tree")

    -- recommended settings from nvim-tree documentation
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    nvimtree.setup({
      view = {
        width = 35,
        relativenumber = true,
      },
      -- change folder arrow icons
      renderer = {
        indent_markers = {
          enable = true,
        },
        icons = {
          glyphs = {
            folder = {
              arrow_closed = "", -- arrow when folder is closed
              arrow_open = "", -- arrow when folder is open
            },
          },
        },
      },
      -- disable window_picker for
      -- explorer to work well with
      -- window splits
      actions = {
        open_file = {
          window_picker = {
            enable = false,
          },
        },
      },
      filters = {
        custom = { ".DS_Store" },
      },
      git = {
        ignore = false,
      },
    })
    local function toggle_insert_mode_on_click()
      vim.cmd([[
        augroup NvimTreeMouseClick
        autocmd!
        autocmd CursorMoved,CursorMovedI * if winnr('$') != 0 && &filetype == 'NvimTree' && mode() == 'i' | stopinsert | endif
        augroup END
      ]])
    end

    -- Toggle insert mode when clicking on the nvim-tree buffer
    toggle_insert_mode_on_click()
    -- set keymaps
    local keymap = vim.keymap -- for conciseness

    keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" }) -- toggle file explorer
    keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Toggle file explorer on current file" }) -- toggle file explorer on current file
    keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" }) -- collapse file explorer
    keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" }) -- refresh file explorer
    keymap.set("n", "<Space><CR>", function()
      open_with_feh(require("nvim-tree.lib").get_node_at_cursor())
    end, { desc = "Open image with feh" })

    -- Add this inside your `config` function in your nvim-tree setup
    keymap.set("v", "<A-left>", function()
      -- Switch to insert mode in the nvim-tree pane
      --YY
      vim.cmd("NvimTreeToggle")
      vim.cmd("NvimTreeToggle")
      vim.schedule(function()
        vim.cmd("autocmd WinEnter * if &filetype == 'NvimTree' | startinsert | endif")
      end)
    end, { desc = "Toggle nvim-tree and enter insert mode" })

    keymap.set("n", "<A-left>", function()
      -- Switch to insert mode in the nvim-tree pane
      --
      vim.cmd("NvimTreeToggle")
      vim.cmd("NvimTreeToggle")
      vim.schedule(function()
        vim.cmd("autocmd WinEnter * if &filetype == 'NvimTree' | startinsert | endif")
      end)
    end, { desc = "Toggle nvim-tree and enter insert mode" })

    -- Autocommand to set keymaps in Nvim Tree buffer
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "NvimTree",
      callback = function()
        vim.api.nvim_buf_set_keymap(
          0,
          "i",
          "<Esc>",
          ":lua open_file_at_cursor()<CR>",
          { noremap = true, silent = true }
        )
      end,
    })
  end,
}
