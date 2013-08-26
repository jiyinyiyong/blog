
输入和输出的事件
======

第一次用 [Socket.IO][socketio] 的 `.broadcast` 时惊讶消息没发送成功
好久才发现消息发送到服务器后并没有返回到本地的 socket, 文档写了的
只是为了省事, 加上刚会 jQuery 操作 DOM 做聊天, 就手动重新发送了一次
当时我没有觉得 Socket.IO 的方案有什么好处, 只是作为技术上的方案接受了
那是两年前了, 到今年实习才开始对付浏览器端模版的应用

[socketio]: http://socket.io/

Backbone 有 Model 有 View, 而 Controller 分散在 Router 和 View 里
而我大部分时间在对付 View 相关的代码, 开始明白状态上的麻烦
Model 和 View 之间数据同步在 Backbone 需要手动管理, 复杂且容易出 Bug
特别是前端应用为了交互, 通常避免大范围刷新, 于是 DOM 操作又大量引入
我还不熟练的一个方案是用 SubView 的局部刷新来避免 DOM 操作的状态问题

状态问题只能学新的方案了, 另一个问题显得更清晰一些, 事件出现循环

### Model 和 View 出现循环的事件

Model 和 View 主要通过事件来同步, 而操作 Model 的方法经常写在 View 里
渐渐一个问题重复很多次, **View 和 Model 之间会出现循环的事件触发**
因为我们的应用一方面数据自动保存, 一方面同时两个 View 出现在界面上
一边通过事件轮询捕获数据改变存入 Model, 一方面 Model 事件改变 View
这样就出现了死循环

我直观的想法是, 一个事件应该辨别消息是否是自身发出, 以区别对待
于是我尝试在 Backbone 事件传递加上调用源头的对象, 用来区别
两个 View 更新数据时问题解决了, 然而又出现了网络请求更新数据的场景
我只好给网络请求再考虑一个源头, 每次监听事件做相应的区分
总之不是个好的方案, 问题只是缓解而不是解决

### 模块上的事件循环

这几天写一个选择菜单, 遇到了类似的问题, 事件不区分来源带来问题
`SelectMenu` 有 `select` 事件, 事件是两方面的
一是外部传入事件改变菜单选项, 一是菜单因为点击而改变, 触发事件
当然两者可以取不同的名字来规避, 只是同样的事件名称显得更自然
而我们不会混淆是因为我们可以从调用环境很轻松区分 `select` 指什么
在 JS 里, 方法调用被抽象得很简单, 对调用环境不会做区分

或者我们在外边用 `.trigger`, 在内部直接用方法调用, 也不会混淆
不过当时没想清楚, 就用 `on/emit bind/trigger` 不同的方法做区分了
使用了两个数组了区别地保存两类事件:

```coffee
fn = SelectMenu.prototype

fn.emit = (eventName, data) ->
  if @eventsOutside[eventName]?
    $.each @eventsOutside[eventName], (index, callback) =>
      callback.call @, data

fn.on = (eventName, callback) ->
  if eventName? and (typeof callback) is 'function'
    unless callback in @eventsOutside[eventName]
      this.eventsOutside[eventName].push callback

fn.trigger = (eventName, data) ->
  if @eventsInside[eventName]?
    $.each @eventsInside[eventName], (index, callback) =>
      callback.call self, data

fn.init = ->
  @eventsInside = open: [], close: [], select: []
  @eventsOutside = open: [], close: [], select: []
```

[select-code]: https://github.com/jiyinyiyong/jquery-select/blob/master/js/select.js#L13-L37

### 分离出模块, 面向对象

前些天看了个[关于 Smalltalk 的视频][video], 很早的时间介绍了 Smalltalk
里边讲的主要还是 OOP 这套编程思想的由来, 概念和现在我学的差不多
可以感受到, OOP 是为了维护大型 codebase 更方便而设计的
需求改变以后, 代码的改变尽可能少, 稳定性高, 开发效率提高
通过对象的继承和方法的覆写将大量的代码进行统一和重用
我越是学习, 越是感到 OOP 思想在 Web 应用开发的上带来的效率

[video]: https://www.youtube.com/watch?v=Y7rq6o6UDXc

我想开发效率是这个时代追求的, 无论图形编程, FP, OOP
OOP 我看来有点像将代码注入到作用域当中来实现代码重用
通过 `this` 共享作用域, 让不同的代码在同一作用域交互
也许我们有更灵活的方案能做更多