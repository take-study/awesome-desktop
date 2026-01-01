return {
    "lewis6991/gitsigns.nvim",
    version = "*",
    opts = {
        signs = {
            add = { text = "┃" },
            change = { text = "┃" },
            delete = { text = "┃" },
            topdelete = { text = "┃" },
            changedelete = { text = "~" },
            untracked = { text = "┆" },
        },
        signs_staged = {
            add = { text = "┃" },
            change = { text = "┃" },
            delete = { text = "┃" },
            topdelete = { text = "┃" },
            changedelete = { text = "~" },
            untracked = { text = "┆" },
        },
    },
    keys = function()
        local gitsigns = require("gitsigns")
        return {
            { "<leader>g", "", desc = "Git action" },
            { "<leader>gj", gitsigns.next_hunk, desc = "Git goto next hunk" },
            { "<leader>gk", gitsigns.prev_hun, desc = "Git goto prev hunk" },
            { "<leader>gp", gitsigns.preview_hunk, desc = "Git preview hunk" },
            { "<leader>gb", gitsigns.blame_line, desc = "Git show line blame" },
            { "<leader>gr", gitsigns.reset_hunk, desc = "Git reset hunk" },
            { "<leader>gd", gitsigns.diffthis, desc = "Git show file diff" },
        }
    end,
}
