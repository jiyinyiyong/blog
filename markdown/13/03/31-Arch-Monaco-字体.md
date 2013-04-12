
## 调整 Arch 上的 Monaco 字体

貌似从用 Arch 到现在终于到能接受的程度了, 只是稍微不如 Ubuntu
几次折腾所经历的还是蛮劳神的, 现在有点进展, 于是计划写下来

前期按照 Wiki 和网上的介绍安装各种文泉驿字体是必要的
之后用 `gnome-tweak-tool` 以及 Chrome 调整显示的字体
`*tweak-tool` 中次像素渲染等选项当然是要仔细看一下的

只是我配置过程的步骤具体怎样起作用我并不清楚
因此如果参考我的配置时请留意, 也请知晓的同学指点下

#### Monaco 字体

同学介绍我 Monaco 字体以后, 我慢慢喜欢上了, 特别编程的时候
Arch 上可以通过 `yaourt -S ttf-monaco` 安装
不过这以后有 Bug, 字号过小时会显示为点阵字, 这就很难看了
我在 bbs 求助, 有同学给我一款去掉点阵部分的字体, 用是没问题了
https://bbs.archlinuxcn.org/viewtopic.php?id=1346
`Monaco.ttf` 下载放到 `/usr/share/fonts/TTF/` 下 `fc-cache -fv` 刷新即可

之后发现终端使用 Monaco 之后, 中文显示出现问题
毕竟 Monaco 没有中文字体, 于是又到论坛上求一个解决方案
结果大概是改两个配置文件, 运行字体不存在时 fallback
http://forum.ubuntu.org.cn/viewtopic.php?f=8&t=395844
目录在 `/etc/fonts/conf.d/`, 两个文件我做了备份
https://gist.github.com/jiyinyiyong/4394798

早上我翻文档时发现 Wiki 上其实有讲到禁用点阵字的配置
https://wiki.archlinux.org/index.php/Font_Configuration_(简体中文)
里边提到的 `70-no-bitmaps.conf` 我是有的, 于是 `ln` 一遍
之后移除前面提到的 `Moonaco.ttf`, 从 `yaourt` 安装, 正常了

#### Sublime 字体修复

Sublime 上用 Monospace 看起来要好一些, 用 Monaco 就显得太细了
Google `archlinux forum sublime text font too thin` 找到了
原文我现在只能看 WebCache, 不帖链接, 大概复制一份
在 `~/.fonts.conf` 里写这样的配置来解决

```xml
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
<match target="font">
   <edit name="hinting" mode="assign">
      <bool>true</bool>
   </edit>
</match>

<match target="font">
   <edit name="hintstyle" mode="assign">
         <const>hintslight</const>
    </edit>
</match>

</fontconfig>
```

我照做. 重启 Sublime 果然好多了, 似乎 IBus 候选词也好多了
有遇到过提示, 又把配置移到 `~/.config/fonts.conf` 过去
不过重启后发现又出现问题了, 只好把配置移回去

#### 壁纸

另外壁纸我临时从网上搜, 选了这样一张, 无聊可以点链接看
http://desk.zol.com.cn/bizhi/1113_13482_2.html
我不想桌面是出现具体人物或者符号, 那些吸引注意力的东西
有点调子的色块或者线条就好, 真可惜自己不会画...
