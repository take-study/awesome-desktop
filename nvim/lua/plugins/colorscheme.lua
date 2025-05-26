-- Gruvbox colorscheme
return {
  "ellisonleao/gruvbox.nvim",
  priority = 1000,
  config = function()
    require("gruvbox").setup({
      terminal_colors = true,
      undercurl = true,
      underline = true,
      bold = true,
      italic = {
        strings = true,
        emphasis = true,
        comments = true,
        operators = false,
        folds = true,
      },
      strikethrough = true,
      invert_selection = false,
      invert_signs = false,
      invert_tabline = false,
      invert_intend_guides = false,
      inverse = true,
      contrast = "",
      palette_overrides = {
        -- Use template variables for consistent theming
        dark0_hard = "{{bg_primary}}",
        dark0 = "{{bg_secondary}}",
        dark1 = "{{bg_tertiary}}",
        light0_hard = "{{fg_primary}}",
        light0 = "{{fg_secondary}}",
        light1 = "{{fg_tertiary}}",
        bright_blue = "{{accent_blue}}",
        bright_green = "{{accent_green}}",
        bright_red = "{{accent_red}}",
        bright_yellow = "{{accent_yellow}}",
      },
      overrides = {},
      dim_inactive = false,
      transparent_mode = false,
    })
    vim.cmd("colorscheme gruvbox")
  end,
}
