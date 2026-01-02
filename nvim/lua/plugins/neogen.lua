return {
    "danymat/neogen",
    config = true,
    opts = {
        enable = true,
        snippet_engine = "mini",
    },
    dependecies = {
        "nvim-treesitter/nvim-treesitter",
        "echasnovski/mini.snippets",
    },
    event = "InsertEnter",
    version = "*",
    keys = function()
        local neogen = require("neogen")
        return {
            {
                "<leader>dc",
                neogen.generate,
                desc = "Generate doc comment",
            },
        }
    end,
}
