
尝试 Brackets 编辑 HTML
======

NetTuts 上有具体的教程, 展示了基本的功能
http://net.tutsplus.com/tutorials/tools-and-tips/a-peek-at-brackets/

Brackets 是通过 Remote Debug 来实现的, 刷新页面非常快
我从前没用过 IDE, 对 Brackets 解析语法和智能提示感到非常意外
此前有看文章说编辑器太多, 需要用远程调试协议来搞, Brackets 搞了
http://kenneth.io/blog/2013/05/21/our-web-development-workflow-is-completely-broken/

Brackets 的仓库目前扩展较少, 但考虑 JS 用户数量应该很快
https://brackets-registry.aboutweb.com/

Trello 上有 Brackets 进度管理方面的内容, 看起来很累..
https://trello.com/b/LCDud1Nd/brackets

现在 Wiki 上文档不少, 但看起来整理还没做很好
https://github.com/adobe/brackets/wiki/_pages
https://github.com/adobe/brackets/wiki/How-to-Use-Brackets

还有视频介绍了一些更为强大的功能:
http://www.youtube.com/watch?v=xAP8CSMEwZ8
http://www.youtube.com/watch?v=-J5LG2bFPMg

Mac 下安装 Brackets, 打开即可使用, 除了启用 Theseus 后 CPU 占用较高
Linux 下打开实时预览的调试失败, 似乎是 Remote Debugging 没有开启
手动重启 Chrome 29.0 dev, 指定开启端口后可是使用
```
google-chrome --remote-debugging-port=9222
```

Brackets 通过 [Theseus 插件来调试 JS][theseus], 记录调用次数和调用栈
包括服务端 JS 的函数调用, 调用的数据和层次都会被记录下来生成树状的图供调试

[theseus]: http://blog.brackets.io/2013/08/28/theseus-javascript-debugger-for-chrome-and-nodejs/

### 其他浏览器

* Firefox

关于 Remote Debugging API, Firefox 也表示会提供全部的支持
五个月前 Mozilla 博客上就演示了通过 Sublime Text 进行 Remote Debugging 的功能
https://hacks.mozilla.org/2013/03/firefox-developer-tools-work-week-wrap-up/

* Sublime WebInspector

Sublime 对应 Firefox 的 Remote Debugging 插件网上没有找到
按博客说 Paul Rouget 博客说的, 仅仅是 Proof of concept 而已
http://paulrouget.com/e/devtoolsnext/
对应 Chrome 的插件之前倒是出风头, 只是相比 Brackets 显得太弱了
http://sokolovstas.github.io/SublimeWebInspector/

WebInspector 在安装时有 2 和 3 的区别, 注意从 Sublime 安装时区分
安装后搜索 `WebInspector`, 或者按 `Command Shift R` 来激活
选择 `Start Debugging`, 然后选择对应已经在 Chrome 打开的网址
之后编辑保存网页就能在 Chrome 看到页面元素的更新了
具体看上边链接里的视频, 分辨率太高我沒看细... 总之不如 Brackets 的 IDE

* Light Table

今天 Light Table 更新了 `0.5.0`, 增加新功能以及优化运行速度
http://www.chris-granger.com/2013/08/22/light-table-050/
文档页面現在看也已经不少了, 只能抽时间去对付了
http://docs.lighttable.com/

### 感想

今天同期看到的 [Web Components Resources](gist) 这份精彩的列表
Web 终于让我三年前期待的模块嵌套走近了现实的开发的
只是对我来说太快了点, 我学东西很慢, 但技术刷新开始之后速度就飞快了

新技术导致 Web 开发页面回到 HTML 作为主角的页面编写上
脚本的功能减弱了, 因为创建新标签就好比后端编程创造一个函数
HTML 的抽象还是觉得挺麻烦, 导致脚本的抽象能力无法释放出来
好在技术总是会往更好的抽象发展下去的, 希望能早点到设计师能上手的程度

[gist]: https://gist.github.com/ebidel/6314025