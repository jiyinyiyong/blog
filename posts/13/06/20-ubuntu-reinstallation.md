
配置 Ubuntu 的一点笔记
------

### 计算机的抽象

结尾这段时间状态不对, 升级 Arch 出错, 于是回到了 Ubuntu
我的想法是这样的, 不做系统运维, 很多工具其实学了也用不到
对于我, 我想要的是一个能快速搭建出功能的工具, 对系统并没兴趣
Ubuntu 13.04 当中, 开发 Unity 造成的 Bug 大多已经修补, 找回了些 10.10 的感觉
Workspace Grid, 也许能唤回一些从前那样的效率吧

关于计算机, 现在想法偶然觉得清晰, 计算机就是为人脑提供扩展的
看代码时想到, 理解东西时大脑会做各种抽象, 方便各种记忆和查找
比如第一次找到某段代码 A, 下次找 A 脑子里就想到 A, 然后重复查找过程
手动跳转很慢, 而计算机能做得很快, 前提是足够强大的抽象
简单的方案是书签加关键词, 下次检索时直接检索关键词就很快

然而计算机无法简单完成这类抽象, 命令行的抽象可能让事情更糟
人们思考的方式有图形, 有抽象, 有文本, 因而作为界面必须有文本
图形布局本身排列的局限, 表明只有多维度的切换才能贴近人们思考的方式
那么, 人们就要设计和实现更好的交互模式, 让电脑能很直接地辅助人脑
当计算机能轻松应对足够层次的抽象, 生活才会简单下来

人们距离目标很远, 编写应用很复杂, 需要大量的时间调整代码调试
编写功能相对简单, 要设计一个能不断生长而不走向崩溃的骨架很难
我的注意力大多在怎么启动一个能健康生长下去的模型, 来建构复杂的软件
现在的我距离目标很远, 显然纠结在 Linux 怎样对付硬件并不能达到目标
况且硬件耗费更多, 也是我所短. 能在系统上安稳地写写代码已经不错了

### Ubuntu 的常用配置

* 命令历史

首先是 Bash 历史记录的头部匹配搜索, 必备的:

```bash
# ~/.bashrc
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
set show-all-if-ambiguous on
set completion-ignore-case on
```

对应就要修改历史文件体积, 大致是这样的代码:
... 没有详细确认, 因为有遇到写了配置依然历史记录不长的.

```
# ~/.bashrc
export HISTCONTROL=erasedups
export HISTSIZE=10000
shopt -s histappend
```

http://blog.macromates.com/2008/working-with-history-in-bash/

* 字体

Ubuntu Mono 还不错, 用了一段时间能接受, 辨识度也还好
我更喜欢 Consolas, 可惜 Ubuntu 上现成安装方案没有找到
更早受同学影响去用 Monaco, 感觉也是非常不错
安装脚本: https://github.com/jiyinyiyong/monaco-font
Ubuntu 上字体比 Arch 上配置轻松多了, 包括 Sublime 也更好看

* 桌面配置

桌面我用的是 Unity, `3 ^ 2` 个桌面的格子, 效果非常棒
![](https://f.cloud.github.com/assets/449224/659426/75391d2a-d695-11e2-89db-3a5555e9c03f.png)
Ubuntu `10.10` 时期的快捷方式大致能回想起来, 于是切换窗口非常自如的感觉
对比的 GNOME3, 纵向排列的桌面很难管理十个以上的桌面

加上 Ubuntu 搜索的 Dash 和 Hud, Chrome 的 TooManyTabs,
更明显的 Bash 历史搜索, Sublime Goto Anything, 我各种依赖搜索
搜索对程序员这么多快捷方式的记忆是很大的解放
我显然期待更多, 计划山寨一下 TooManyTabs 根据个人习惯做个简单的模仿

* SSH 等等

Git 和服务器管理都需要 SSH, 装上了 `openssh-server` 以及 Mosh 等等
和 Robin Ye 学的写 `~/.ssh/config` 配一大堆密钥..
配置服务器自动登录有些繁琐, 一直想用熟 `ssh-copy-id`, 还没成

服务器部署代码依然想用 Git, 原因是我完全用不着大规模部署
但要花大把功夫去找合适的工具再学起来, 觉得会不值呀
我纠结很久, 买了 VPS, 考虑多做前端开发的 Demo 在 VPS 练习和探索
JS 代码模块化一面就是想缩小 repo 体积, Github Pages 因此应该学起来远离
我期待能写复杂应用协助日常的工作, 部署也偏向于个人代码同步

### NFS 挂载文件夹

在不同电脑上切换工作有点麻烦, 想到挂载文件到笔记本上调试网页
以前用过 sshfs, 速度不理想, 搜索之后用 NFS, 看中内核级别的支持
下面这一篇文章给了详细的配置, 从一台电脑可以直接 `mount` 另一台的文件夹
https://www.digitalocean.com/community/articles/how-to-set-up-an-nfs-mount-on-ubuntu-12-04
不过没讲权限问题, Client 只能用 `root` 或者匿名用户编辑另外的文件
后来搜索到 man page 配置了对应的 `anonuid anogid` 达到目的
我在 Client 上编辑, 以 Server 上指定用户的 user id 和 group id 保存
http://manpages.ubuntu.com/manpages/hardy/man5/exports.5.html
http://linux.vbird.org/linux_server/0330nfs.php

实际使用中, 发现 `git` 查看文件超慢, 甚至 Sublime 编辑文件会卡死
后来确认 Sublime 是因为 Gutter 插件卡死, 类似 `git diff` 的慢
于是 `git` 操作我用 Mosh 登陆 Server 进行操作, 速度就快了
另外 Byobu, Mosh, NFS 搭配的环境在断网时能重新连接, 省了不少麻烦
