-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
-- This file is the single source of truth for the hotkeys shared with ~/.vimrc.
-- Both editors use Space as leader and bind the same keys to the same actions,
-- so muscle memory carries between them. Change one, change both.
--
-- Why the shifted keys: LazyVim owns a menu under lowercase <leader>f, b, w and
-- q (31 mappings). Binding those bare letters makes each one ambiguous, so Vim
-- waits `timeoutlen` (300ms, measured) before firing, and <leader>w / <leader>q
-- are shadowed by their group prefix entirely. Living on the uppercase twins
-- keeps LazyVim completely stock -- its own docs and every community answer
-- still apply -- and these fire instantly because nothing shares their prefix.
--
-- Keys that never collided (/, l, r, G, e, E, ?) stay as they are.

local map = vim.keymap.set

-- Files and search                                    -- ~/.vimrc equivalent
map("n", "<leader>F", function() Snacks.picker.files() end, { desc = "Find Files" })          -- :Files
map("n", "<leader>B", function() Snacks.picker.buffers() end, { desc = "Buffers" })           -- :Buffers
map("n", "<leader>/", function() Snacks.picker.grep() end, { desc = "Grep (project)" })       -- :Rg
map("n", "<leader>l", function() Snacks.picker.lines() end, { desc = "Buffer Lines" })        -- :BLines
map("n", "<leader>r", function() Snacks.picker.recent() end, { desc = "Recent Files" })       -- :History
map("n", "<leader>G", function() Snacks.picker.git_files() end, { desc = "Git Files" })       -- :GFiles

-- Find files including gitignored ones -- for the .env-style files that are
-- deliberately ignored but still need editing. Noisy by nature (node_modules
-- comes too), so it is a separate key rather than the default.
-- Inside any picker, <a-i> toggles this at runtime; in the explorer it is `I`.
map("n", "<leader>I", function()                                                              -- :FilesAll
  Snacks.picker.files({ hidden = true, ignored = true })
end, { desc = "Find Files (incl. ignored)" })

-- File explorer
map("n", "<leader>e", function() Snacks.explorer() end, { desc = "Explorer" })                -- :NERDTreeToggle
map("n", "<leader>E", function() Snacks.explorer.reveal() end, { desc = "Explorer (reveal current file)" }) -- :NERDTreeFind

-- Quality of life
map("n", "<leader>W", "<cmd>w<cr>", { desc = "Save File" })                                   -- :w
map("n", "<leader>Q", "<cmd>q<cr>", { desc = "Quit Window" })                                 -- :q

-- Cheat sheet float. Displaces LazyVim's "Buffer Keymaps (which-key)", which
-- is still reachable with :WhichKey.
--
-- These live in config/keymaps.lua rather than a plugin `keys` spec because
-- several of them (<leader>e, <leader>E, <leader>?) collide with a key LazyVim
-- or which-key already claims, and plugin key registration order is not
-- deterministic. This file loads last, so they reliably win. snacks.nvim is
-- loaded eagerly by LazyVim, so calling Snacks.* directly here is safe.
map("n", "<leader>?", function()
  require("util.cheatsheet").toggle()
end, { desc = "Cheat Sheet" })
