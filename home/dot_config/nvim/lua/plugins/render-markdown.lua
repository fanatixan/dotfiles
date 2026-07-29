-- In-buffer markdown rendering: Unicode tables, headings, bullets, code blocks.
-- Requires a Nerd Font in the host terminal for the icons (FiraCode Nerd Font
-- is installed on this machine).
return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" },
  ft = { "markdown", "codecompanion" },
  opts = {
    -- Force an unconditional re-render on scroll and cursor movement.
    -- Both events are already listened to, but their updates are best-effort
    -- and get skipped in a floating window: jumping with G (cursor on the
    -- buffer's last line) left the whole float showing raw markdown until some
    -- other key was pressed. Very visible in the <leader>? cheat sheet, which
    -- is read by scrolling. Listing the events here makes the redraw
    -- unconditional. Cost is a redraw of the visible range per cursor move,
    -- which is the same order of work anti-conceal already does.
    change_events = { "WinScrolled", "CursorMoved" },

    -- Render everything except the line the cursor sits on, so the raw source
    -- is still editable in place.
    render_modes = { "n", "c", "t" },
    heading = { sign = false },
    code = { sign = false, width = "block", right_pad = 2 },
    -- Unicode box-drawing tables.
    pipe_table = { preset = "round" },
  },
}
