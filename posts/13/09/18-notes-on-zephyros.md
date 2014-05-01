
关于 Zephyros 的笔记
======

玩不下去了, 留一些笔记, 接下来几天别话时间在上边了吧
一直有折腾 window manager 的想法, 可桌面环境提供的 API 都不够方便
我不是 C 程序员, 直接和系统 API 打交道事情我做不来, 只能仰仗动态语言的绑定
以前是 GNOME3, 课期望最后, GNOME 文档跟进非常慢, 只能说失望了
前些天看到了 Zephyros, 好奇了半天这个 WM 的工具, 就没搞明白

这两天看到了 [node-zephyros][node] 的 API 绑定, 才想起来要下载模块自己试一试
随着尝试, 加上 Node 提供的 API, 渐渐摸出一点门道来, 至少发现不难
Zephyros 之后有不少同类工具, 在 [FAQ][faq] 里写着的, Mac 上似乎很多
功能类似 Linux 上平铺桌面管理的功能, 似乎这里着重提供 API 供脚本定制

Zephyros 分成 server 和 client, 通过 Unix Socket 或者 TCP Socket 通信
默认是 Unix Socket, 而且 Node 绑定也是在 Unix Socket 下才正常使用
整个 client 就是异步编程的 API, 往 server 发送和接收 JSON 的消息
这个和 X Server 有相似, 所以在 client 端用了异步, Node 算合适吧
node-zephyros 使用了 [when][when] 的 Promise 来封装接口, 我相对不熟悉

client 收发的 JSON 满足 [Zephyros 的协议][protocol], 完成了大概全部的操作
协议是一个数组, 开头是 message id, 其次 receiver id, 后面是指令, 再是参数
message is 是数字或者 UUID, receiver id 类似, 但用 `null` 表示顶层
指令就比较具体了, 比如设置位置, 获取大小, 获取窗口, 判断状态

[node]: https://github.com/danielepolencic/node-zephyros
[protocol]: https://github.com/sdegutis/zephyros/blob/master/Docs/Protocol.md
[faq]: https://github.com/sdegutis/zephyros#frequently-asked-questions
[when]: https://github.com/cujojs/when/blob/master/docs/api.md#api

对我来说, Zephyros 做的还是挺有限的, 主要也只有当前 space 的窗口操作
Zephyros 提供接口能做的主要是:

* 绑定全局的快捷键, 用来触发行为
* 监听全局窗口的事件
* 查找当前聚焦的 window
* 按方向查找某些, 或者全部的 window
* 获取 window 的标题
* 设置 window 位置和宽高
* 改变 window 聚焦的状态, 切换覆盖的行为
* 获取 screen
* 获取 app, 并且关闭或隐藏 app

都是窗口, 没有 space 之间的切换, 或者更复杂的, 这里让我失望了
相对 GNOME3 的 API 连 Overview 都轻松调用, 只是没有任何好的文档

当前 Zephyros 可以用多种语言配置, 比如 JS, CoffeeScript, LiveScript, Node...
好吧, 其实是 [Ruby, Go, Chiecken, Clojure][langs], 目前是这些
Zephyros 自带监视文件 `~/.zephyros.js` 自动更新的功能, 算实用, coffee 也内置
但调试起来, 还是有些麻烦, 只有一个 log window 显示 log, 其他就没了
包括我尝试的 node-zephyros, 出错了也看不出具体问题. 所以有点邪门

[langs]: https://github.com/sdegutis/zephyros#some-languages-you-can-use

其他语言我说不上, [JS 的配置大概是这样的, 比如给 window 宽度 `+10`][sample]:
[sample]: https://github.com/sdegutis/zephyros/blob/master/Docs/JavaScript.md#sample-script

```js
bind("D", ["cmd", "shift"], function() {
  var win = api.focusedWindow()
  frame = win.frame()
  frame.x += 10
  win.setFrame(frame)
})
```

比如 `bind` `api` 是顶层定义好的变量, 是经过定制的脚本.
[node-zephyros 稍微好些, 可以用 Node 整个知识去理解:][usage]
[usage]: https://github.com/danielepolencic/node-zephyros#usage

```js
var Zephyros = require('node-zephyros');

var z = new Zephyros();

z.bind('t', ['Cmd', 'Shift']).clipboardContents().then(function(clipboard){
  console.log("clipboard: ", clipboard);
});
```

每次发送接受的内容会在 log window 显示出来, 至少能看明白这是协议..
先具体配置的样子, 可以看 [Wiki 上给的几个范例][configs], 也许我要自己写个吧
[configs]: https://github.com/sdegutis/zephyros/wiki#other-users-configs
Mac 上切窗口位置还是有些烦, 我尝试了下脚本, 觉得挺好的, 窗口排放非常有用
不过我心里还在想更强的方案, 用命令行管理窗口, 可惜我无法实现出来