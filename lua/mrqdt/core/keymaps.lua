-- set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

---------------------
-- General Keymaps -------------------

-- Remap Ctrl+e (scroll down) to Ctrl+j
keymap.set("n", "<A-Down>", "<C-e>", { noremap = true, silent = true, desc = "Scroll down" })
-- Remap Ctrl+y (scroll up) to Ctrl+k
keymap.set("n", "<A-Up>", "<C-y>", { noremap = true, silent = true, desc = "Scroll up" })
-- quick exist insert mode
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- clear search highliights
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- delete single character without copying into register
-- keymap.set("n", "x", '"_x'):

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", {}) -- increment
keymap.set("n", "<leader>-", "<C-x>", {}) -- decrement

-- window management
keymap.set("n", "<C-w>io", "<C-w>v", {}) -- split window vertically
keymap.set("n", "<C-w>op", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<C-w>0", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height

keymap.set("n", "<C-w>nm", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab
-- copy whole file
-- keymap.set("n", "YY", "ggVGy", { desc = "copy whole file" })

keymap.set("n", "YY", function()
  local current_line = vim.fn.line(".") -- Get the current cursor line number
  local current_col = vim.fn.col(".") -- Get the current cursor column number
  vim.cmd("normal! ggVGy") -- Copy the whole file
  vim.fn.cursor({ current_line, current_col }) -- Move cursor back to the original position
end, { desc = "copy whole file and return to current position" })

keymap.set("n", "<A-2>", function()
  -- Perform a search for the next instance of {, [, or (
  vim.fn.search("[=:]", "W") -- W flag means search wraps around the end of the file
end, { desc = "Go to the next instance of = or :" })

keymap.set("n", "<A-1>", function()
  -- Perform a search for the next instance of {, [, or (
  vim.dsads.search("[=:]", "Wb") -- x
end, { desc = "Go to the previous instance of = or :" })

keymap.set("n", "<A-w>", function()
  -- Perform a search for the next instance of {, [, or (
  vim.fn.search("[{[(]", "W") -- W flag means search wraps around the end of the file
end, { desc = "Go to the next instance of {, [, or (" })

keymap.set("n", "<A-q>", function()
  -- Perform a search for the next instance of {, [, or (
  vim.fn.search("[{[(]", "Wb") -- x
end, { desc = "Go to the previous instance of {, [, or (" })
-- Variable to store the last found position

--vim.keymap.set("n", "<A-2>", function()
--  vim.cmd("normal! /[=:]\zs.*\n")
--  vim.cmd("normal! ^")
--end, { desc = "Go to the next = or : and first non-space" })
--

-- Obsidian
-- vim.keymap.set("n", "<leader>oo", ":cd /Users/alex/library/Mobile\\ Documents/iCloud~md~obsidian/Documents/ZazenCodes<cr>")
--
-- convert note to template and remove leading white space
keymap.set("n", "<leader>on", ":ObsidianTemplate note<cr> :lua vim.cmd([[1,/^\\S/s/^\\n\\{1,}//]])<cr>")
-- strip date from note title and replace dashes with spaces
keymap.set("n", "<leader>om", ":ObsidianTemplate note2<cr> :lua vim.cmd([[1,/^\\S/s/^\\n\\{1,}//]])<cr>")
-- must have cursor on title
--vim.keymap.set("n", "<leader>of", ":s/\\(# \\)[^_]*_/\\1/ | s/-/ /g<cr>")
--
-- search for files in full vault
--keymap.set("n", "<leader>os", ":Telescope find_files search_dirs={\"/Users/alex/library/Mobile\\ Documents/iCloud~md~obsidian/Documents/ZazenCodes/notes\"}<cr>")
--keymap.set("n", "<leader>oz", ":Telescope live_grep search_dirs={\"/Users/alex/library/Mobile\\ Documents/iCloud~md~obsidian/Documents/ZazenCodes/notes\"}<cr>")
--
-- search for files in notes (ignore zettelkasten)
-- vim.keymap.set("n", "<leader>ois", ":Telescope find_files search_dirs={\"/Users/alex/library/Mobile\\ Documents/iCloud~md~obsidian/Documents/ZazenCodes/notes\"}<cr>")
-- vim.keymap.set("n", "<leader>oiz", ":Telescope live_grep search_dirs={\"/Users/alex/library/Mobile\\ Documents/iCloud~md~obsidian/Documents/ZazenCodes/notes\"}<cr>")
--
-- for review workflow
-- move file in current buffer to zettelkasten folder
--vim.keymap.set("n", "<leader>ok", ":!mv '%:p' /Users/alex/library/Mobile\\ Documents/iCloud~md~obsidian/Documents/ZazenCodes/zettelkasten<cr>:bd<cr>")
-- delete file in current buffer
--vim.keymap.set("n", "<leader>odd", ":!rm '%:p'<cr>:bd<cr>")
