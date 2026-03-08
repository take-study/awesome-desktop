return {
    "yetone/avante.nvim",
    build = "make",
    event = "VeryLazy",
    version = false, -- 永远不要将此值设置为 "*"！永远不要！
    opts = {
        -- 在此处添加任何选项
        -- 例如
        provider = "copilot",
        providers = {
            copilot = {
                -- model = "claude-sonnet-4.5",
                model = "gpt-5-mini",
            },
        },
        web_search_engine = {
            provider = "google",
        },
        -- https://searx.namejeff.xyz/
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        "nvim-telescope/telescope.nvim", -- 用于文件选择器提供者 telescope
        "nvim-tree/nvim-web-devicons", -- 或 echasnovski/mini.icons
        "zbirenbaum/copilot.lua",
        -- {
        --     -- 如果您有 lazy=true，请确保正确设置
        --     "MeanderingProgrammer/render-markdown.nvim",
        --     opts = {
        --         file_types = { "markdown", "Avante" },
        --     },
        --     ft = { "markdown", "Avante" },
        -- },
        {
            "OXY2DEV/markview.nvim",
            lazy = false,
            branch = "main",
            opts = {
                preview = {
                    filetypes = { "markdown", "Avante", "rst", "html", "typst", "yaml" },
                    ignore_buftypes = {},
                },
                max_length = 99999,
            },
        },
    },
}
