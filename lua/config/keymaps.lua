local opts = { noremap = true, silent = true }
--
-- Keep cursor centered when scrolling
-- vim.keymap.set("n", "<C-d>", "<C-d>zz", opts)
-- vim.keymap.set("n", "<C-u>", "<C-u>zz", opts)
--
-- -- Keep cursor centered when jump between paragraph
-- vim.keymap.set("n", "{", "{zz", opts)
-- vim.keymap.set("n", "}", "}zz", opts)
--
-- -- Escape to normal mode the easy way
-- vim.keymap.set({ "i", "v" }, "jk", "<Esc>", opts)
--
-- -- Remap for dealing with visual line wraps
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
--
-- -- Move to window using the <ctrl> hjkl keys
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })
--
-- better indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- paste over currently selected text without yanking it
vim.keymap.set("v", "p", '"_dp')
vim.keymap.set("v", "P", '"_dP')
--
-- -- Move to start/end of line
vim.keymap.set({ "n", "x", "o" }, "H", "^", opts)
vim.keymap.set({ "n", "x", "o" }, "L", "g_", opts)
--
-- -- Move selected lines in visual mode up or down, awesome!
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", opts)
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", opts)
--
-- -- Better up/down
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = "Move cursor up" })
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, desc = "Move cursor down" })
--
-- -- ctrl + x to cut full line
vim.keymap.set("n", "<C-x>", "dd", opts)
--
-- Select all
vim.keymap.set("n", "<C-a>", "ggVG", opts)

-- Map enter to ciw in normal mode
vim.keymap.set("n", "<CR>", "ciw", opts)

vim.keymap.set("n", "<Esc>", ":nohlsearch<CR>", opts)

-- copy everything between { and } including the brackets
-- p puts text after the cursor,
-- P puts text before the cursor.
vim.keymap.set("n", "YY", "va{Vy", opts)

-- Panes resizing
vim.keymap.set("n", "+", ":vertical resize +5<CR>")
vim.keymap.set("n", "_", ":vertical resize -5<CR>")
vim.keymap.set("n", "=", ":resize +5<CR>")
vim.keymap.set("n", "-", ":resize -5<CR>")

vim.keymap.set("n", "n", "nzz", opts)
vim.keymap.set("n", "N", "Nzz", opts)
vim.keymap.set("n", "*", "*zz", opts)
vim.keymap.set("n", "#", "#zz", opts)
vim.keymap.set("n", "g*", "g*zz", opts)

-- Move between buffer
vim.keymap.set("n", "[b", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "]b", "<cmd>BufferLineCyclePrev<CR>", { desc = "Previous buffer" })

-- save file
vim.keymap.set({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

-- Reload configuration
local reload = require("config.reload")
vim.keymap.set("n", "<leader>rr", function()
  reload.reload_config()
end, { desc = "Reload Config" })

vim.keymap.set("n", "<leader>rp", function()
  reload.reload_plugins()
end, { desc = "Reload Plugins" })

vim.keymap.set("n", "<leader>ra", function()
  reload.full_reload()
end, { desc = "Reload All (Config + Plugins)" })

-- Quick reload (most common: config only)
vim.keymap.set("n", "<leader>R", function()
  reload.reload_config()
end, { desc = "Quick Reload Config" })
