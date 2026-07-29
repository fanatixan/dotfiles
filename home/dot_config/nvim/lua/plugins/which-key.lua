-- Label the shared hotkeys in the which-key menu.
--
-- LazyVim's own groups (<leader>f file/find, b buffer, w windows, q
-- quit/session) are left completely stock -- these entries only name the
-- uppercase keys defined in config/keymaps.lua, which which-key would otherwise
-- list without a description.
return {
  "folke/which-key.nvim",
  opts = {
    spec = {
      { "<leader>F", desc = "Find Files" },
      { "<leader>B", desc = "Buffers" },
      { "<leader>W", desc = "Save File" },
      { "<leader>Q", desc = "Quit Window" },
      { "<leader>E", desc = "Explorer (reveal current file)" },
      { "<leader>G", desc = "Git Files" },
      { "<leader>r", desc = "Recent Files" },
    },
  },
}
