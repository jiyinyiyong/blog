
Chromebook 折腾简记
------

调试 Retina 网页的时候, [Firefox 上模拟 Retina 调试失败][firefox]
XCode [安装 quartz 模拟 Retina 屏幕][quartz]也失败了
用到了老板的 Chromebook, 本来希望能调一下的, 结果不能直接改 hosts..
Chromebook [安装 xface][xface] 版本想绕过改 hosts 的方案, 也失败了
当时没有具体做记录, 这里大概留几个链接, 有人折腾的话思路稍微顺一点

[firefox]: http://stackoverflow.com/a/17228046/883571
[quartz]: http://make.wordpress.org/ui/2012/08/01/dev-for-hidpi-without-retina-mbp/
[xface]: http://lifehacker.com/how-to-install-linux-on-a-chromebook-and-unlock-its-ful-509039343

### Developer Mode

我弄的本子是 Chromebook Pixel, 早期的本子看资料说有硬件开关的, 这里去掉了
步骤在 [Chromebook 的 Wiki][dev-mode] 有详细写, 另外有个 [Acer 笔记本][video] 的视频演示
主要是 `Esc Release` 两个键按住一直不放, 这时按电源键系统会进入开机选项
后面等出现提示, 松开 `Esc Release` 的组合键, `Ctrl d` 激活开发者模式

激活后好像是过一段时间(记不清, 可能有提示操作)重启, 就能进入开发者模式了
第一次进入开发者模式会有个清除数据的步骤, 做好 5 分钟的心理准备吧..
开发者模式下开机时会有半分多钟的等待时间, 还有两次鸣声, 我没弄懂为什么
开机等待的时间里有提示说按下 Space 可以重新回到普通状态, 大概不要乱按免得不小心回去

[dev-mode]: http://www.chromium.org/chromium-os/developer-information-for-chrome-os-devices/chromebook-pixel#TOC-Entering-Developer-Mode
[video]: https://www.youtube.com/watch?v=hoXunFVAb08

### Shell

Chromebook 里 `Ctrl Alt t` 会打开一个终端 `crosh`, 一般什么都没有
但是开发者模式下命令会多出来, 主要是 `shell` 命令, 可以激活终端
终端激活以后其实没密码, 默认用户名是 `chronos`, 输入 `sudo su` 可切换到 `root`
常用的 `ls/cd` 是必需的, 而且文件整个基本上都随意走随意看
默认的用户路径有点怪, `cd` 无参数时是到 `/home/` 下一个二级目录...

注意的是这个环境没有 `apt-get` 之类的包管理工具, 没有一些常用软件
`ssh` 倒是有, 但本机 `sshd` 起不来, 不能从外面连接机器的样子
有 Vim, 但没有 `ifconfig`, 其他命令具体没看, 总之是有点少

还有, 即便 `root` 权限, 修改 `/etc/hosts` 也是不可能的, 显示 `readonly`
具体内容[网上有说, 在放弃自动更新功能的情况下还是可以设置成编辑的][hosts]
但我怕弄坏, Chromebook 比 Air 都贵很多, 不敢乱折腾了
想来如果准备好能从 U 盘重新安装 Chrome OS 的话这个问题是不大的

[hosts]: http://superuser.com/questions/595267/hosts-file-for-chromebook

### Ubuntu xface

[Life Hacker 上也有一份 Chromebook 安装 Ubuntu 的方案][xface], 照着执行命令就好
只是国内下载软件, 一个是 Ubuntu 基础软件都会下载一遍, 加上网速, 准备一个小时吧
装上以后, 两个系统似乎共用内核, 几乎就是无缝的切换, 只是容易发热...
注意的是我尝试了 `/etc/hosts` 修改, 结果 Ubuntu 里不起作用
另外这个桌面是 xface, 我安装了 GNOME 弄不明白怎么切换桌面, 因为没有登录界面
终端的话, 从 crosh 直接可以 `enter-chroot` 到 Ubuntu 比较快

那个在 Chromebook 安装 Ubuntu 的项目是 [crouton, 在 Github 上][github]
Issues 里有讨论其他桌面的问题, 但我没看到细, 也许已经有了吧
进去 xface 桌面的分辨率是很大的, [crouton Wiki 上给了相应方案课程调整][pixel]
我尝试了里边第一个方案, 只能说部分界面正常了, Chromium 里明显还是不对的

[pixel]: https://github.com/dnschneid/crouton/wiki/Chromebook-Pixel
[github]: https://github.com/dnschneid/crouton

### 结尾

反正看到 Chromebook 觉得是挺惊艳的, 可惜一个太贵, 一个不能写代码
之前有 [Brackets 配合 Chromebook Git 写代码的方案][brackets], 我没工夫折腾
这些东西还是等以后吧,, Chromebook 暂时时不能很方便用在测试上
最后我是把静态 CSS 从网页添加进去测试 Retina, 好地段的感觉..

[brackets]: https://github.com/ryanackley/tailor#git-workflow