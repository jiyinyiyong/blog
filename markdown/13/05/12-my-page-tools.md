
我的页面调试工具
------

### 缘起

昨天参加 Ruby 沙龙, 紧张不说, 听到@Saito 讲前端开发我最关心的
幻灯片后来在 Ruby 中文帖子里看到了, 大致回顾了下
https://speakerdeck.com/saito/middle-scale-f2e-application
原先演讲时有开发的演示, 项目的例子详细是幻灯片中无法感受到的
印象比较深的是用 Ruby 加 AppleScript 脚本完成了浏览器刷新
另外大量的 Ruby 工具来完成了代码的转换, 相对来说我陌生很多
总之感觉是目不暇接, 对 Ruby 工具链多点感想那样

### 我和 Node

Node 这边相关工具更多, 我长期的习惯是用 JS 去完成这些
可惜我距离独挡一面的开发者距离很远很远, 一些想法都没能付诸行动
看到 Ruby 中文社区走在 Node 中文社区前头有些不甘心吧
也打算整理一下我的, 做一个阶段性的总结, 等以后再写更好的

* Nginx

我的平台是基于 Nginx 和 JSON 的, 前端后端分离
现在是 CORS 的 HTTP 请求, 以后要用 Socket.IO 来交换数据
缺陷是我的开发环境只是小项目的简单代码用用, 稍大的项目尝试都没有
另外后端入门太浅, 前端正在努力追赶, 希望框架开发有一天能加快吧
这些天见识了 Backbone 一些功能是开始佩服了, 希望能学会吧
总之文件放在 Nginx 静态文件服务器就完了, 配置如下:

```nginx
server {
  listen       80;
  server_name  localhost;

  #charset koi8-r;

  #access_log  logs/host.access.log  main;

  location / {
      root   /opt/s/;
      index  off;
      autoindex on;
  }
}
```

* `doodle`

页面自动刷新我用的是 `doodle` 命令, 自己基于 WebSockets 折腾的
https://github.com/jiyinyiyong/doodle
在 Chrome 调试基本的功能是可行的, 用法分前端后端两部分
后端用 `doodle path/` 加入要监听的目录, 以及脚本和 WebSocket 的服务
前端加一个 `<script>` 标签引入脚本, 监听信号完成刷新功能
这样一旦编辑器使用 `ctrl + s` 浏览器端大部分情况就能自动刷新
这种调试在双屏时的好处是我体会到的, 虽然扭头的确不方便

* 目录结构

一般目录结构的设置是这样的, 具体大概不是固定的
因为我用的是 Jade, Stylus, CoffeeScript, 就有编译的问题
于是用 `coffee/` 单独放代码, `layout` 放界面用的 HTML 和 CSS
JS 代码用 Browserify 或者 commonjs-everywhere 来编译, 就有 `lib/` 文件的差别
`server.coffee` 在我写的代码里很少去用, 还没尝试加后端
同时关于测试也没有做到, 仅仅可能放一些基本的测试例子
`dev.coffee` 只是把一些 Bash 脚本用 Node 跑起来, 叫 `calabash`

```
coffee/
  main.coffee
  lib/coffee
layout/
  index.jade
  page.styl

lib/

dev.coffee
build/
  main.js
  main.map
  index.html
  page.css

.gitignore
package.json

server.coffee
test/test.coffee
```

* `calabash`

说 Grunt 是面向这方面的建构和自动化的工具, 本来应该很好的
可是 Grunt 不是对 Node 友好的一个工具, 我原本尝试自己做一个
https://github.com/jiyinyiyong/rain-boots
可 `rain-boots` 觉得具体实现难度好大, 目前还是搁浅的状态
于是写了一个 `calabash` 模块, 仅仅用来管理终端命令

```coffee
require("calabash").do "first parameter as comment",
  "pkill -f doodle"
  "coffee -o lib/ -wbc coffee/"
  "jade -o build/ -wP layout/"
  "style -o build/ -w layout/"
  "node-dev server.coffee"
  "doodle build/"
```

文件完全是用 coffee 的语法糖简化脚本的
用 `node-dev dev.coffee &` 启动和自动加载

* Browserify 和 commonjs-everywhere

兼容 CommonJS 语法将模块打包的方案大概都有着问题
RubyMotion 大概也遇到类似, `require` 机制并不是完全的和 CommonJS 一致
我理解这些工具检测的是字符串, 而不是在运行时中找到模块
这样某些模块的支持就存在缺陷, 加上兼容前端模块少也就成问题了
我在 Github 遇到 Zepto 完全认为兼容这不必要, 我伤心啊

Component 我还得再看一下, 也许机制上有在改善
一个是 SourceMap 的进展, 还有是 Component 模块实在更多
Web 很大很大一块就是前端的 JS, 相信 TJ 是在这样努力
但 Component 方案和 CommonJS 存在着差别, 我很是不放下心

commonjs-everywhere 的监视编译命令是这样的:

```bash
cjsify -o build/build.js -w coffee/main.coffee -s build/build.map
```

而 Browserify 对 coffee 和文件监视都相对不友好

```bash
browserify -o build/build.js -d lib/main.js # 没有测试
```

我想说没有十全十美的方案, 现在还是挺烦人的

### 关心的问题

简单的项目来说, 这个脚手架我用得已经感觉不错了
可要像 Node 那样顺手, 还要需要整个社区一起努力做出来
我到底是 Node/CoffeeScript 忠实的用户...
前端的开发者对于 Node 的熟悉程度, 我真的不觉得国内有多么乐观
我在学校事情完以后要努力花时间在上边, 以便更熟悉开发
而且先我的视野渐渐也更清晰一些了, 希望有个好结局
