return {
    "mason-org/mason-lspconfig.nvim",
    version = "*",
    dependencies = {
        "mason-org/mason.nvim",
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
            ensure_installed = { "lua_ls", "stylua", "prettier" },
            automatic_enable = true,
        })
        vim.api.nvim_create_autocmd("LspAttach", {
            desc = "LSP actions",
            callback = function()
                local bufMap = function(mode, lhs, rhs, desc)
                    local opts = { buffer = true, desc = desc }
                    vim.keymap.set(mode, lhs, rhs, opts)
                end

                bufMap("n", "<leader>l", "", "Lsp keymap")

                -- Displays hover information about the symbol under the cursor
                bufMap("n", "<leader>lh", vim.lsp.buf.hover, "Show lsp hover")

                -- Jump to the definition
                bufMap("n", "<leader>lt", vim.lsp.buf.definition, "Jump to the definition")

                -- Jump to declaration
                bufMap("n", "<leader>ld", vim.lsp.buf.declaration, "Jump to the declaration")

                -- Lists all the implementations for the symbol under the cursor
                bufMap("n", "<leader>li", vim.lsp.buf.implementation, "List all implementations")

                -- Jumps to the definition of the type symbol
                bufMap("n", "<leader>lo", vim.lsp.buf.type_definition, "Jump to definition of the type symbol")

                -- Lists all the references
                bufMap("n", "<leader>lf", vim.lsp.buf.references, "List all references")

                -- Displays a function"s signature information
                bufMap("n", "<leader>ls", vim.lsp.buf.signature_help, "Display a function signature")

                -- Renames all references to the symbol under the cursor
                bufMap("n", "<leader>lr", vim.lsp.buf.rename, "Rename all references")

                -- Selects a code action available at the current cursor position
                bufMap("n", "<leader>la", vim.lsp.buf.code_action, "Show code action")

                -- Show diagnostics in a floating window
                bufMap("n", "<leader>ll", vim.diagnostic.open_float, "Show diagnostic floating window")

                -- Move to the previous diagnostic
                bufMap("n", "<leader>lp", vim.diagnostic.goto_prev, "Move to the previous diagnostic")

                -- Move to the next diagnostic
                bufMap("n", "<leader>ln", vim.diagnostic.goto_next, "Move to the next diagnostic")
            end,
        })
    end,
}
