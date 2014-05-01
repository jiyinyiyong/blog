
Android 远程调试 Chrome
======

我买的是小米 1S, 第一只触屏手机, 图廉价和省事, 问题似乎不大
开发 Android 的室友让我感到拿不到手机 root 压力很大
于是开始学刷机, 距离我买手机 3 个多月, 我还是义务所知
和同事打听加网上搜索和本地安装, 终于搞定了无线调试

这里记录一下我了解到的和刷机过程的操作步骤:

CM 的 OS
------

大致了解, CM 是 Android 的非官方的 ROM, 一直在更新
全名 Cyanogenmod, 官网在 http://www.cyanogenmod.org/
Github 上有这个组织: https://github.com/CyanogenMod/android
小米是基于 CM 改的, 不过在 CM 官方 Wiki 里支持的设备中没有写小米

Google 了许久之后我找到了个 ROM, 后来大致验证是可行的
http://forum.xda-developers.com/showthread.php?t=2067070

刷机过程
------

网上教程很容易搜到, 做一遍就懂了. 关机状态电源键及音量增进入 Recovery
再按照提示清除 User 数据和 Cache, 另一个选项 All Data 不一定要
All Data 不选, 那么刷机后原先安装的应用还在, 可能不好用了

关机前事先要把 ROM 文件放到 SD 卡根目录命名为 `update.zip`
清理后, 选择安装 `update.zip` 到系统 1, 等待完成然后重启即可
文件可以拷贝, 也可开启 Android 的调试功能用 `adb` 安装:
`adb push ./cm-10.1-20130613-BETA1-mione_plus.zip /sdcard/update.zip`
过程有点长, 我遇到过文件拷贝不全, 只能耐心等待
刷机结束后重启, 初次开机有 CM 转圈圈的动画, 时间较长

Google 应用问题
------

安装完后, Google 的应用都无法正常使用了, FC 之类的
室友提到 CM 和 Google 的纠纷, 至于无法在上边使用 Google 应用
当然社区有很多办法, 比如一些取名 `gapps-*` 的应用, 不过我没成功

之后听从提示, 安装了小米的开发版, 通过小米应用商店中某应用安装 Google 应用
http://www.miui.com/development.html
再之后, 发现 Google 应用耗电和退出等问题奇怪, 不想折腾了

再次刷机
------

今天在小米论坛搜索到了方案, CM 和 Google Play 都安装成功了
http://www.miui.com/thread-1261525-1-2.html
http://bbs.xiaomi.cn/forum.php?mod=viewthread&tid=7668654
具体内容在链接里有详细说明, 不打算重复

调试工具
------

Android 的调试工具在 Ubuntu 的 mirror 中有, 直接可以安装
Android 上开启调试选项, 包括 Chrome 调试选项, 就打开工具了
注意到有个网络调试功能, 而在小米开发版上没有看到
此外 CM 上 root 权限可以分配给 adb, 而小米上没有得到

网络调试我参考了以下的链接, 在局域网里开启了调试功能
http://geekyogi.tumblr.com/post/24456172929/android-debugging-adb-over-network
http://stackoverflow.com/questions/2604727/how-can-i-connect-to-android-with-adb-over-tcp
首先在 Android 上开启提示运行之后, 到 Ubuntu 上运行 adb:
```
adb connect 192.168.1.200:5555
```
很快连接成功, `adb shell` 有反应, 并且能进行 Vim 操作

我主要关心 Chrome 调试, 按照 Chrome 远程调试文档:
https://developers.google.com/chrome-developer-tools/docs/remote-debugging
在 Android 打开远程调试选项, Ubuntu 上输入命令:
```
adb forward tcp:9222 localabstract:chrome_devtools_remote
```
Ubuntu 上 Chrome 打开 `locahost:9222` 就看到对应界面了
有点问题是, 远程调试的文件似乎放在 appspot 上, 网络请求很慢, 用点技俩才打开
https://chrome-devtools-frontend.appspot.com/
总之到此为止, 从 Ubuntu Chrome 无线调试 Android Chrome 是可行了

`adb shell` No permisson 问题
------

刚开始频繁遇到 `adb shell` 提示权限不足的问题, 搜到了方案:
http://stackoverflow.com/questions/16364748/must-do-adb-kill-server-and-start-server-everytime-to-recognize-android-device-i
需要手动关闭 adb 工具, 再以 root 权限运行, 即可:
```
adb kill-server
sudo adb start-server
```
