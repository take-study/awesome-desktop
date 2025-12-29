return {
    "igorlfs/nvim-dap-view",
    version = "*",
    dependencies = {
        "mason-org/mason.nvim",
        "jay-babu/mason-nvim-dap.nvim",
        "mfussenegger/nvim-dap",
    },
    lazy = true,
    config = function()
        local dap = require("dap")
        vim.cmd("hi DapBreakpointColor guifg={{error}}")
        vim.cmd("hi DapStoppedIcon guifg={{warning}}")
        vim.cmd("hi DapStoppedLine guibg={{bg_secondary}}")
        vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DapBreakpointColor", linehl = "", numhl = "" })
        vim.fn.sign_define(
            "DapBreakpointCondition",
            { text = "", texthl = "DapBreakpointColor", linehl = "", numhl = "" }
        )
        vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DapBreakpointColor", linehl = "", numhl = "" })
        vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "", linehl = "", numhl = "" })
        vim.fn.sign_define(
            "DapStopped",
            { text = "", texthl = "DapStoppedIcon", linehl = "DapStoppedLine", numhl = "" }
        )
        dap.adapters.codelldb = {
            type = "executable",
            command = "codelldb", -- or if not in $PATH: "/absolute/path/to/codelldb"
        }
        require("dap-view").setup({
            winbar = {
                show = true,
                -- You can add a "console" section to merge the terminal with the other views
                sections = { "watches", "scopes", "exceptions", "breakpoints", "threads", "repl", "console" },
                -- Must be one of the sections declared above
                default_section = "watches",
                -- Configure each section individually
                base_sections = {
                    breakpoints = {
                        keymap = "B",
                        label = "Breakpoints [B]",
                        short_label = " [B]",
                    },
                    scopes = {
                        keymap = "S",
                        label = "Scopes [S]",
                        short_label = "󰂥 [S]",
                    },
                    exceptions = {
                        keymap = "E",
                        label = "Exceptions [E]",
                        short_label = "󰢃 [E]",
                    },
                    watches = {
                        keymap = "W",
                        label = "Watches [W]",
                        short_label = "󰛐 [W]",
                    },
                    threads = {
                        keymap = "T",
                        label = "Threads [T]",
                        short_label = "󱉯 [T]",
                    },
                    repl = {
                        keymap = "R",
                        label = "REPL [R]",
                        short_label = "󰯃 [R]",
                    },
                    sessions = {
                        keymap = "K", -- I ran out of mnemonics
                        label = "Sessions [K]",
                        short_label = " [K]",
                    },
                    console = {
                        keymap = "C",
                        label = "Console [C]",
                        short_label = "󰆍 [C]",
                    },
                },
            },
            windows = {
                height = 0.25,
                position = "below",
                terminal = {
                    width = 0.5,
                    position = "left",
                    -- List of debug adapters for which the terminal should be ALWAYS hidden
                    hide = {},
                    -- Hide the terminal when starting a new session
                    start_hidden = false,
                },
            },
            render = {
                -- Optionally a function that takes two `dap.Variable`'s as arguments
                -- and is forwarded to a `table.sort` when rendering variables in the scopes view
                sort_variables = nil,
            },
            -- Controls how to jump when selecting a breakpoint or navigating the stack
            -- Comma separated list, like the built-in 'switchbuf'. See :help 'switchbuf'
            -- Only a subset of the options is available: newtab, useopen, usetab and uselast
            -- Can also be a function that takes the current winnr and the bufnr that will jumped to
            -- If a function, should return the winnr of the destination window
            switchbuf = "usetab,newtab",
            -- Auto open when a session is started and auto close when all sessions finish
            auto_toggle = true,
            -- Reopen dapview when switching to a different tab
            -- Can also be a function to dynamically choose when to follow, by returning a boolean
            -- If a function, receives the name of the adapter for the current session as an argument
            follow_tab = false,
        })
    end,
    keys = function()
        local dap = require("dap")
        local dap_view = require("dap-view")
        return {
            { "<F5>", dap.continue, desc = "Start debug" },
            { "<F10>", dap.step_over, desc = "Dap step over" },
            { "<F11>", dap.step_into, desc = "Dap step into" },
            { "<F12>", dap.step_out, desc = "Dap step out" },
            { "<F9>", dap.toggle_breakpoint, desc = "Toggle breakpoint" },
            {
                "<C-F9>",
                function()
                    local input = vim.fn.input("Conditaion> ")
                    if input ~= "" then
                        dap.set_breakpoint(input, nil, nil)
                    end
                end,
                desc = "Set conditaion breakpoint",
            },
            { "<leader>t", dap_view.toggle, desc = "Toggle breakpoint" },
        }
    end,
}
