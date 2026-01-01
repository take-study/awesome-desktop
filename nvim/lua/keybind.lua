local bufMap = function(mode, lhs, rhs, desc)
    local opts = { desc = desc }
    vim.keymap.set(mode, lhs, rhs, opts)
end

-- Basic keymaps
bufMap("v", "J", ":m '>+1<CR>gv=gv")
bufMap("v", "K", ":m '<-2<CR>gv=gv")
bufMap("n", "J", "mzJ`z")
bufMap("n", "<C-d>", "<C-d>zz", "Page down")
bufMap("n", "<C-u>", "<C-u>zz", "Page up")

-- System clipboard
bufMap({ "n", "v" }, "<leader>y", [["+y]], "Quick Yarnk")
bufMap("n", "<leader>Y", [["+Y]], "Quick Yarnk line")

-- Quick replace

bufMap("n", "<leader>b", "", "Buffer navigation")
bufMap("n", "<leader>bq", "<cmd> bd<CR>", "Quick close buffer")
bufMap("n", "<leader>bn", "<cmd> bn<CR>", "Go next buffer")
bufMap("n", "<leader>bp", "<cmd> bp<CR>", "Go prev buffer")
