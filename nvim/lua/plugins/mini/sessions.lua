return {
    "nvim-mini/mini.sessions",
    version = "*",
    opts = function()
        vim.api.nvim_create_autocmd("ExitPre", {
            callback = function()
                require("mini.sessions").write(vim.fn.fnamemodify(vim.fn.getcwd(), ":t"), {})
            end,
        })
        return {
            autowrite = true,
        }
    end,
}
