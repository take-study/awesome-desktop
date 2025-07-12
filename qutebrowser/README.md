# Qutebrowser Configuration

A modern qutebrowser configuration with OneDarkPro theme integration and enhanced functionality.

## Features

### Theme Integration
- **OneDarkPro theme**: Consistent with the overall desktop theme
- **Dotter template variables**: All colors are managed centrally
- **Dark mode support**: Intelligent dark mode with image preservation

### QR Code & Image Handling
- **QR code preservation**: QR codes and barcodes are never inverted or filtered
- **Smart image handling**: Logos and icons remain readable in dark mode
- **Toggle dark mode**: `Ctrl+Shift+D` to temporarily disable dark mode
- **QR test page**: `Ctrl+Shift+Q` to open QR code display test

### Password Management
- **KeepassXC integration**: Secure password autofill with GPG encryption
- **TOTP support**: Two-factor authentication code generation
- **Secure key storage**: Uses GPG key: `{{gpg-key}}`

## 文件结构

```
qutebrowser/
├── config.py          # Main configuration
├── theme.py           # Theme definitions
├── stylesheet.css     # Custom CSS overrides
├── autoconfig.yml     # Auto-generated settings
├── quickmarks         # Quick access bookmarks
├── bookmarks/         # Browser bookmarks
└── userscripts/       # Custom scripts
    ├── qute-keepassxc # Password manager integration
    ├── qr-test        # QR code display test
    └── translate      # Text translation
```

## Key Bindings

### Navigation
- `h/j/k/l`: Vim-style scrolling
- `J/K`: Previous/next tab
- `X`: Close tab
- `u`: Undo close tab
- `gg/G`: Go to top/bottom
- `d`: Scroll down half page
- `Ctrl+U`: Scroll up half page

### Search
- `/`: Start search
- `n/N`: Next/previous search result

### Zoom
- `+/-`: Zoom in/out
- `=`: Reset zoom

### Password Management
- `pw`: Fill password (normal mode)
- `Alt+Shift+U`: Fill password (insert mode)
- `Ctrl+Shift+P`: Fill TOTP (normal mode)
- `Ctrl+Shift+T`: Fill TOTP (insert mode)
- `Alt+P`: Fill password without GPG (less secure)

### Visual & Debugging
- `Ctrl+Shift+D`: Toggle dark mode
- `Ctrl+Shift+Q`: Open QR code test page
- `F12`: Open developer tools
- `Ctrl+Shift+T`: Translate selected text (caret mode)

## Technical Details

### QR Code Display Fix
The configuration includes several mechanisms to ensure QR codes display correctly:

1. **Image policy**: `colors.webpage.darkmode.policy.images = 'never'`
2. **CSS preservation**: Specific selectors for QR codes, barcodes, and captchas
3. **Background protection**: White background for QR-related images
4. **Filter removal**: Prevents dark mode filters from affecting important graphics

## 主要功能

### 🎨 模块化主题系统
- **独立主题模块** - `theme.py` 包含所有颜色和字体配置
- **完全兼容OneDarkPro主题** - 使用项目全局颜色变量
- **统一配色方案** - 与nvim、tmux、gtk保持一致
- **深色模式优化** - 智能网站主题覆盖
- **自动字体集成** - 使用项目全局字体设置 (`{{font}}`, `{{font_size}}`)

### 🔐 密码管理集成
- **KeepassXC集成** - 通过qute-keepassxc userscript
- **自动填充密码** - 支持用户名和密码自动填充
- **TOTP支持** - 一次性密码(OTP)自动填充
- **安全存储** - 使用GPG加密存储关联密钥
- **多账户支持** - 通过rofi选择多个匹配的账户

### ⌨️ 键绑定
- Vim风格导航 (`h`, `j`, `k`, `l`)
- 标签管理 (`J`/`K` 切换标签, `X` 关闭标签)
- 密码管理 (`pw` 填充密码, `<Alt-Shift-u>` 插入模式填充)
- TOTP支持 (`<Ctrl-Shift-p>` 获取一次性密码)
- 快捷搜索和缩放
- 开发者工具快捷键 (`F12`)

### 隐私设置
- 默认阻止第三方Cookie
- 启用Do Not Track头部
- 智能内容阻塞
- 隐私友好的默认搜索引擎(Startpage)

### 搜索引擎
- `DEFAULT`: Startpage
- `g`: Google
- `gh`: GitHub
- `aw`: Arch Wiki
- `w`: Wikipedia
- `yt`: YouTube
- `r`: Reddit

### 外观定制
- 隐藏窗口装饰
- 智能标签栏显示
- 状态栏仅在模式切换时显示
- 平滑滚动
- 自定义字体(JetBrains Mono/Fira Code)

## 使用方法

### 基本导航
```
h/j/k/l     - 滚动页面
gg/G        - 页面顶部/底部
d/u         - 半页滚动
J/K         - 切换标签
X           - 关闭标签
/           - 搜索
n/N         - 下一个/上一个搜索结果
```

### 🔐 密码管理
```
pw                  - 填充当前网站的密码
<Alt-Shift-u>       - 在输入模式下填充密码
<Ctrl-Shift-p>      - 获取TOTP一次性密码
<Ctrl-Shift-t>      - 在输入模式下填充TOTP
:pass               - 命令行方式填充密码
:totp               - 命令行方式获取TOTP
```

### 快速访问
```
:open gh python     - 在GitHub搜索python
:open aw pacman     - 在Arch Wiki搜索pacman
:quickmark github   - 打开GitHub快速书签
```

### 开发者功能
```
F12         - 开发者工具
:devtools   - 开发者工具
:view-source - 查看页面源码
```

## 配置选项

### KeepassXC密码管理设置

#### 前置要求
1. **安装KeepassXC** 并启用浏览器集成
2. **设置GPG密钥对** (用于安全存储关联密钥)
3. **安装依赖**:
   ```bash
   # Arch Linux
   sudo pacman -S keepassxc python-pynacl rofi
   
   # 或使用pip安装pynacl
   pip install pynacl
   ```

#### 首次设置
1. 在KeepassXC中启用"浏览器集成"功能
2. 首次使用密码填充时，KeepassXC会询问授权
3. 提供一个识别名称(如"qutebrowser")并接受连接

#### 可选配置
如果您有特定的GPG密钥，可以在config.py中指定:
```python
# 使用特定的GPG密钥 (替换 ABC1234 为您的密钥ID)
config.bind('pw', 'spawn --userscript qute-keepassxc --key ABC1234')
```

### 启用/禁用功能
可以通过修改 `config.py` 中的设置来自定义:

```python
# 禁用JavaScript (默认启用)
c.content.javascript.enabled = False

# 修改下载目录
c.downloads.location.directory = '~/Documents/Downloads'

# 更改默认搜索引擎
c.url.searchengines['DEFAULT'] = 'https://duckduckgo.com/?q={}'
```

### 主题自定义
颜色主题通过dotter模板变量控制，在项目根目录的颜色配置中修改:

```yaml
# 主要背景色
bg_primary: "#282c34"
# 强调色
accent_blue: "#61afef"
```

## 兼容性

- **Wayland/X11**: 完全支持
- **HiDPI**: 自动缩放支持
- **字体**: 优先使用编程字体
- **插件**: 支持Greasemonkey脚本
- **广告拦截**: 内置hosts文件拦截

## 故障排除

### 字体问题
如果字体显示异常，请安装推荐的字体:
```bash
# Arch Linux
sudo pacman -S ttf-jetbrains-mono ttf-fira-code

# 或者修改config.py中的font_family设置
```

### 颜色不正确
确保dotter已正确处理模板变量:
```bash
dotter deploy
```

### 快捷键冲突
如果快捷键冲突，可以在config.py中重新绑定:
```python
config.bind('your_key', 'your_command')
```

### 密码管理问题

#### KeepassXC无法连接
```bash
# 检查KeepassXC是否运行
ps aux | grep keepassxc

# 确保浏览器集成已启用
# KeepassXC -> 设置 -> 浏览器集成 -> 启用浏览器集成
```

#### GPG权限问题
```bash
# 检查GPG密钥
gpg --list-keys

# 测试GPG功能
echo "test" | gpg --clearsign
```

#### Python依赖问题
```bash
# 安装/重新安装依赖
pip install --user pynacl
# 或
sudo pacman -S python-pynacl
```

#### 密码填充不工作
1. 确保页面上有输入字段
2. 检查KeepassXC中是否有匹配的URL条目
3. 尝试手动运行: `:spawn --userscript qute-keepassxc`

## 扩展配置

### 添加自定义样式
编辑 `stylesheet.css` 来添加网站特定的样式覆盖。

### 添加搜索引擎
在 `config.py` 中的 `c.url.searchengines` 字典中添加新条目。

### 自定义键绑定
使用 `config.bind()` 函数添加或修改键绑定。

这个配置提供了一个现代、高效且美观的浏览器环境，与您的整体系统主题完美集成。
