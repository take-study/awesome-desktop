vim.api.nvim_create_autocmd("LspAttach", {
    desc = "LSP actions",
    callback = function()
        function bufmap(mode, lhs, rhs, desc)
            local opts = { buffer = true, desc = desc }
            vim.keymap.set(mode, lhs, rhs, opts)
        end

        bufmap("n", "<leader>l", "", "Lsp keymap")

        -- Displays hover information about the symbol under the cursor
        bufmap("n", "<leader>lh", vim.lsp.buf.hover, "Show lsp hover")

        -- Jump to the definition
        bufmap("n", "<leader>lt", vim.lsp.buf.definition, "Jump to the definition")

        -- Jump to declaration
        bufmap("n", "<leader>ld", vim.lsp.buf.declaration, "Jump to the declaration")

        -- Lists all the implementations for the symbol under the cursor
        bufmap("n", "<leader>li", vim.lsp.buf.implementation, "List all implementations")

        -- Jumps to the definition of the type symbol
        bufmap("n", "<leader>lo", vim.lsp.buf.type_definition, "Jump to definition of the type symbol")

        -- Lists all the references
        bufmap("n", "<leader>lf", vim.lsp.buf.references, "List all references")

        -- Displays a function"s signature information
        bufmap("n", "<leader>ls", vim.lsp.buf.signature_help, "Display a function signature")

        -- Renames all references to the symbol under the cursor
        bufmap("n", "<leader>lr", vim.lsp.buf.rename, "Rename all references")

        -- Selects a code action available at the current cursor position
        bufmap("n", "<leader>la", vim.lsp.buf.code_action, "Show code action")

        -- Show diagnostics in a floating window
        bufmap("n", "<leader>ll", vim.diagnostic.open_float, "Show diagnostic floating window")

        -- Move to the previous diagnostic
        bufmap("n", "<leader>lp", vim.diagnostic.goto_prev, "Move to the previous diagnostic")

        -- Move to the next diagnostic
        bufmap("n", "<leader>ln", vim.diagnostic.goto_next, "Move to the next diagnostic")
    end,
})
