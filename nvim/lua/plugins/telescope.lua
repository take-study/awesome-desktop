-- plugins/telescope.lua:
return {
    "nvim-telescope/telescope.nvim",
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
        }
    end,
}
