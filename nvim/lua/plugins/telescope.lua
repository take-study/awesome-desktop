-- plugins/telescope.lua:
return {
    "nvim-telescope/telescope.nvim",
    version = "*",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    keys = function()
        local builtin = require("telescope.builtin")
        return {
            { "<leader>f", "", desc = "Telescope search" },
            { "<leader>ff", builtin.find_files, desc = "Telescope find files" },
            { "<leader>fg", builtin.live_grep, desc = "Telescope live grep" },
            { "<leader>fb", builtin.buffers, desc = "Telescope buffers" },
            { "<leader>fh", builtin.help_tags, desc = "Telescope help tags" },
            {
                "<leader>fr",
                [[:%s/<C-r><C-w>/<C-r><C-w>/gI<Left><Left><Left>]],
                desc = "Quick Replace",
                mode = { "n", "v" },
            },
            {
                "<leader>fs",
                function()
                    vim.cmd("excutte 'normal! /<C-r><C-w><CR>'")
                end,
                desc = "Quick Search",
                mode = { "n", "v" },
            },
        }
    end,
}
