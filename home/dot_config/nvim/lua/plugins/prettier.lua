-- Only run prettier where the project actually defines prettier rules.
--
-- Without this, prettier formats every markdown/json/yaml file anywhere on the
-- machine using its own defaults. That is wrong here: ~/claude-cowork ships a
-- .prettierrc.json (printWidth 80, proseWrap "always") and its pre-commit hook
-- runs `prettier --write` over *.md and *.{json,yml,yaml,ts,js,tsx,jsx}, so
-- format-on-save inside that repo matches the hook exactly and pre-commit stops
-- rewriting files after the fact. Outside a repo with a prettier config --
-- ~/cheatsheets, scratch notes -- files are left alone rather than reformatted
-- to settings nobody chose.
--
-- Flip to false to format markdown everywhere with prettier's defaults.
vim.g.lazyvim_prettier_needs_config = true

return {}
