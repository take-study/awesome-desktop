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

        -- 将 sessions.detected 转换为数组并按最后修改时间排序
        local session_list = {}
        for _, value in pairs(sessions.detected) do
            table.insert(session_list, value)
        end

        -- 按最后修改时间降序排序（最新的在前面）
        table.sort(session_list, function(a, b)
            return a.modify_time > b.modify_time
        end)

        -- 添加排序后的 sessions 到 items
        for _, value in ipairs(session_list) do
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
