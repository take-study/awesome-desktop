return {
    "nvim-mini/mini.sessions",
    version = "*",
    opts = function()
        -- Session 清理配置
        local MAX_SESSIONS = 20 -- 最多保留的 session 数量
        local MAX_INACTIVE_DAYS = 30 -- 超过这么多天未使用的 session 将被删除

        -- 清理过期和多余的 sessions
        local function cleanup_sessions()
            local sessions = require("mini.sessions")
            local session_list = {}

            -- 将 sessions.detected 转换为数组
            for _, session in pairs(sessions.detected) do
                table.insert(session_list, session)
            end

            -- 按修改时间排序（最新的在前）
            table.sort(session_list, function(a, b)
                return a.modify_time > b.modify_time
            end)

            local current_time = os.time()
            local max_inactive_seconds = MAX_INACTIVE_DAYS * 24 * 60 * 60

            -- 遍历并清理 sessions
            for index, session in ipairs(session_list) do
                local should_delete = false

                -- 删除超过最大数量的 session（保留最新的）
                if index > MAX_SESSIONS then
                    should_delete = true
                end

                -- 删除超过指定天数未活动的 session
                if session.modify_time > 0 then
                    local inactive_seconds = current_time - session.modify_time
                    if inactive_seconds > max_inactive_seconds then
                        should_delete = true
                    end
                end

                -- 执行删除
                if should_delete then
                    sessions.delete(session.name, { force = true })
                end
            end
        end

        vim.api.nvim_create_autocmd("ExitPre", {
            callback = function()
                local sessions = require("mini.sessions")
                -- 先清理旧的 sessions
                cleanup_sessions()
                -- 然后保存当前 session
                sessions.write(vim.fn.fnamemodify(vim.fn.getcwd(), ":t"), {})
            end,
        })

        return {
            autowrite = true,
        }
    end,
}
