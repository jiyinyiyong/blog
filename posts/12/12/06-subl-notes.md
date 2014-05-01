
关于 Sublime 的一些笔记
------

http://www.sublimetext.com/docs/2/
视频: https://tutsplus.com/course/improve-workflow-in-sublime-text-2/

按 Shift 同时鼠标右键点增加光标, 按 Alt 点击移除光标
至于文档是说的 `ctrl shift up` 我尝试了没起效, 而且和系统默认有冲突

`ctrl shift l` 在选中多行是生成多个光标
`ctrl u` 在 Linux 上效果看起来是 `ctrl z`
`ctrl d` 选中当前单词, 而 `alt f3` 选中全部, ESC 回到一个光标

`"auto_complete": false` 可以禁用自动补全, 这个主要是提示菜单
`ctrl space` 和中文输入法有冲突, 我不知道是不是这个原因, 总之不能用

`auto_complete_commit_on_tab` 的值影响到 `enter` 之后是否时回车, `true` 直接回车

[Vintage](http://www.sublimetext.com/docs/2/vintage.html)我不建议, Sublime 风格快捷键挺好的

Dev 版的发布周期大约一月两次

配置文件加载的顺序列表, 上面的配置会被下边的覆盖
```
Packages/Default/Preferences.sublime-settings
Packages/Default/Preferences (<platform>).sublime-settings
Packages/User/Preferences.sublime-settings
<Project Settings>
Packages/<syntax>/<syntax>.sublime-settings
Packages/User/<syntax>.sublime-settings
<Buffer Specific Settings>
```

可以从 console 里输入 Python 命令查看配置:
```python
view.settings().get('font_face')
```

[关于各种缩进在文档上有详细给出](http://www.sublimetext.com/docs/2/indentation.html)

使用 `export EDITOR='subl -w'` 将 subl 作为默认编辑器

console 输入 `sublime.packages_path()` 查看模块路径

[Sublime 的 API](http://www.sublimetext.com/docs/2/api_reference.html) 至少在 console 里能用的吧

console 的开启快捷键是 `ctrl 反引号`, Linux 中 Sublime 的 Python 和系统的 Python 不同
Sublime 用 JSON 配置, 但也能找到 XML

Sublime 兼容 TextMate 但需要 `.tmLanguage .tmPreferences` 后缀
`.plist` 后缀会被无视
Emacs 用户自己大概都不知道什么是 Emacs... 所以...


[命令里搜索 Add Repository 可以把 Github repo URL 输入来添加包](http://tech.enekochan.com/2012/05/03/easely-add-plugins-to-sublime-text-2/)

原来 `ctrl d` 选中可以用 `ctrl u` 回退, 可以用 `ctrl k` 跳过当前选中项

`alt shift up` 以及 `down` 可以在同一列生成多个光标
另外 `ctrl shit m` `ctrl shift j` 分别扩展选中到括号和缩进

Sublime 的正则用 `alt r` 开关, 用的是[Perl 的 boost 正则](http://www.boost.org/doc/libs/1_47_0/libs/regex/doc/html/boost_regex/syntax/perl_syntax.html).. 不知道改叫系统还是方言
大小写开关是 `alt c`, `alt w` 大概是否精确匹配一段字符, 否则会匹配所有的
`ctrl i` 输入字符时选中跳转到该字符串, 按下回车就完成了
`ctrl alt h` 打开匹配替换, `ctrl alt enter` 替换所有

搜索选中的情况下, `f3` 跳到下一个选中项, `shift f3` 上一个, `alt f3` 到所有
有 `ctrl enter` 在搜索框中输入 `enter`

没看懂这句...
> Goto Anything provides the operator # to search in the current buffer. The search term will be the part following the # operator.

`ctrl shift f` 打开多个文件的搜索和替换, Where 的位置是搜索范围, 推荐用右边的 `...` 选中添加
根据左边的图标是否开始 use buffer, 搜索结果不一样, 还有是否 show content, 显示内容有不同
用 `f4` 和 `shift f4` 遍历.. 可以在不同文件之间跳转

Package 里面有 `.sublime-build` 后缀的文件, 语法用 JSON, 配置 build 的内容
```json
{
    "cmd": ["python", "-u", "$file"],
    "file_regex": "^[ ]*File \"(...*?)\", line ([0-9]*)",
    "selector": "source.python"
}
```
`f7` 运行 build, [更多具体的内容看文档](http://docs.sublimetext.info/en/latest/file_processing/build_systems.html)

`ctrl p` 的 goto anything 功能可以加 `#` 后面放搜索文件的内容 `ctrl ;` 等于 `enter`
加 `@` 是搜索 active buffer(我不懂什么意思, 印象里视频有放过和插件配合搜索到类的)
加 `:` 能跳到指定行数

`ctrl k` `ctrl b` 连续来打开关闭侧边栏,, `ctrl shift p` 搜索 `sidebar` 也可以做到
按下 `ctrl 0` 之后方向键到了侧边栏, 文件夹上可以用左右.. `esc` 返回

通过菜单或者搜索命令可以 `project save as` 保存项目, 这样根目录多出两个文件
`.sublime-workspace` 文件是系统的, `.sublime-project` 是另一个,
里面估计可以自己写配置, 而且这个配置可以覆盖 User 里设置的内容
[这里的配置参照文档, 也有关于 build 的配置可以写](http://www.sublimetext.com/docs/2/projects.html)
之后用 `ctrl alt p` 可以搜索跳转项目

[快捷键修改似乎其中的命令和 API 的函数对应, 到了写插件探索下](http://docs.sublimetext.info/en/latest/customization/key_bindings.html)

控制台能用的命令应该就对应 API 了, 具体看[手册](http://docs.sublimetext.info/en/latest/reference/commands.html)
```python
view.run_command("goto_line", {"line": 10})
view.run_command('insert_snippet', {"contents": "<$SELECTION>"})
view.window().run_command("prompt_select_project")
```

`ctrl alt q` 录制和结束录制宏, `ctrl alt shift q` 播放宏,
保存宏的话在 Tools 菜单里有.. 不过没看到关于怎么打开一个宏...

Sublime 扩展的文件后缀识别写在 `CoffeeScript.tmLanguage` 的 `<key>fileTypes</key>` 后边

Sublime 的 Snippets 里允许[用 `$` 开头的环境变量](http://docs.sublimetext.info/en/latest/extensibility/snippets.html)
比如下面这样写在 `<![CDATA[  ]]>` 中间, `$` 开头的环境变量慧聪对应表中替换
```
====================================
USER NAME:          $TM_FULLNAME
FILE NAME:          $TM_FILENAME
 TAB SIZE:          $TM_TAB_SIZE
SOFT TABS:          $TM_SOFT_TABS
====================================
```
具体用到去查好了, 另外 Snippets 能触发正则, 但我没弄成功

[文档提到 `.sublime-completions` 文件可以配置针对语言的补全](http://docs.sublimetext.info/en/latest/extensibility/completions.html), 却没详写文件放在哪...
我在包里搜索, 只有 HTML 和 PHP 有该后缀的文件.. 我去掉后边内容尝试没成功
```json
"scope": "source.php - variable.other.php"
"scope": "text.html - source - meta.tag, punctuation.definition.tag.begin"
```

有补全菜单的情况下用 `shift tab` 来输入 `tab`, 同理 `ctrl enter`

[往 Command palette 里添加命令的文档](http://docs.sublimetext.info/en/latest/extensibility/command_palette.html)

[Sublime 定义语法的文档看不懂... 本地也没搜到例子](http://docs.sublimetext.info/en/latest/extensibility/syntaxdefs.html)

[插件的写法, 基本的插件好写](http://docs.sublimetext.info/en/latest/extensibility/plugins.html), 从菜单创建保存开启新的 buffer 就能尝试了
command 的名字和类名的前面部分大致相同, 另外要编写 `.run()` 之类方法供调用
总之 Python 的内容, 再说吧

一个学习 Python API 的技巧是把 Package/ 下的 Default/ 用 Sublime 打开
然后搜索 API 的名字(... 我怎么知道 API 什么名字...)阅读源代码

[Linux 的快捷键和 WIndows 的写在一起的](http://docs.sublimetext.info/en/latest/reference/keyboard_shortcuts_win.html), [Max OS X 是单独的](http://docs.sublimetext.info/en/latest/reference/keyboard_shortcuts_osx.html)
值得注意用 `ctrl shift v` 粘贴来保持缩进
`ctrl ;` 挑战到某个单词
`alt 1` 到打开的第一个文件, 数字类推
`ctrl f2` 和 `ctrl shift f2` 控制书签, `f2` 和 `shift f2` 在不同的书签切换
`ctrl k u` 和 `ctrl k l` 切换大小写

[Commands](http://docs.sublimetext.info/en/latest/reference/commands.html)估计对应能在 consnole 中被 `view.run_command()` 运行的
关于 [Plugins](http://docs.sublimetext.info/en/latest/reference/plugins.html) 怎么和代码的交互之类也不好懂

关于 Theme 本地能找到模板(.. 名字还跟 Scheme 重了的), 但没文档
插件感觉很难,, 不看了 [How to Create a Sublime Text 2 Plugin](http://net.tutsplus.com/tutorials/python-tutorials/how-to-create-a-sublime-text-2-plugin/)