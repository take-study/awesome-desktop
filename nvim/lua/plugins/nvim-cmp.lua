return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
    },
    opts = function()
        -- Register nvim-cmp lsp capabilities
        vim.lsp.config("*", { capabilities = require("cmp_nvim_lsp").default_capabilities() })

        vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
        local cmp = require("cmp")
        local defaults = require("cmp.config.default")()
        local auto_select = true
        local select_opts = { behavior = cmp.SelectBehavior.Select }
        return {
            auto_brackets = {}, -- configure any filetype to auto add brackets
            completion = {
                completeopt = "menu,menuone,noinsert" .. (auto_select and "" or ",noselect"),
            },
            preselect = auto_select and cmp.PreselectMode.Item or cmp.PreselectMode.None,
            mapping = cmp.mapping.preset.insert({
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-j>"] = cmp.mapping.select_next_item(select_opts),
                ["<C-k>"] = cmp.mapping.select_prev_item(select_opts),
                ["<Tab>"] = cmp.mapping.confirm({ select = true, behavior = cmp.SelectBehavior.Replace }),
            }),
            formatting = {
                fields = { "menu", "abbr", "kind" },
                format = function(entry, item)
                    local menu_icon = {
                        nvim_lsp = "λ",
                        buffer = "Ω",
                        path = "🖫",
                    }
                    item.menu = menu_icon[entry.source.name]
                    return item
                end,
            },
            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "path" },
                { name = "buffer" },
            }),
            experimental = {
                -- only show ghost text when we show ai completions
                ghost_text = vim.g.ai_cmp and {
                    hl_group = "CmpGhostText",
                } or false,
            },
            sorting = defaults.sorting,
        }
    end,
}
