local highlight = {
    "RainbowRed",
    "RainbowYellow",
    "RainbowBlue",
    "RainbowOrange",
    "RainbowGreen",
    "RainbowViolet",
    "RainbowCyan",
}

return {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    ---@module "ibl"
    ---@type ibl.config
    opts = {},
    config = function()
        local hooks = require("ibl.hooks")
        -- create the highlight groups in the highlight setup hook, so they are reset
        -- every time the colorscheme changes
        hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
            vim.api.nvim_set_hl(0, "RainbowRed", { fg = "{{accent_red}}" })
            vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "{{accent_yellow}}" })
            vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "{{accent_blue}}" })
            vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "{{accent_orange}}" })
            vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "{{accent_green}}" })
            vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "{{accent_purple}}" })
            vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "{{accent_cyan}}" })
        end)
        require("ibl").setup({ indent = { highlight = highlight } })
    end,
}
