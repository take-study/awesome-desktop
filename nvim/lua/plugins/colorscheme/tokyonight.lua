-- Colorscheme configuration using global theme variables
return {
    {
        "folke/tokyonight.nvim",
        name = "tokyonight",
        lazy = false,
        priority = 1000,
        config = function()
            require("tokyonight").setup({
                -- Style options: storm, moon, night, day
                style = "moon",
                transparent = false,
                terminal_colors = true,
                styles = {
                    comments = { italic = true },
                    keywords = { italic = false },
                    functions = {},
                    variables = {},
                    sidebars = "dark",
                    floats = "dark",
                },

                -- Custom colors using global theme variables
                on_colors = function(colors)
                    colors.bg = "{{bg_primary}}"
                    colors.bg_dark = "{{bg_secondary}}"
                    colors.bg_float = "{{bg_secondary}}"
                    colors.bg_highlight = "{{bg_tertiary}}"
                    colors.bg_popup = "{{bg_secondary}}"
                    colors.bg_sidebar = "{{bg_secondary}}"
                    colors.bg_statusline = "{{bg_secondary}}"
                    colors.fg = "{{fg_primary}}"
                    colors.fg_dark = "{{fg_secondary}}"
                    colors.fg_gutter = "{{fg_tertiary}}"
                    colors.blue = "{{accent_blue}}"
                    colors.blue0 = "{{accent_blue}}"
                    colors.blue1 = "{{accent_alt}}"
                    colors.cyan = "{{accent_cyan}}"
                    colors.green = "{{accent_green}}"
                    colors.green1 = "{{accent_green}}"
                    colors.magenta = "{{accent_purple}}"
                    colors.orange = "{{accent_orange}}"
                    colors.purple = "{{accent_purple}}"
                    colors.red = "{{accent_red}}"
                    colors.red1 = "{{accent_red}}"
                    colors.yellow = "{{accent_yellow}}"
                    colors.comment = "{{fg_tertiary}}"
                    colors.border = "{{border_default}}"
                    colors.border_highlight = "{{border_active}}"
                end,

                -- Custom highlights for consistency with global theme
                on_highlights = function(hl)
                    -- Editor
                    hl.Normal = { bg = "{{bg_primary}}", fg = "{{fg_primary}}" }
                    hl.NormalFloat = { bg = "{{bg_secondary}}", fg = "{{fg_primary}}" }
                    hl.FloatBorder = { fg = "{{accent_blue}}" }

                    -- Cursor and selection
                    hl.Cursor = { bg = "{{accent_blue}}", fg = "{{bg_primary}}" }
                    hl.CursorLine = { bg = "{{bg_secondary}}" }
                    hl.Visual = { bg = "{{bg_tertiary}}" }

                    -- Search
                    hl.Search = { bg = "{{accent_yellow}}", fg = "{{bg_primary}}" }
                    hl.IncSearch = { bg = "{{accent_green}}", fg = "{{bg_primary}}" }

                    -- Line numbers
                    hl.LineNr = { fg = "{{fg_tertiary}}" }
                    hl.CursorLineNr = { fg = "{{accent_blue}}", bold = true }

                    -- Status line
                    hl.StatusLine = { bg = "{{bg_secondary}}", fg = "{{fg_primary}}" }
                    hl.StatusLineNC = { bg = "{{bg_tertiary}}", fg = "{{fg_secondary}}" }

                    -- Popup menu
                    hl.Pmenu = { bg = "{{bg_secondary}}", fg = "{{fg_primary}}" }
                    hl.PmenuSel = { bg = "{{accent_blue}}", fg = "{{bg_primary}}" }

                    -- Diagnostics
                    hl.DiagnosticError = { fg = "{{error}}" }
                    hl.DiagnosticWarn = { fg = "{{warning}}" }
                    hl.DiagnosticInfo = { fg = "{{info}}" }
                    hl.DiagnosticHint = { fg = "{{accent_cyan}}" }

                    -- Git
                    hl.GitSignsAdd = { fg = "{{success}}" }
                    hl.GitSignsChange = { fg = "{{warning}}" }
                    hl.GitSignsDelete = { fg = "{{error}}" }
                end,
            })

            -- Apply the colorscheme
            vim.cmd.colorscheme("tokyonight")
        end,
    },
}
