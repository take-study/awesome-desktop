-- fzf-lua fuzzy finder
return {
    'ibhagwan/fzf-lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        local fzf = require('fzf-lua')

        -- Setup fzf-lua with default options
        fzf.setup({
            fzf_bin = 'sk',
            winopts = {
                height = 0.85,
                width = 0.80,
                row = 0.35,
                col = 0.50,
                border = 'rounded',
                preview = {
                    default = 'bat',
                    border = 'border',
                    wrap = 'nowrap',
                    hidden = 'nohidden',
                    vertical = 'down:45%',
                    horizontal = 'right:60%',
                },
            },
            keymap  = {
                builtin = {
                    ["<F1>"] = "toggle-help",
                    ["<F2>"] = "toggle-fullscreen",
                    ["<F3>"] = "toggle-preview-wrap",
                    ["<F4>"] = "toggle-preview",
                    ["<C-d>"] = "preview-page-down",
                    ["<C-u>"] = "preview-page-up",
                },
                fzf = {
                    ["ctrl-z"] = "abort",
                    ["ctrl-a"] = "select-all+accept",
                    ["ctrl-q"] = "select-all+accept",
                },
            }
        })

        -- Key mappings equivalent to telescope
        vim.keymap.set('n', '<leader>ff', fzf.files, {})
        vim.keymap.set('n', '<leader>fg', fzf.live_grep, {})
        vim.keymap.set('n', '<leader>fb', fzf.buffers, {})
        vim.keymap.set('n', '<leader>fh', fzf.help_tags, {})
        vim.keymap.set('n', '<leader>ps', function()
            local input = vim.fn.input("Grep > ")
            if input ~= "" then
                fzf.grep({ search = input })
            end
        end)
    end
}
