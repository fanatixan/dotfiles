-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Agentic sync.
-- LazyVim already runs `checktime` on FocusGained/TermClose/TermLeave. That is
-- not enough when the agent writes while nvim keeps focus (same tmux window, or
-- a background CLI run), so extend it to idle time as well: CursorHold fires
-- after `updatetime` ms of inactivity (LazyVim sets 200).
-- `mode() != 'c'` guards against running checktime from the command line, where
-- it errors out.
vim.api.nvim_create_autocmd({ "FocusGained", "CursorHold", "CursorHoldI" }, {
  group = vim.api.nvim_create_augroup("agentic_sync_checktime", { clear = true }),
  pattern = "*",
  command = "if mode() != 'c' | checktime | endif",
})
