
第二轮装 Arch... 把用到的几个链接放在这里
======

原文在 Issues: https://github.com/jiyinyiyong/blog2/issues/1

前面由于 [Arch 升级到 systemd 导致 grub 和 GNOME3 不兼容的问题](http://weibo.com/1574434782/z39tLfyRs) 不能正常进入系统
昨天下午努力在虚拟机尝试了一遍, 昨晚安装完成, 早上继续收尾, 还是比较流畅的
总体感觉 Arch 安装非常方便, 只是学习曲线较陡, 并且可能遇到一些难缠的 bug
对于前者, 建议多看[Arch 中文官方站点](http://www.archlinuxcn.org/), 多上[论坛](https://bbs.archlinuxcn.org/)和[邮件列表](https://groups.google.com/forum/?fromgroups#!forum/archlinux-cn), 保持信息的畅通和活跃
对于后者, Google 和论坛发帖大概是手头仅有的方案, Wiki 和英文社区的方案比较靠谱

我下载的是 [2012.11.01](http://mirrors.163.com/archlinux/iso/) 放出的镜像, 已经[切换到了 `systemd` 作为默认](https://www.archlinuxcn.org/systemd-is-now-the-default-on-new-installations/)
安装的主体部分参考上次安装参考的[ArchLinux 2012.07.15 安装教程](http://blog.rebill.info/archives/arch-linux-2012-07-15-install-guide.html)进行,
关于时间更新的版本参考了[Archlinux 2012.10 u盘启动安装到硬盘配置记录](http://sandy.is-programmer.com/posts/36189.html)来安装
流程大概是先从 LiveUSB 进入系统, 用 `fdisk /dev/sda` 在安装的硬盘上分区
然后用 `mkfs.ext3 mkswap mkfs.ext4` 格式化分区, 注意 `/boot` 我用了 `ext3`
这里还是要用 `dhcpcd` 联网, 我在局域网里所以比较方便, 建议用网线
然后挂载 `/dev/sda` 3 个分区到 `/mnt` 相应目录, 并用 `pacstrap` 往其中安装基础的软件
按提示除了 `base base-devel` , 网络相关还有 `vim pacman` 一些会用到的软件先装了
之后写一个分区表, 就是 `fstab` 开头的命令, 之后 `arch-chroot /mnt` 进入那个系统

接着是用已经连接好的网络安装软件和配置挂载的系统, 很多命令已经能用了
比如 `pacman` 在这个环境能安装, 也能用 `Vim`, 接下来修改相关配置文件
注意因为换到 `systemd`, 原先的 `rc.conf` 不再推荐, 注意看[ Systemd 的 Wiki ](https://wiki.archlinux.org/index.php/Systemd_\(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87\)#Replacing_ConsoleKit_with_systemd-logind)再进行配置
而且 [Wiki 上的安装教程](https://wiki.archlinux.org/index.php/Installation_Guide_(%E6%AD%A3%E9%AB%94%E4%B8%AD%E6%96%87))也已经做了对应的修改, 默认 Systemd 的方式配置
这里有一步 `mkinitcpio -p linux` 用来做初始化内存盘的,, 我不太懂, 是照抄的
启动引导我看见到说 Arch 在推 [Syslinux](https://wiki.archlinux.org/index.php/Syslinux_\(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87\)) 就不去用 Grub 了,
配置[前面说过的这篇文章](http://sandy.is-programmer.com/posts/36189.html) 修改`/boot/syslinux/syslinux.cfg` 应当的分区
再执行 `syslinux-install_update -iam` 就可以了, 似乎 GNOME3 在这里正常的
完了再添加好用户以及密码, 再 回去 `umount` 和 `reboot` 可以看装好的系统了

没问题的话就是安装 GNOME3. 先[安装 X 和字体按照 Wiki 应该不会有问题](https://wiki.archlinux.org/index.php/Beginners%27_Guide#Install_X)
Nvidia 显卡驱动我用 `nvidia` 这个包直接装上还好也没问题, 安装 `gnome` 也没问题
[按 Wiki 上写的](https://wiki.archlinux.org/index.php/GNOME_\(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87\)#.E5.9C.A8.E6.96.B0.E7.B3.BB.E7.BB.9F.E4.B8.8A.E5.AE.89.E8.A3.85)安装配置好 `~/.xinitrc` 运行 `startx` 测试先没压力的
加上[中文的仓库镜像](https://www.archlinuxcn.org/archlinux-cn-repo-and-mirror/)来安装 `yaourt`, 然后比如[GNOME 扩展](https://extensions.gnome.org/extension/440/workspace-separation-on-dash/)还有其他一些定制
[后边用 `systemctl enable gdm` 就能快速设置桌面的开机启动了](https://wiki.archlinux.org/index.php/Systemd_\(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87\)#.E5.90.AF.E5.8A.A8.E6.A1.8C.E9.9D.A2.E7.8E.AF.E5.A2.83), 比以前方便

到了这里, 我开始遇到问题, [一个是 Arch 开始用 systemd.logind 而不用 ConsoleKit,
因此登录桌面不能手动设置无线](https://groups.google.com/forum/?fromgroups=#!topic/archlinux-cn/uIDl8F8NbqU), 即便 `networkmanaer` 用 `systemd` 已经启动
邮件列表同学指导说用 `netcfg`, 我找到了[清晰的教程](http://ihacklog.com/post/used-netcfg-to-setup-archlinux-network.html), [Wiki 上细节太多了](https://wiki.archlinux.org/index.php/Netcfg_\(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87\)#Wireless_Association_failed.28.E6.97.A0.E7.BA.BF.E7.BD.91.E7.BB.9C.E8.BF.9E.E6.8E.A5.E5.A4.B1.E8.B4.A5.29)
思路就是复制模版新建好配置, 再到 Netcfg 配置选中配置名称, 并用 `systemctl` 启用

另一个是 IBus 在 GNOME3.6 不能用, [中文](https://bbs.archlinuxcn.org/viewtopic.php?id=1277)和[英文的不少在帖子在着急](https://bbs.archlinux.org/search.php?search_id=2056567048)
大概是 [IBus 的 Bug](ttps://bugs.archlinux.org/task/32152), 只能等修复了, 暂时我没有好办法
还有是蓝牙, 图标每次开机都亮着, 我用[把对应内核模块加入黑名单](http://siripong-computer-tips.blogspot.com/2011/10/blacklist-disable-bluetooth-kernel.html)还不行
[又想起来去刷新了一遍映像](https://bbs.archlinux.org/viewtopic.php?id=142202), 还不成, 但在 `lsmod` 和 `systemctl` 都不见了
[mkinitcpio 在 Wiki 上的内容](https://wiki.archlinux.org/index.php/Mkinitcpio_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))不是很理解, 总之没有能解决掉图标的开启状态

之后大概 nginx 和 sshd 都用通过 `systemctl` 来启动和停止了, 不太习惯的感觉
另外还有些桌面美化的事情, 觉得难度也比较高, 不过对系统使用的影响不太大
个人感觉 Arch 安装在熟悉之后可以挺方便的, 但配置文件实在太多, 对新手不友好

完了发现有 Chrome 打开多个页面的会卡死 OS 的问题, 看下[这篇](http://kodango.me/install-archlinux-with-vbox)
怀疑是 `genfstab` 时没有先 `swapon` 的缘故, 我手写分区表, 不清楚是否全解决
进展我应该会在 [arch 中文论坛](https://bbs.archlinuxcn.org/viewtopic.php?id=1315)上更新状态的