return {
  {
    -- norcalli's repo is archived (dead since 2021, uses deprecated
    -- vim.tbl_flatten). catgoose's rewrite is the maintained successor:
    -- same purpose, new structured config, 0.12-aware (it auto-disables
    -- vim.lsp.document_color so LSP + colorizer don't double-highlight).
    "catgoose/nvim-colorizer.lua",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      filetypes = {
        "css",
        "javascript",
        "html",
        "lua",
        "!TelescopePrompt",
        "!lazy",
        "!mason",
      },
      user_commands = true, -- :ColorizerToggle etc.
      options = {
        parsers = {
          css = true, -- hex, named colors, rgb(), hsl(), oklch, css vars
          css_fn = true, -- rgb()/hsl()/oklch() functions
        },
        display = {
          mode = "background",
        },
      },
    },
  },
}
