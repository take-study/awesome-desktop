return {
    "nvim-mini/mini.indentscope",
    version = "*",
    opts = {
        draw = {
            predicate = function(scope)
                local filetype = vim.api.nvim_buf_get_option(0, "filetype")
                return not vim.tbl_contains({ "NvimTree", "ministarter" }, filetype)
            end,
        },
    },
}
