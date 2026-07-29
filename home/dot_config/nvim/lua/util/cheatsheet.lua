-- Cheat sheet UI: opens ~/cheatsheets/nvim/general.md in a floating window,
-- rendered by render-markdown.nvim. Bound to <leader>? in config/keymaps.lua.
local M = {}

M.path = vim.fn.expand("~/cheatsheets/nvim/general.md")

---@type snacks.win?
local win

--- Open the cheat sheet float, or close it if it is already open.
function M.toggle()
  if win and win:valid() then
    win:close()
    win = nil
    return
  end

  if vim.fn.filereadable(M.path) == 0 then
    vim.notify("Cheat sheet not found: " .. M.path, vim.log.levels.WARN, { title = "Cheat Sheet" })
    return
  end

  win = Snacks.win({
    file = M.path,
    width = 0.85,
    height = 0.85,
    border = "rounded",
    title = " Neovim Cheat Sheet ",
    title_pos = "center",
    minimal = false,
    -- The ASCII cursor diagrams are deeply indented; snacks' indent guides draw
    -- over that leading whitespace and shred the alignment. Off for this buffer.
    b = { snacks_indent = false },
    -- Keep the cheat sheet out of the buffer list, so it never shows up in
    -- <leader>b.
    bo = { buflisted = false },
    wo = {
      number = false,
      relativenumber = false,
      signcolumn = "no",
      statuscolumn = "",
      cursorline = false,
      spell = false,
      wrap = false,
    },
    keys = {
      q = "close",
      ["<esc>"] = "close",
    },
  })
end

-- KNOWN LIMITATION (render-markdown.nvim, floating windows only):
-- once the float is scrolled all the way to the bottom of the buffer -- which
-- G does in one jump -- the whole cheat sheet drops back to raw markdown until
-- you scroll back up. Scrolling with Ctrl-D / Ctrl-U / j / k is unaffected.
--
-- Ruled out by testing, so don't re-try these: it is not anti-conceal, not the
-- cursor line, not a missing redraw event (`change_events` forcing WinScrolled
-- and CursorMoved does not help), and not the buffer type (a scratch buffer
-- behaves identically). The same file opened in a normal split renders
-- correctly at the bottom, which is what pins it to the float.
--
-- If this becomes annoying, swapping the float for a vertical split fixes it
-- outright and matches how ~/.vimrc opens its cheat sheet.

return M
