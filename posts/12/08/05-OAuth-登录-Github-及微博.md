
OAuth 登录 Github 以及 weibo
------

早就想学微博登录做应用, 努力多次, 现在终于把代码过了一遍
像我抱怨的, 如果有清晰的 demo, 几个小时就能梳一遍, 不用我这样半个月
我属打渔晒网之流, 又只能独自摸索, 结果迷路的次数可想而知
按现在的速度, coffee 论坛怕要泡汤, 现在也要先搁一下

代码在 GitCafe 上, 乱了, 难以梳理, 这里不期待能理一遍了
http://gitcafe.com/jiyinyiyong/oauth-code/
另外重要的是账户上关于跨域的网址设置, weibo 尤多, 不要遗漏
我是按照从网页获取 access_token 的思路搜资料的, 不同于客户端

### 流程

OAuth 的认证过程在 weibo 的 API 文档里有清晰的配图
http://open.weibo.com/wiki/Oauth2/authorize
具体到网页, 先发起请求 A 到目标网站的页面下登录, 如新浪的授权页
授权页登录之后从 B 过程能得到一个 token, 是在 URL 里的
URL 的数据拿过来再发起请求 C, 凭着 `token` 能通过 D 过程换到一个 `access_token`
再之后, 只要向正确的 URL 发起 HTTP 请求, 附带可行的参数时即可获取数据
`access_token` 就是这里最首要的数据, 通常以参数形式追加在 URL 发起请求
原先需要用户帐号才能请求的数据, 通过 `access_token` 即可请求到
`access_token` 是要用户授权的, 但不含密码, 因而保证了安全性

### 认证步骤

之前别忘注册应用获取访问 API 所需的 `client_id` 和 `client_secret`
上面这些, 是从这篇文章理出来的 http://ikeepu.com/bar/10430988
认证的过程, 首先打开授权页很简单, 因为只要用 `open()` 打开固定的 URL 即可
注意这个 URL 参数中有 `client_id` 表明用户身份, 写上即可

登录授权的操作之后, 网页会被重定向, 重定向大致是在 HTTP Header 完成的
即是说, 重定向步骤由服务器完成, 重定向后的网址参数里带有 `token`
虽然 `location` 很好获取, 但要传给另一个网页, 手法就不好想了
这里用了跨标签的通信, 通过 `postMessage()` 向 `opener` 发送 URL 的字符数据
原来的网页, 也就是 `opener` 写好事件监听函数, 用来捕获数据. 具体见代码

`token` 换 `access_token` 这步需要从服务器发 HTTP 请求, 而不能直接从浏览器请求
这一步还要用加上 `client_secret` 参数, 在创建应用的信息里有的
我很不解为什么要有中间的 `token` 步骤, 而不是一步直接获得 `access_token` 呢?
资料上的提示, 安全考虑.. 还是再看吧
浏览器服务器交换数据, 我用 `socket.io` 解决了, 见 GitCafe 上代码

### 请求数据

关于 API 数据的请求我只是做了简单的测试, 用 `request` 模块和 jQuery 完成
最开始我用 Node 的 Stream API 写了, 发现我不太会, 出错好多次
HTTP 请求是古怪的字符串, 本来 API 就应该有良好的包装才是
`request` 与 jQuery 的级联写法有差别, 还是 Node 那类回调
https://github.com/mikeal/request/

Github 的 API 文档难以看懂, 我勉强对着 curl 命令找到了用户数据的 curl 命令
测试时用 curl 尝试 API 是否正确比代码里写更好, 也不会有浏览器的跨域问题(推测)
以后得仔细看下那的文档.. 标记得太抽象了..
浏览器端的请求在获取 Github 用户数据时没遇到大的问题, 注意写法和 URL 就好了

在微博时有跨域的粗无, 我找了很久, 差点怀疑浏览器无法请求数据, 最后还是可以的
网上的办法是用 jQuery 中 jsonp 的写法避开了跨域的限制, 但代码是简单的
http://liangge0218.iteye.com/blog/1537197
http://pldream.com/b/?post=72

### ...

我用了服务器上的 Nginx 来调试, 大概避免了不少麻烦
HTTP 是 20 年前创建的规范了, 当时没有 JSON, 连 JS 都不存在
尽管几经修订, 最后还是等 SPDY 和 WebSocket 之类技术来演进 Web
`socket.io` 互传 JSON 对比在 URL 上绑参数, 友好程度的差别可想而知
如果只是传输 JSON, 接口能相当地简化. 其次是安全方面的问题
想想背后真有多少历史因素呢.. 希望 Node 赶快普及吧, 观念上带来改变
