return { -- do read the installation section in the readme of mini.snippets!
    "echasnovski/mini.snippets",
    dependencies = "rafamadriz/friendly-snippets",
    event = "InsertEnter", -- don't depend on other plugins to load...
    -- :h MiniSnippets-examples:
    opts = function()
        local snippets = require("mini.snippets")
        return {
            snippets = {
                snippets.gen_loader.from_runtime("global.{json,lua}", {}),
                snippets.gen_loader.from_lang(),
            },
        }
    end,
}
