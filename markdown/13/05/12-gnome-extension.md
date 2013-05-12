
关于 GNOME3 插件开发的想法
------

GNOME3 以前 [Tualatrix 那片将其称为黑客桌面的博客][intro]开始, 我一直关注
这么多年过去了, 我也成了 GNOME3 的重度用户, 每天工作生活的桌面都是
过去的几年, 我也成了 JS 社区强度的水民和已经入门级别的开发者
我熟悉了 Node, 花费大量时间调试 Chrome 上的 JS, 也积累了不少经验
Chrome 插件虽然浅也算做了尝试, 模块化问题不好解决, 我也没心思在上边
但是, GNOME3 的 JS 至今我没能写出一个 Demo, 来操纵窗口

[intro]: http://imtx.me/archives/1448.html

前些天看到 [Workspace Grid][grid] 作者 [mathematical.coffee][author] 页面, 就想到发邮件询问下
发完邮件发现作者 Blog 里写了好多关于 Linux 和 GNOME3 的文章可以拜读
惊喜的是后来作者回复了老长的邮件, 我感激得都恨自己没学会看 C 代码了
征得对方同意, 贴了回复在这里. 这是作者的 [Github profile][github]

[grid]: https://extensions.gnome.org/extension/484/workspace-grid/
[author]: https://extensions.gnome.org/accounts/profile/mathematical.coffee
[blog]: http://mathematicalcoffee.blogspot.com.au/
[github]: https://github.com/mathematicalcoffee

------

hi,

the API is very poorly documented, and unfortunately it changes drastically(彻底地) between GNOME releases. For example, very soon I'm not going to bother updating my extensions to newer versions of GNOME because they change it too much in between releases and I have no time to work out the changes. Unfortunately workspace grid is one of those extensions where the code it relies on has been changed drastically in GNOME 3.8 so I'm not sure I can update it.

With respect to the "API", the best bet is to read through the source code (`/usr/share/gnome-shell/js`). Most the code that extensions play with is in the `ui` subfolder.

The source code is very very large, and I recommend just reading through the bits that are relevant to what you want your extension to do (to start with). For example, `panel.js` handles the top panel.

The other advice I have for starting with extensions is reading the code of other extensions, particularly if they do something similar to what you want to do. For example, if you want to write an extension that does something with the top panel, look at the code of other extensions that do things to the top panel.

Another component to writing extensions is that lots of them (and gnome-shell's JS code) uses gobject introspection repositories.
These are the lines up the top of the code that look like:

```js
const Meta = imports.gi.Meta;
const XYZ = imports.gi.XYZ;
```

These are basically libraries of extra functionality. For example, `imports.gi.Meta` gives you access to lots of metacity/window management functionality.

For these there is often documentation on http://developers.gnome.org .
For example https://developer.gnome.org/shell/unstable/index.html for `imports.gi.Shell` (various miscellaneous utilities) or https://developer.gnome.org/st/stable/ for `imports.gi.St` (most graphical elements are drawn using this). Go to http://developer.gnome.org for a list of API documentation.

Unfortunately the gnome-shell code itself is not documented like the above.
The best attempts I've seen so far are a few posts:

* https://live.gnome.org/GnomeShell/Extensions/StepByStepTutorial#knowingGnomeShell-API
  this explains how various classes/javascript files interact with each other and what behaviour each controls
* http://mathematicalcoffee.blogspot.com.au/2012/09/gnome-shell-javascript-source.html (disclaimer: I wrote this) which summarises some of the files and classes available from gnome-shell (NOTE: it was written for GNOME 3.2 and 3.4, and much of GNOME's code has changed since then so not all of it is relevant any more).
* as mentioned before, reading other extensions' code can be very helpful.

Also the gnome-shell mailing list is extremely helpful for asking specific questions, and you can also search through the archives and often find help on particular topics.
https://mail.gnome.org/mailman/listinfo/gnome-shell-list

Finally the IRC channel is also a good place to ask for quick help. https://live.gnome.org/GnomeIrcChannels (irc.gnome.org, #gnome-shell)

Anyhow I hope I have not discouraged you too much. In summary:

* it's really hard to get started because of the lack of documentation for gnome-shell
* there are plenty of people who will offer advice and help on the mailing list and IRC
* reading code of other extensions can be really helpful

cheers,
Amy

-------

小部分 Markdown 标记和中文部分是我加的, 来满足我博客的格式
可惜最近没有精力能花在上边, 只能把资源整理出来继续跟进
关于 IRC 和邮件列表, 非英文母语的我对于参与仍有疑问, 以后再说

### 关于我想做的插件

已经想到一些插件的想法, 临时记录在这里, 希望以后 API 文档一定能做出来

* Compiz 风格的 `n ^ 2` 桌面布局, 方便拖放窗口和切换

* 模仿 Sublime Text 的 Goto Anything 功能, 做窗口的搜索
搜索结果和应用的搜索结果混杂在一起或者左右分开, 作为列表

* 保存桌面布局为函数, 通过快捷键或者其他方案调用

* 模仿 Sublime Text 的 Command palette 搜索命令进行使用
用一个文本接口, 调用文本编辑器编辑好的脚本, 完成强大的功能

* 隐藏 GNOME3 窗口边框, 用命令行的方式完成窗口布局

