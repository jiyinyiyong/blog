
@ 装 Ubuntu 用的一些链接和文本

重装的次数很多, 还是不长记性. 特地到此留下笔记
我现在都是 Ubuntu 了, 没有 Linux 的 Shell 非常不耐, 其他发行版又不惯
照说 Mint 会是 Ubuntu 以外很好的选择, 碍于习惯, 我没试过
iso 到镜像去下, 速度很快, 不断网的话很快就能下载好的
http://mirrors.163.com/ubuntu-releases/

首先 `sudo visodu` 在最后加上这样一行避免重复输入密码

```
chen ALL=(ALL) NOPASSWD: ALL
```

然后从 PPA 安装 Node
https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager

```bash
sudo apt-add-repository ppa:chris-lea/node.js
sudo aptitude update
sudo aptitude install nodejs npm
```

对应在 `~/.bashrc` 有相关的配置:

```
export NODE_PATH="/usr/lib/node_modules/"
```

设置 npm 镜像位置:

```bash
npm config set registry http://registry.npmjs.vitecho.com
sudo npm install -g coffee-script
sudo npm install -g jade
sudo npm install -g stylus
sudo npm install -g node-dev
```

http://www.v2ex.com/t/15093

安装 `autojump`, 需要 git

```
git clone git://github.com/joelthelion/autojump.git
```

注意在 `~/.bashrc` 添加相应的代码, 此外有个镜像:
https://gist.github.com/2688675

Sublime 的 PPA 是这样的:

```
sudo add-apt-repository ppa:webupd8team/sublime-text-2
sudo aptitude install sublime-text-dev
```

包管理的安装脚本在这里:
http://wbond.net/sublime_packages/package_control/installation

```python
import urllib2,os; pf='Package Control.sublime-package'; ipp=sublime.installed_packages_path(); os.makedirs(ipp) if not os.path.exists(ipp) else None; urllib2.install_opener(urllib2.build_opener(urllib2.ProxyHandler())); open(os.path.join(ipp,pf),'wb').write(urllib2.urlopen('http://sublime.wbond.net/'+pf.replace(' ','%20')).read()); print 'Please restart Sublime Text to finish installation'
```

配置 `User Settings` 为:

```json
{
  "font_face": "wenquanyi micro hei mono",
  "font_size": 10.0,
  "tab_size": 2,
  "translate_tabs_to_spaces": true
}
```

修改窗口最大化时隐藏标题栏的位置为:

```
sudo vim /usr/share/themes/Ambiance/metacity-1/metacity-theme-1.xml
```

具体可参照设置相应代码到 0:
http://www.webupd8.org/2011/05/how-to-remove-maximized-windows.html

```xml
<frame_geometry name="geometry_maximized" has_title="false" rounded_top_left="false" rounded_top_right="false" rounded_bottom_left="false" rounded_bottom_right="false">
  <distance name="left_width" value="0"/>
  <distance name="right_width" value="0"/>
  <distance name="bottom_height" value="0"/>
  <distance name="left_titlebar_edge" value="0"/>
  <distance name="right_titlebar_edge" value="0"/>
  <distance name="button_width" value="0"/>
  <distance name="button_height" value="0"/>
  <distance name="title_vertical_pad" value="0"/>
  <border name="title_border" left="0" right="0" top="0" bottom="0"/>
  <border name="button_border" left="0" right="0" top="0" bottom="0"/>
</frame_geometry>
```

虽然不一定用 gnome-shell , 但可以先把扩展装上:
https://extensions.gnome.org/extension/82/cpu-temperature-indicator/
https://extensions.gnome.org/extension/235/desktop-scroller-left-and-overview-version/
https://extensions.gnome.org/extension/119/disable-window-animations/
https://extensions.gnome.org/extension/275/edge-flipping/
https://extensions.gnome.org/extension/12/static-workspaces/
https://extensions.gnome.org/extension/104/netspeed/
https://extensions.gnome.org/extension/208/panel-settings/
https://extensions.gnome.org/extension/106/remove-user-name/
https://extensions.gnome.org/extension/38/windows-alt-tab/
https://extensions.gnome.org/extension/79/hide-dash/

注意设置默认桌面数量的命令是这样的:

```
gsettings set org.gnome.shell.overrides dynamic-workspaces false ;
gsettings set org.gnome.desktop.wm.preferences num-workspaces 6 ;
```

然后边缘翻转的设置等待时间为 0:

```
vim ~/.local/share/gnome-shell/extensions/edge-flipping@aguslr.github.com/extension.js
```

安装扩展大概要用 Firefox 才行, Chrome 不大行

官方源安装 mongodb 注意添加用户和修改 `/etc/mongodb.conf` 添加 `auth=true`

然后两个上外网的工具:
http://code.google.com/p/goagent/
http://code.google.com/p/switchysharp/wiki/SwitchySharp_GFW_List_2

进入 `~/.config/` 目录修改 `dirs` 的名字, 对应主目录的文件名

配置 github ssh key 的命令
https://help.github.com/articles/generating-ssh-keys

```bash
ssh-keygen -t rsa -C "jiyinyiyong@gmail.com"
git config --global user.email 'jiyinyiyong@gmail.com'
git config --global user.name 'jiyinyiyong'
```

在 `/usr/local/bin/` 部署下面两个脚本, 另外还有 `liuxian`
`narkcown`: http://gist.github.com/2626097
`pgup`: https://gist.github.com/2959922

在 `/etc/hosts` 加入访问 Google 英文版的 IP:

```hosts
74.125.71.94 google.com
74.125.71.94 www.google.com
```