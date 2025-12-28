function bufmap(mode, lhs, rhs, desc)
    local opts = { desc = desc }
    vim.keymap.set(mode, lhs, rhs, opts)
end

-- Basic keymaps
bufmap("v", "J", ":m '>+1<CR>gv=gv")
bufmap("v", "K", ":m '<-2<CR>gv=gv")
bufmap("n", "J", "mzJ`z")
bufmap("n", "<C-d>", "<C-d>zz", "Page down")
bufmap("n", "<C-u>", "<C-u>zz", "Page up")

-- System clipboard
bufmap({ "n", "v" }, "<leader>y", [["+y]], "Quick Yarnk")
bufmap("n", "<leader>Y", [["+Y]], "Quick Yarnk line")

-- Quick replace
bufmap("n", "<leader>s", [[:%s/<C-r><C-w>/<C-r><C-w>/gI<Left><Left><Left>]], "Quick Replace")

bufmap("n", "<leader>b", "", "Buffer navigation")
bufmap("n", "<leader>bq", "<cmd> bd<CR>", "Quick close buffer")
bufmap("n", "<leader>bn", "<cmd> bn<CR>", "Go next buffer")
bufmap("n", "<leader>bp", "<cmd> bp<CR>", "Go prev buffer")
