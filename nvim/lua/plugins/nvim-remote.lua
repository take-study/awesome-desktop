return {
    "take-study/remote-nvim.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim", -- For standard functions
        "MunifTanjim/nui.nvim", -- To build the plugin UI
        "nvim-telescope/telescope.nvim", -- For picking b/w different remote methods
    },
    config = function()
        require("remote-nvim").setup({
            -- Configuration for devpod connections
            devpod = {
                binary = "devpod-cli",
                docker_binary = "podman", -- Binary to use for docker-related commands
            },
            remote = {
                copy_dirs = {
                    data = {
                        dirs = "*",
                    },
                },
            },
            client_callback = function(port, _)
                vim.fn.jobstart({
                    "{{terminal}}",
                    "{{class_arg}}",
                    '"editor"',
                    "nvim",
                    "--server",
                    ("localhost:%s"):format(port),
                    "--remote-ui",
                }, {
                    detach = true,
                    on_exit = function(job_id, code)
                        if code ~= 0 then
                            vim.notify(("Local client failed with exit code %s"):format(code), vim.log.levels.ERROR)
                        else
                            vim.notify("Open new editor success", vim.log.levels.INFO)
                        end
                    end,
                })
                -- require("remote-nvim.ui").float_term(("{{terminal}} {{class_arg}} \"editor\" nvim --server localhost:%s --remote-ui"):format(port), function(exit_code)
                --     if exit_code ~= 0 then
                --         vim.notify(("Local client failed with exit code %s"):format(exit_code), vim.log.levels.ERROR)
                --     end
                -- end)
            end,
        })
    end,
}
