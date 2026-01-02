return {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
        winbar = {
            enable = true,
        },
    },
    keys = function()
        return {
            {
                "<leader>t",
                function()
                    vim.cmd("ToggleTerm")
                end,
                desc = "ToggleTerm",
            },
        }
    end,
}
