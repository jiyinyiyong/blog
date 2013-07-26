
Ubuntu 到 Mac OS X 的头几天
======

买的是 Air, 711

为什么换笔记本
------

原因比较多吧:

* 联想 B460 笔记性能散热跟不上, 用了 3 年 Linux 乱折腾, 怀疑积累问题
* Ubuntu 新版在我的设备上不稳定, 没有时间再去对付 Arch 了
* 离开精弘前, 学弟中间已经有很多 Mac, 对于技术的可用性方面也不再怀疑了
* 公司同事和设备用 Mac, 相互交流时候操作系统习惯不同带来不便
* 对硬件我的知识一片苍白, 自己搭配和筛选各种方案不现实
* 调试 Chrome 插件和以后可能的图片和设计方面问题需要命令行同时能用设计工具

好处是什么
------

目前主要不安心的是价格, 淘宝买的价格 6k, 对我这个背景的人主要还是操心价格
一天多学习和使用以后实际的好处有下面一些, 主要对比之前 Ubuntu:

* 性能. SSD 开机和内存, 响应很快, 虽然明显是硬件原因, 还有重量
* 触摸板, 前所未有的操作方式, 虽然不确定效率高很多, 但比鼠标是舒服
* 上手快, 因为 Ubuntu 就是仿 Mac, 切换以后哪里找配置基本知道
* 大量的快捷方式, 这是 Mac 最让我感觉新奇的. 算是氛围吧
* 细节. Ubuntu 做的时间不长, Mac 让我感觉安定和轻松了许多
* 终于能用大众中文输入法, 和在 Sublime Text 里写中文了
* 安装 Brackets, 以及 PS, 还有 QQ, 等 Linux 死党不轻松的软件

哪些问题
------

Ubuntu 一些操作习惯我想带过来的, 但是 Mac 到底不是 Linux 那套
有些东西我很喜欢, 也许以后会觉得不好, 但现在还是喜欢 Linux 这些细节

* Mirror 为主的包管理, 文件都在固定的几个目录, 这在 Mac 上太多样了
* 快捷键不一致, 配置太多, 这在其他操作系统是问题, 没想 Mac 也是
* 字体渲染, Chrome 上的中文, Ubuntu 的次像素平滑这边不知道哪儿开
* 桌面的形态我不喜欢, 比如最左侧的多面是做什么用的?
* 单个 Workspace 里的窗口切换哪去了, 还有直接切换窗口的工作区
* 打开窗口的菜单进行最大最小的快捷键找不到, 我觉得很重要的
* 输入源英文操作系统里是必选的, 即便我 QQ 拼音已经上了
* 没有 HOME, END, PgDown, PgUp, 文本操作实在变慢了
* 终端的 Title 我想用来显示当前路径, 找不到配置, 被迫改 `PS1`
* Xmodmap 失效, 目前还不会调整键位, 主要是括号的键位

哪些延续的习惯
------

主要是命令和图形界面搭配这样的操作方式, 两边都方便那其实很好

* 命令行, 黑色半透明, 适应宽屏, Bash, 彩色文本, 输入快捷方便
* `brew` 安装开源工具方便. 前端工具, Linux 命令行工具大多都在
* 多个 Workspace, 任意多桌面, 快速全景, 拖动窗口切换
* 快速的命令行和文件搜索功能, 可以直接关闭 Launcher 照常操作
* 按 word 的文本跳转, 删除操作, 以及行头行尾的跳转

值得注意的几点
------

* Sublime Text 在 Linux 下无法正常输入中文. 另外 Brackets 不能安装
* Max 下文本按 word 切换用的是 Option 键, 我半天没认会那个图案
* 键位映射我用 KeyRemap4Macbook 交换了冒号分号, 其他未完成
* Linux 习惯 Ctrl+D 关闭窗口, Mac 下用 Command+W , 需要适应
* `/usr/local/` 默认权限属于用户, 而 Linux 属于 `root`
* Homebrew 安装的命令在 `/usr/local/bin/`, 甚至是 Nginx
* 安装到 `~/Applications/` 里的应用要手动做链接方便终端使用
* NFS 连接需要添加 `-o resvport` 选项, 否则连接不成功
* Ubuntu Chrome 插件 DevTools 焦点和控制存在 Bug, Mac 上正常
* 终端默认是 Zsh, 拷贝 Ubuntu 的 `.bashrc` 配置和插件可用, 记得开颜色
* Git 和 `make` 都需要 XCode 安装, 以及开发者帐号, Ruby Python 自带

其他大概的
------

Mac OS X 有 Node, 有 SSH 环境, 有 Chrome, 有 Sublime
从一开始我就先去确定了这方面问题不会出岔子我才干下决心的
鉴于很多 Linux 转 Mac 的同学的好评, 我最终当然相信了
Java 环境没有配置, XCode 熟悉度很低, 目前还不打算深入

具体的配置两天晚上又是问同学, 又是同事细心指导, 受益很多
主要集中在触摸板和快捷方式使用技巧上, 再是软件安装方面
暗地里谢谢他们, 另外买 Air 对我有点冒险, 以及旧笔记本怎样处理
觉得稍后要看些视频教程和具体文档才能提升, 不然发起交流容易很难
还有现在操作喜欢和肯定会继续用的 Linux 有差异, 也会纠结上边
当然 Mac 界面上用户体验理应比 Linux 要好, 等待发现

欢迎留言指点, 如果 Disqus 的评论正常工作的话...
另外欢迎在 [Issues][issues] 上写, 如果要贴代码或者重要的内容的话
各位 Linux 同学, 应该不会往死里吐槽吧, 当然我会继续用 Linux
Linux 带给我的真的很多, 但我希望能话更多时间在学习 Web 和设计上

[issues]: https://github.com/jiyinyiyong/blog

------

一些后续软件使用和配置:

* KeyRemap4MacBook 用来映射了键位, [配置不麻烦][issue]
* Alfred 2 用来快捷命令, 偶尔会用 SpotLight 搜索命令, Finder 不用
* 字体按照知乎上配置了冬青黑体, 设置较重的次像素渲染, 只能接受了
* 安装 RightZoom 视线窗口的快捷键和最大化功能, 挺常用的
* 按照 LifeHacker 上的方案隐藏了 Dashboard, 以及关闭一些快捷键
* 配置[终端的脚本][title], 总算当前路径是显示在标题栏上了
* 关闭 OS X 某快捷键, 使得 Sublime Text 上 Ctrl Shift Up 正常使用

另外搜索到 AskDifferent 上一些东西, 对系统做了配置不详细查了
OS X 的系统配置里有很多值得留意的配置, 细节很多都能搞定
现在搞不定主要是多个终端多个窗口切换较慢, 目前只能依赖触摸板

[issue]: https://github.com/tekezo/KeyRemap4MacBook/issues/146
[title]: http://superuser.com/questions/79972/set-the-title-of-the-terminal-window-to-the-current-directory