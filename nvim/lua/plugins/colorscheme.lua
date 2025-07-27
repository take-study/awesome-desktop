-- Colorscheme configuration using global theme variables
return {
    {
        "navarasu/onedark.nvim",
        name = "onedark",
        lazy = false,
        priority = 1000,
        config = function()
            require('onedark').setup({
                -- Main options
                style = 'darker',
                transparent = false,
                term_colors = true,
                ending_tildes = false,
                cmp_itemkind_reverse = false,

                -- Code style
                code_style = {
                    comments = 'italic',
                    keywords = 'none',
                    functions = 'none',
                    strings = 'none',
                    variables = 'none'
                },

                -- Custom colors using global theme variables
                colors = {
                    bg0 = "{{bg_primary}}",
                    bg1 = "{{bg_secondary}}",
                    bg2 = "{{bg_tertiary}}",
                    bg3 = "{{bg_tertiary}}",
                    bg_d = "{{bg_primary}}",
                    bg_blue = "{{accent_blue}}",
                    bg_yellow = "{{accent_yellow}}",
                    fg = "{{fg_primary}}",
                    purple = "{{accent_purple}}",
                    green = "{{accent_green}}",
                    orange = "{{accent_orange}}",
                    blue = "{{accent_blue}}",
                    yellow = "{{accent_yellow}}",
                    cyan = "{{accent_cyan}}",
                    red = "{{accent_red}}",
                    grey = "{{fg_tertiary}}",
                    light_grey = "{{fg_secondary}}",
                    dark_cyan = "{{accent_cyan}}",
                    dark_red = "{{accent_red}}",
                    dark_yellow = "{{accent_yellow}}",
                    dark_purple = "{{accent_purple}}",
                },

                -- Custom highlights for consistency with global theme
                highlights = {
                    -- Editor
                    Normal = { bg = "{{bg_primary}}", fg = "{{fg_primary}}" },
                    NormalFloat = { bg = "{{bg_secondary}}", fg = "{{fg_primary}}" },
                    FloatBorder = { fg = "{{accent_blue}}" },

                    -- Cursor and selection
                    Cursor = { bg = "{{accent_blue}}", fg = "{{bg_primary}}" },
                    CursorLine = { bg = "{{bg_secondary}}" },
                    Visual = { bg = "{{bg_tertiary}}" },

                    -- Search
                    Search = { bg = "{{accent_yellow}}", fg = "{{bg_primary}}" },
                    IncSearch = { bg = "{{accent_green}}", fg = "{{bg_primary}}" },

                    -- Line numbers
                    LineNr = { fg = "{{fg_tertiary}}" },
                    CursorLineNr = { fg = "{{accent_blue}}", bold = true },

                    -- Status line
                    StatusLine = { bg = "{{bg_secondary}}", fg = "{{fg_primary}}" },
                    StatusLineNC = { bg = "{{bg_tertiary}}", fg = "{{fg_secondary}}" },

                    -- Popup menu
                    Pmenu = { bg = "{{bg_secondary}}", fg = "{{fg_primary}}" },
                    PmenuSel = { bg = "{{accent_blue}}", fg = "{{bg_primary}}" },

                    -- Diagnostics
                    DiagnosticError = { fg = "{{error}}" },
                    DiagnosticWarn = { fg = "{{warning}}" },
                    DiagnosticInfo = { fg = "{{info}}" },
                    DiagnosticHint = { fg = "{{accent_cyan}}" },

                    -- Git
                    GitSignsAdd = { fg = "{{success}}" },
                    GitSignsChange = { fg = "{{warning}}" },
                    GitSignsDelete = { fg = "{{error}}" },
                }
            })

            -- Apply the colorscheme
            vim.cmd.colorscheme('onedark')
        end,
    }
}
