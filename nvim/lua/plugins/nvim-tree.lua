local HEIGHT_RATIO = 0.8 -- You can change this
local WIDTH_RATIO = 0.5 -- You can change this too

local function open_win_config_func()
    local screen_w = vim.opt.columns:get()
    local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
    local window_w = screen_w * WIDTH_RATIO
    local window_h = screen_h * HEIGHT_RATIO
    local window_w_int = math.floor(window_w)
    local window_h_int = math.floor(window_h)
    local center_x = (screen_w - window_w) / 2
    local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()
    return {
        border = "rounded",
        relative = "editor",
        row = center_y,
        col = center_x,
        width = window_w_int,
        height = window_h_int,
    }
end
local function my_on_attach(bufnr)
    local api = require("nvim-tree.api")
    api.config.mappings.default_on_attach(bufnr)
    -- vim.keymap.set("n", "o", api.node.open.tab, { desc = "Open file in tab", buffer = bufnr, remap = true})
end

return {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        require("nvim-tree").setup({
            view = {
                float = {
                    enable = true,
                    open_win_config = open_win_config_func,
                },
            },
            on_attach = my_on_attach,
            filters = {
                git_ignored = false,
            },
        })
    end,
    keys = function()
        return {
            {
                "<leader>e",
                function()
                    local api = require("nvim-tree.api")
                    api.tree.toggle({ find_file = true })
                end,
                desc = "Toggle NvimTree",
            },
        }
    end,
}
