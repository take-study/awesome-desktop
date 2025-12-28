return {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
        {
            "mason-org/mason.nvim",
            opts = {
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗",
                    },
                },
            },
        },
        "neovim/nvim-lspconfig",
    },
    config = function()
        -- Configure a server via `vim.lsp.config()` or `{after/}lsp/lua_ls.lua`
        vim.lsp.config("lua_ls", {
            settings = {
                Lua = {
                    runtime = {
                        version = "LuaJIT",
                    },
                    diagnostics = {
                        globals = {
                            "vim",
                            "require",
                        },
                    },
                },
            },
        })
        require("mason").setup()
        -- Note: `nvim-lspconfig` needs to be in 'runtimepath' by the time you set up mason-lspconfig.nvim
        require("mason-lspconfig").setup({
            nsure_installed = { "lua_ls" },
            automatic_enable = true,
        })
    end,
}
