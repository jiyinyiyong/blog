
Arch GNOME 里配置 IBus Fcitx 中文输入法
------

似乎中文输入法到了 GNOME 3.6 以后就是蛋疼很多次了
一方面是 IBus 不再默认开启可用, 再是 Fcitx 配置增加
之前在 V2EX 跟帖说想参与些项目, 完了才开始担心自己没时间
现在转了一圈, 想来我只能贡献一篇笔记了. 现在快零点已经好困好累

### IBus

IBus 在 GNOME3 里被依赖的, 自己需要装的只有输入法插件
不过装好一般会不知道怎么用.. 似乎现在不是开启就能用的
第一步设置是在语言选项的输入源里选择比如我用的 IBus Sunpinyin
第二步是终端运行 `qtconfig-qt4` 在 `Interface` 一栏里, 下方输入法选中 IBus
之后可能要重启 GNOME3 会话, 之后应当可用了

### Fcitx

Fcitx 主要是按 Wiki 上操作, 可似乎也不够, 我只能凭经验讲
安装 `fcitx-im` 是第一步, 再是 `~/.xprofile` 里贴好三行环境变量
以及拷贝启动文件到某个 `autostart` 文件夹, 具体见 Wiki
https://wiki.archlinux.org/index.php/Fcitx_(简体中文)
这样 IBus 还是会自动启动, 就需要手动禁用 IBus 启动, 见链接
https://bbs.archlinux.org/viewtopic.php?id=161487
另外界面要美观, 靠 GNOME3 插件才行, 3.8 现在倒正常安装
https://extensions.gnome.org/extension/261/kimpanel/

中间我遇到环境变量贴错的问题, 没发现, 就在 IRC 求助
运行 `fcitx-diagnore` 会看到报错, 对着改能找到语法方面的错误
之后在图形界面上也费了我不少时间, 界面切回中文以后好多了

不过最后还是换回 IBus 了 T_T
