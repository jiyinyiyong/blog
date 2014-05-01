
## 关于为什么要装 FreeBSD, 以及尝试

微博上遇到聊起 Unix, 被推荐装 FreeBSD, 怪兮兮的无居然想装了
被牛人诱惑的时候总是不能自主啊, 各种有点到他们那就闪光了
FreeBSD 我印象里是个学院派的系统, 架构更好, 我觉得不如 Linux 平民化
目前版本是 9.1 , 163 上没有镜像, 似乎是有源的
他说是用清华的源, 我搜索一下链接, 比官方源速度快:
[liao]: http://weibo.com/ypyf
ftp://ftp.ustb.edu.cn/pub/FreeBSD/9.1/amd64/

另外 FreeBSD 中文论坛, 跟 Gentoo 一样每天帖的活跃度, 挺意外
https://www.freebsdchina.org/forum/index.php
一个麻烦是 FreeBSD 上软件不如 Linux 多, 特别是 Sublime Text 2
http://sublimetext.userecho.com/topic/90760-freebsd-support/
另外 GNOME3 虽然我看到了 Port 到 FreeBSD 的新闻, 可是没结果
虽然 FreeBSD 用了先进的 Clang, 可对 Node 用户影响不大

几个对比 Linux 和 FreeBSD 的帖子. 暂时标记一下
http://os.51cto.com/art/201012/236797.htm
http://www.fengpiaoyu.com/2011/04/freebsd-vs-linux/
http://www.huihoo.org/gnu_linux/thbbs/00000000-9.htm
http://zgod.pixnet.net/blog/post/6979601-freebsd-vs-linux

下载了 64 位 dec1 ISO 之后发现在 32 位虚拟机无法运行
尝试下载 bootonly 版本中.. 进入系统没找到 `ports` 命令..

下载好了 32 位没有安装成功, 然后同学拿去用 VM 装了
因为他内存富裕, 给了 2G, 确认时成功的, 我才想到可能参数太低
于是把内存和磁盘都调大, 安装成功, Vbox 启动顺序调整才进入系统
开始两个人都不知道怎么安装软件, 我加上 163 源似乎没用
尝试基本的 `pkg_add -r vim-lite`, URL 无法 GET
http://hahaxiao.techweb.com.cn/archives/713.html
搜索到的方案是添加参数, 我还是不行
http://forums.nas4free.org/viewtopic.php?f=72&t=1732
```bash
setenv PACKAGESITE ftp://ftp.freebsd.org/pub/FreeBSD/ports/amd64/packages-current/Latest/
```
最后按照网上具体的网址订正了链接, 然后成功安装 Vim
ftp://ftp.freebsd.org/pub/FreeBSD/ports/i386/packages-current/Latest/
接着是 `pkg_add -r gnome2`, 运行后慢了.. 幸好文档在
http://www.freebsd.org/doc/en_US.ISO8859-1/books/handbook/x11-wm.html
还不清楚会下载到什么时候, 以后再说了

具体关于 `pgk_add` 的意思, 在帖子里有讲
https://www.freebsdchina.org/forum/viewtopic.php?t=14435
官方手册里也有关于 `pkg_add` 具体意思的介绍和其他一些命令
http://www.freebsd.org/doc/zh_CN/books/handbook/packages-using.html
Ports 和 Packages 常见的问题也在网上也列出
http://www.freebsd.org/zh/FAQ/ports.html
而两者的区别, 一个是源码, 一个是二进制, 写得还算清晰
http://www.freebsd.org/doc/zh_CN/books/handbook/ports-overview.html

看到 ftp 服务器上有 Node, 直接安装, 没有 npm, 命令行安装
https://github.com/isaacs/npm#fancy-install-unix
刚开始报错 core dump 之类的, 重新运行反而没有问题了
搜到了安装 GHC 的方案, 貌似很多编译脚本内置的, 最终网络原因没装成..
http://book.realworldhaskell.org/read/installing-ghc-and-haskell-libraries.html#id688876
那么 Ports 按说是包含编译其他代码的指令, 安装系统时已安装
http://www.freebsd.org/doc/zh_CN/books/handbook/ports-using.html
至于没有内置的编译脚本, 已知的方案是手动放 `distfiles`
Ports 的命令就是到对应目录 `make install` 之类, 能看到有 `Makefile`

FreeBSD 桌面环境不好, 不打算用, 文档放着..
http://www.freebsd.org/doc/zh_CN/books/handbook/index.html

补一点, 后来同学发现 `setenv` 命令我之前的版本有错, 我更正了
FreeBSD 默认是 `csh`, `setenv` 命令, 中间不能用 `=`, 应该是空格
否则会报错提示变量名需要怎么怎么.. 相关的看文档吧
http://www.freebsd.org/doc/zh_CN/books/handbook/shells.html
想起来 `git` 命令都没有装, 这个时候安装一份好了
