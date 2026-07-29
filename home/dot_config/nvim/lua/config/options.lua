-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- System clipboard routing.
-- Every yank/delete goes to the OS clipboard (pbcopy on macOS, OSC 52 over SSH
-- since Neovim 0.10), so a separate OSCYank plugin is not needed.
vim.opt.clipboard = "unnamedplus"

-- Agentic sync: reload buffers whose file changed on disk (Claude CLI writing
-- files under the editor). `autoread` only takes effect when something triggers
-- a check -- see the `checktime` autocmd in lua/config/autocmds.lua.
vim.opt.autoread = true
