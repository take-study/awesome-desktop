-- Neovim 配置文件
-- 基础设置
vim.g.loaded_netrw = 1 -- 禁用 netrw 插件
vim.g.loaded_netrwPlugin = 1 -- 禁用 netrw 插件的插件部分

vim.opt.number = true -- 显示行号
vim.opt.relativenumber = true -- 显示相对行号
vim.opt.expandtab = true -- 将 Tab 转换为空格（已禁用）
vim.opt.shiftwidth = 4 -- 自动缩进时使用 4 个空格（已禁用）
vim.opt.tabstop = 8 -- Tab 键宽度为 8 个空格
vim.opt.smartindent = true -- 智能自动缩进
vim.opt.wrap = false -- 禁用自动换行
vim.opt.swapfile = true -- 禁用交换文件
vim.opt.backup = false -- 禁用备份文件
vim.opt.undofile = true -- 启用持久化撤销
vim.opt.hlsearch = true -- 禁用搜索高亮
vim.opt.incsearch = false -- 启用增量搜索
vim.opt.termguicolors = true -- 启用 24 位真彩色
vim.opt.scrolloff = 8 -- 光标上下保留 8 行可见
vim.opt.signcolumn = "yes" -- 始终显示符号列（用于 git、诊断等）
vim.opt.updatetime = 50 -- 更新时间（毫秒），影响 CursorHold 事件
vim.opt.clipboard = "unnamedplus" -- 使用系统剪贴板
vim.opt.cursorline = true -- 高亮当前行

-- 显示不可见字符
vim.o.list = true -- 启用列表模式，显示不可见字符
vim.o.listchars = "tab:» ,lead:•,trail:•" -- 设置不可见字符的显示样式：Tab、前导空格、尾随空格

-- 设置 Leader 键
vim.g.mapleader = " " -- 将空格键设为 Leader 键

-- 引导插件管理器
require("lazy-bootstrap") -- 加载 lazy.nvim 插件管理器

-- 加载按键绑定
require("keybind") -- 加载自定义按键映射配置

-- 设置 Avante 插件的搜索环境变量
vim.fn.setenv("GOOGLE_SEARCH_API_KEY", "{{avante_search_key}}") -- Google 搜索 API 密钥
vim.fn.setenv("GOOGLE_SEARCH_ENGINE_ID", "{{avante_search_engine}}") -- Google 自定义搜索引擎 ID
