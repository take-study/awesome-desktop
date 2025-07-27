-- Custom theme configuration to ensure consistency with global OneDarkPro theme
-- This module provides additional customizations and utilities for theme management

local M = {}

-- Theme colors using global variables
M.colors = {
    -- Background colors
    bg_primary = "{{bg_primary}}",
    bg_secondary = "{{bg_secondary}}",
    bg_tertiary = "{{bg_tertiary}}",

    -- Foreground colors
    fg_primary = "{{fg_primary}}",
    fg_secondary = "{{fg_secondary}}",
    fg_tertiary = "{{fg_tertiary}}",

    -- Accent colors
    accent_blue = "{{accent_blue}}",
    accent_green = "{{accent_green}}",
    accent_red = "{{accent_red}}",
    accent_yellow = "{{accent_yellow}}",
    accent_orange = "{{accent_orange}}",
    accent_purple = "{{accent_purple}}",
    accent_pink = "{{accent_pink}}",
    accent_cyan = "{{accent_cyan}}",

    -- Semantic colors
    success = "{{success}}",
    warning = "{{warning}}",
    error = "{{error}}",
    info = "{{info}}",

    -- Border colors
    border_active = "{{border_active}}",
    border_inactive = "{{border_inactive}}",
    border_default = "{{border_default}}",

    -- Additional colors
    shadow = "{{shadow}}",
    hover = "{{hover}}",
}

-- Apply custom highlights for better integration
function M.setup_highlights()
    local highlights = {
        -- Editor basics
        Normal = { bg = M.colors.bg_primary, fg = M.colors.fg_primary },
        NormalFloat = { bg = M.colors.bg_secondary, fg = M.colors.fg_primary },
        NormalNC = { bg = M.colors.bg_primary, fg = M.colors.fg_secondary },

        -- Cursor and visual
        Cursor = { bg = M.colors.accent_blue, fg = M.colors.bg_primary },
        CursorLine = { bg = M.colors.bg_secondary },
        CursorColumn = { bg = M.colors.bg_secondary },
        Visual = { bg = M.colors.bg_tertiary },
        VisualNOS = { bg = M.colors.bg_tertiary },

        -- Search
        Search = { bg = M.colors.accent_yellow, fg = M.colors.bg_primary },
        IncSearch = { bg = M.colors.accent_green, fg = M.colors.bg_primary },
        CurSearch = { bg = M.colors.accent_orange, fg = M.colors.bg_primary },

        -- Line numbers
        LineNr = { fg = M.colors.fg_tertiary },
        CursorLineNr = { fg = M.colors.accent_blue, bold = true },
        SignColumn = { bg = M.colors.bg_primary, fg = M.colors.fg_tertiary },

        -- Folds
        Folded = { bg = M.colors.bg_secondary, fg = M.colors.fg_secondary },
        FoldColumn = { bg = M.colors.bg_primary, fg = M.colors.fg_tertiary },

        -- Diffs
        DiffAdd = { bg = M.colors.success, fg = M.colors.bg_primary },
        DiffChange = { bg = M.colors.warning, fg = M.colors.bg_primary },
        DiffDelete = { bg = M.colors.error, fg = M.colors.bg_primary },
        DiffText = { bg = M.colors.accent_yellow, fg = M.colors.bg_primary },

        -- Popups and menus
        Pmenu = { bg = M.colors.bg_secondary, fg = M.colors.fg_primary },
        PmenuSel = { bg = M.colors.accent_blue, fg = M.colors.bg_primary },
        PmenuSbar = { bg = M.colors.bg_tertiary },
        PmenuThumb = { bg = M.colors.accent_blue },

        -- Status line
        StatusLine = { bg = M.colors.bg_secondary, fg = M.colors.fg_primary },
        StatusLineNC = { bg = M.colors.bg_tertiary, fg = M.colors.fg_secondary },

        -- Tabs
        TabLine = { bg = M.colors.bg_secondary, fg = M.colors.fg_secondary },
        TabLineFill = { bg = M.colors.bg_primary },
        TabLineSel = { bg = M.colors.accent_blue, fg = M.colors.bg_primary, bold = true },

        -- Window separators
        WinSeparator = { fg = M.colors.border_inactive },
        VertSplit = { fg = M.colors.border_inactive },

        -- Borders
        FloatBorder = { fg = M.colors.border_active },

        -- Messages
        ErrorMsg = { fg = M.colors.error, bold = true },
        WarningMsg = { fg = M.colors.warning, bold = true },
        MoreMsg = { fg = M.colors.info },
        ModeMsg = { fg = M.colors.fg_primary },

        -- Diagnostics (LSP)
        DiagnosticError = { fg = M.colors.error },
        DiagnosticWarn = { fg = M.colors.warning },
        DiagnosticInfo = { fg = M.colors.info },
        DiagnosticHint = { fg = M.colors.accent_cyan },
        DiagnosticOk = { fg = M.colors.success },

        -- Git signs
        GitSignsAdd = { fg = M.colors.success },
        GitSignsChange = { fg = M.colors.warning },
        GitSignsDelete = { fg = M.colors.error },

        -- Telescope
        TelescopeNormal = { bg = M.colors.bg_primary, fg = M.colors.fg_primary },
        TelescopeBorder = { fg = M.colors.border_active },
        TelescopePromptNormal = { bg = M.colors.bg_secondary },
        TelescopePromptBorder = { fg = M.colors.border_active },
        TelescopeResultsNormal = { bg = M.colors.bg_primary },
        TelescopeResultsBorder = { fg = M.colors.border_active },
        TelescopePreviewNormal = { bg = M.colors.bg_primary },
        TelescopePreviewBorder = { fg = M.colors.border_active },
        TelescopeSelection = { bg = M.colors.bg_tertiary, fg = M.colors.fg_primary },
        TelescopeSelectionCaret = { fg = M.colors.accent_blue },
        TelescopeMultiSelection = { fg = M.colors.accent_green },
        TelescopeMatching = { fg = M.colors.accent_yellow, bold = true },

        -- Tree-sitter semantic highlights
        ["@variable"] = { fg = M.colors.fg_primary },
        ["@variable.builtin"] = { fg = M.colors.accent_red },
        ["@variable.parameter"] = { fg = M.colors.accent_orange },
        ["@variable.member"] = { fg = M.colors.accent_cyan },

        ["@constant"] = { fg = M.colors.accent_cyan },
        ["@constant.builtin"] = { fg = M.colors.accent_orange },
        ["@constant.macro"] = { fg = M.colors.accent_purple },

        ["@string"] = { fg = M.colors.accent_green },
        ["@string.regexp"] = { fg = M.colors.accent_red },
        ["@string.escape"] = { fg = M.colors.accent_cyan },

        ["@character"] = { fg = M.colors.accent_green },
        ["@character.special"] = { fg = M.colors.accent_cyan },

        ["@number"] = { fg = M.colors.accent_orange },
        ["@number.float"] = { fg = M.colors.accent_orange },

        ["@boolean"] = { fg = M.colors.accent_orange },

        ["@function"] = { fg = M.colors.accent_blue },
        ["@function.builtin"] = { fg = M.colors.accent_cyan },
        ["@function.call"] = { fg = M.colors.accent_blue },
        ["@function.macro"] = { fg = M.colors.accent_purple },

        ["@method"] = { fg = M.colors.accent_blue },
        ["@method.call"] = { fg = M.colors.accent_blue },

        ["@constructor"] = { fg = M.colors.accent_yellow },

        ["@parameter"] = { fg = M.colors.accent_orange },

        ["@keyword"] = { fg = M.colors.accent_purple },
        ["@keyword.function"] = { fg = M.colors.accent_purple },
        ["@keyword.operator"] = { fg = M.colors.accent_purple },
        ["@keyword.return"] = { fg = M.colors.accent_purple },
        ["@keyword.conditional"] = { fg = M.colors.accent_purple },
        ["@keyword.repeat"] = { fg = M.colors.accent_purple },
        ["@keyword.import"] = { fg = M.colors.accent_purple },
        ["@keyword.exception"] = { fg = M.colors.accent_red },

        ["@operator"] = { fg = M.colors.fg_primary },

        ["@punctuation.delimiter"] = { fg = M.colors.fg_secondary },
        ["@punctuation.bracket"] = { fg = M.colors.fg_secondary },
        ["@punctuation.special"] = { fg = M.colors.accent_cyan },

        ["@comment"] = { fg = M.colors.fg_tertiary, italic = true },
        ["@comment.documentation"] = { fg = M.colors.fg_secondary, italic = true },

        ["@tag"] = { fg = M.colors.accent_red },
        ["@tag.attribute"] = { fg = M.colors.accent_yellow },
        ["@tag.delimiter"] = { fg = M.colors.fg_secondary },

        ["@type"] = { fg = M.colors.accent_yellow },
        ["@type.builtin"] = { fg = M.colors.accent_cyan },
        ["@type.definition"] = { fg = M.colors.accent_yellow },

        ["@attribute"] = { fg = M.colors.accent_purple },

        ["@property"] = { fg = M.colors.accent_cyan },

        ["@label"] = { fg = M.colors.accent_blue },

        ["@namespace"] = { fg = M.colors.accent_yellow },

        ["@symbol"] = { fg = M.colors.accent_cyan },

        ["@text"] = { fg = M.colors.fg_primary },
        ["@text.strong"] = { fg = M.colors.fg_primary, bold = true },
        ["@text.emphasis"] = { fg = M.colors.fg_primary, italic = true },
        ["@text.underline"] = { underline = true },
        ["@text.strike"] = { strikethrough = true },
        ["@text.title"] = { fg = M.colors.accent_blue, bold = true },
        ["@text.literal"] = { fg = M.colors.accent_green },
        ["@text.uri"] = { fg = M.colors.accent_cyan, underline = true },
        ["@text.math"] = { fg = M.colors.accent_blue },
        ["@text.environment"] = { fg = M.colors.accent_purple },
        ["@text.environment.name"] = { fg = M.colors.accent_yellow },
        ["@text.reference"] = { fg = M.colors.accent_cyan },

        ["@text.todo"] = { fg = M.colors.bg_primary, bg = M.colors.accent_yellow, bold = true },
        ["@text.note"] = { fg = M.colors.bg_primary, bg = M.colors.info, bold = true },
        ["@text.warning"] = { fg = M.colors.bg_primary, bg = M.colors.warning, bold = true },
        ["@text.danger"] = { fg = M.colors.bg_primary, bg = M.colors.error, bold = true },

        ["@diff.plus"] = { fg = M.colors.success },
        ["@diff.minus"] = { fg = M.colors.error },
        ["@diff.delta"] = { fg = M.colors.warning },
    }

    -- Apply all highlights
    for group, opts in pairs(highlights) do
        vim.api.nvim_set_hl(0, group, opts)
    end
end

-- Setup function to be called after colorscheme is loaded
function M.setup()
    -- Wait for colorscheme to load, then apply custom highlights
    vim.schedule(function()
        M.setup_highlights()
    end)
end

return M
