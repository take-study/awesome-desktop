-- Plugin manager bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazypath)

-- Load plugins
require("lazy").setup("plugins", {
    change_detection = {
        notify = true,
    },
})
