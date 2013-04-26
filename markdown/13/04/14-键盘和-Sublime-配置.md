
我的键盘和 Sublime Text 配置
------

之前有在 Gist 上做备份, Gist 又增加了个人搜索的功能
可能是搜索关键词不清晰, 搜索有些麻烦, 另外我也想记一些说明

### 键位映射

Xmodmap 的配置写在 `~/.Xmodmap` 文件里, Gist 在:
https://gist.github.com/jiyinyiyong/a03fd3767e04a8508755
Arch 上需要手动执行 `xmodmap ~/.Xmodmap` 在每次重启时候重载
按说要 X 在启动时每次读取配置起作用的, 可我没能搞定很久了
文件内容:

```
keycode  18 = 9 bar
keycode  19 = 0 backslash
keycode  20 = minus underscore

keycode  34 = parenleft parenright
keycode  35 = bracketleft bracketright
keycode  47 = colon semicolon
keycode  48 = quotedbl apostrophe

keycode  51 = braceleft braceright
```

之前求助@lilydjwg 被推荐用 Fcitx 插件来替代 Xmodmap 映射键位
实际使用感觉对进入桌面的速度有明显影响, 最后放弃了
另外写钩子在启动 X 自动加载配置的方案, 以后还得再测

这个脚本主要的功能是调整括号引号冒号的位置
`" '` 被交换, `: ;` 也交换了, 这是针对 CoffeeScript 改的
三个括号, 考虑到编辑器自动补全, 被同意放在 `p` 键右边
一次是 `( [ {`, 加上 `Shift` 后依次是 `) ] }`
受影响的键位也跟着做了调整, `9 0` 上依次是 `| \` 两个

### Sublime Text 配置

受键位的影响, Sublime 的快捷键出错, 设置了前两行:

```json
[
  { "keys": ["ctrl+["], "command": "indent" },
  { "keys": ["ctrl+("], "command": "unindent" },
  { "keys": ["ctrl+tab"], "command": "next_view" },
  { "keys": ["ctrl+shift+tab"], "command": "prev_view" }
]
```

后两行是为了 `ctrl tab` 能更直观而调整的,
http://sublimetext.userecho.com/topic/30368-make-ctrltab-only-cycle-tabs-in-current-group-and-in-order-of-appearance/

另外 Settings 完整的配置是这样的, 后面我将做一些解释:
https://gist.github.com/jiyinyiyong/5275061

```json
{
  "draw_centered": true,
  "font_face": "Monaco",
  "font_options":
  [
    "subpixel_antialias"
  ],
  "font_size": 10,
  "highlight_line": true,
  "highlight_modified_tabs": true,
  "ignored_packages":
  [
    "Vintage"
  ],
  "indent_guide_options":
  [
    "draw_normal",
    "draw_active"
  ],
  "line_padding_top": 1,
  "match_brackets_angle": true,
  "shift_tab_unindent": true,
  "show_tab_close_buttons": false,
  "soda_classic_tabs": false,
  "space_auto_indent": true,
  "tab_size": 2,
  "binary_file_patterns": ["node_modules/*"],
  "file_exclude_patterns": ["node_modules/*"],
  "hot_exit": false,
  "remember_open_files": false,
  "translate_tabs_to_spaces": true
}
```

`draw_centered` 是让代码不靠到左边界, 主要是稍微好看一些吧
字体用的 `Monaco`, Github 用的 `Consolas` 类似, 我分辨不出来
我不用 Vintage, 容易造成误操作, 况且 Sublime 快捷键已经很强
个人更期待缩进线跟随光标而不是行头, 跟着光标更灵活

`binary_file_patterns` 是 Goto Anything 功能的配置
可以屏蔽 Node 模块里的文件, 这样搜索范围就缩小了
https://twitter.com/radagaisus/status/290095794520993792
`file_exclude_patterns` 可以屏蔽搜索时的模块文件
http://sublimetext.userecho.com/topic/19456-exclude-filesfolders-from-project-by-specifying-regex-or-relative-path-from-project-root/

`hot_exit` 和 `remember_open_files` 保证重启 Sublime 后单独目录
对此我另外在做的设置是 `gnome-terminal --working-directory=/opt/s`
这样的目的是[在初次打开终端能快速定位到我的代码目录][cd-terminal]
然后 Sublime 每次每次打开都是单独的项目, Goto Anything 就很方便了

[cd-terminal]: http://segmentfault.com/q/1010000000191726#a-1020000000194300

### 缩进

`indent_guide` 是缩进线, Sublime 有三类缩进线, 具体见帖子
http://www.sublimetext.com/forum/viewtopic.php?f=2&t=9267
为此我稍微改动了自带的主题, 用来突出重要的一条
https://gist.github.com/jiyinyiyong/5047540

缩进我采用的是两个空格, 首先制表符在 Github 上很难看, 又不好控制
其次 CoffeeScript 规范是两空格, 缩进深的时候也不太远
然后让 tab 自动转为空格, 这 Sublime 大概有处理, 并不是全局的

另外我有个插件里定义过行头空格键插入两个空格
首先 Backspace 原本就能直接删除两个空格的
我的办法有些 Hack, 不通用, 如果 Sublime 以后能支持就好了
我是写在一个插件里, 但没控制好, 全局都起作用了, 临时这样用着
https://github.com/jiyinyiyong/Cirru.subl/blob/master/Default.sublime-keymap
```json
[
  { "keys": [" "], "command": "insert_snippet", "args": {"contents": "  "}, "context":
    [
      { "key": "setting.space_auto_indent", "operator": "equal", "operand": true },
      { "key": "selection_empty", "operator": "equal", "operand": true, "match_all": true },
      { "key": "preceding_text", "operator": "regex_contains", "operand": "^\\s*$", "match_all": true }
    ]
  }
]
```
