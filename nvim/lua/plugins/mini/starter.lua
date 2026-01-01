return {
    "nvim-mini/mini.starter",
    dependencies = {
        "nvim-mini/mini.sessions",
    },
    version = false, -- wait till new 0.7.0 release to put it back on semver
    event = "VimEnter",
    opts = function()
        local logo = table.concat({
            "            ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
            "            ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
            "            ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
            "            ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
            "            ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
            "            ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
        }, "\n")
        local pad = string.rep(" ", 22)
        local new_section = function(name, action, section)
            return { name = name, action = action, section = pad .. section }
        end

        local starter = require("mini.starter")
        local sessions = require("mini.sessions")

        local items = {}

        for _, value in pairs(sessions.detected) do
            table.insert(
                items,
                new_section(value.name, function()
                    sessions.read(value.name)
                end, "Sessions")
            )
        end
        items = vim.tbl_extend("keep", items, {
            new_section("Find file", "", "Telescope"),
            new_section("Recent files", "", "Telescope"),
            new_section("Find text", "", "Telescope"),
            new_section("Quit", "qa", "Built-in"),
            new_section("New file", "ene | startinsert", "Built-in"),
        })
        local config = {
            evaluate_single = true,
            header = logo,
            items = items,
            content_hooks = {
                starter.gen_hook.adding_bullet(pad .. "░ ", false),
                starter.gen_hook.aligning("center", "center"),
            },
            footer = "",
        }
        return config
    end,
}
