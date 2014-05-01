
doodle 命令行工具刷新页面
------

调试 html 需要多次刷新页面, 自然而然想到用工具自动刷新
此前遇到过的方法有 `live-reload` 通过浏览器插件和 python 自动刷新
https://github.com/lepture/python-livereload
当然, 其他环境的工具也是有的, 即便 Node 也是有的
http://livereload.com/
https://github.com/josh/node-livereload
用来 Chrome 扩展的话就不用 JS 环境里增加代码了, 相当不错
不过那对我而言比较复杂, 于是发贴, 最后想想自己写一遍看看
http://cnodejs.org/topic/502f91f0f767cc9a51809334

### 失败的 SSE 的尝试

为了减少对其他模块的依赖, 我没有使用 watch 模块, 开始也不打算算 ws
前些天看到 SSE 可以从服务器向浏览器发送事件, 就找了 Node 的 demo
http://www.html5rocks.com/en/tutorials/eventsource/basics/
关于 SSE 主要的代码是这样的, 还是很普通 http 响应结果:

```js
function sendSSE(req, res) {
  res.writeHead(200, {
    'Content-Type': 'text/event-stream',
    'Cache-Control': 'no-cache',
    'Connection': 'keep-alive'
  });

  var id = (new Date()).toLocaleTimeString();

  // Sends a SSE every 5 seconds on a single connection.
  setInterval(function() {
    constructSSE(res, id, (new Date()).toLocaleTimeString());
  }, 5000);

  constructSSE(res, id, (new Date()).toLocaleTimeString());
}

function constructSSE(res, id, data) {
  res.write('id: ' + id + '\n');
  res.write("data: " + data + '\n\n');
}
```

我调试最后注意到 `\n\n` 在事件的产生当中是必不可少的
而 `data:X\n\n` 则让事件的 `data` 属性赋值为 `X`
此外, SSE 会产生其实每 2~4min 时间开发工具的网络中可以看到重新链接
当然这不影响功能, 后来却发现 SSE 不能跨域, 下面的报错:
`SECURITY_ERR: DOM Exception 18`
在网页的评论上也提到了, 似乎没有搜到好的办法
当时我实现的代码大致是这样的:
https://github.com/jiyinyiyong/doodle/blob/dc92d7b410264591018458cb0794c86d0f618dac/src/doodle-server.coffee#L12

### 基于 `ws` 的版本

后面就用 ws 模块重新写过了, 而且 websocket 是允许跨域的
不过 ws 服务端和浏览器端接口不同, 折腾了好久
https://github.com/einaros/ws
http://www.tutorialspoint.com/html5/html5_websocket.htm
最后完成的代码我放到了 github 和 npm 上, 参考:
https://github.com/jiyinyiyong/doodle/tree/
http://www.elmerzhang.com/2011/09/nodejs-module-develop-publish/
这样 `doodle` 命令用来监视一个或多个文件或文件夹

然后 html 当中导入一行 js 即可, 还是能接受的范围
或者也可以自定义刷新部分的代码, 而不用 `doodle` 中包含的代码
为跨机器使用, 浏览器端代码加了 `location.hostname` 来展示
此外考虑到脚本编译命令会带来多次连续的保存事件,
比如 `jade` 有 `.jade` 和 `.html` 两次事件, 后者可能因刷新而失效
那么我在发送刷新时有一个 100ms 的延迟, 暂时没有大问题

### 目前的想法

蹭办公室的电脑的话就有两台, 个人不喜欢一台电脑两个屏幕的
于是我在以前电脑上访问另一台 Nginx 的静态文件目录
用 IP 直接访问的, 那么 `location.hostname` 指向是正常的
然后就在笔记本编译 html 看另一个屏幕的刷新, 操作上是可行的
我也考虑过弄个经本替代 Nginx 静态目录, 获取更多自由
不过也需要自己写一遍, 暂时 Nginx 的功能完全足够了的
