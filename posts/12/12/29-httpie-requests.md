
## 结合 httpie 和 express 演示 HTTP 请求

HTTP 我话了好久才懂, 后来就想, 如果有工具简洁显示出来多好
简单的直接在 Chrome 里可以查看, 但为了方便, 需要有命令行
一个不错的选择是 `curl`, 可我为了好看, 找了个 httpie
https://github.com/jkbr/httpie
使用 Python 写的, 参数比较友好, 是否强大我就没往深了看
Arch 上安装时候换了几个版本才安装上, 报错有在论坛提问:
https://bbs.archlinuxcn.org/viewtopic.php?id=1441

测试我是从 Ubuntu 上安装发送请求的, Arch 上的 express 代码:

```coffee
express = require "express"
prettyjson = require "prettyjson"

app = express()
color = (json) ->
  console.log ""
  console.log (prettyjson.render json, keysColor: "cyan", stringColor: "yellow")

app.use express.bodyParser()

app.post "/", (req, res) ->
  color req.headers
  color req.body
  res.end "end..."

app.listen 8000
```

然后用命令行测试, 在两边的终端都打印出来 Header 和 Body:
```bash
http POST localhost:8000 hello=world
```

POST 请求原先我一位只是发一段字符串数据的, 结果几乎是 URL 参数
我认为是 HTTP 请求制定时明显没好绿好未来的应用
其实真实的使用当中, Socket.IO 模式发送的 JSON 更为灵活
而 URL 形式涉及到字符串转义之类的问题, 多出烦恼
我可能要查询一下规范来确认一下我的猜测是否正确..

httpie 自带颜色高亮, Node 就要用插件了
prettyjson 符合要求, 但字符串颜色并不好看, 我勉强才 Fork 了
https://github.com/jiyinyiyong/prettyjson

Web 平台有点像暴露给 JS 的各种底层麻烦的信息
这些信息对写前端的人们来说是个麻烦, 包括 HTML 我也比较怀疑
只有到了语言同一个环境, 而不基于字符串, 那才算是一个好的环境
当我们能在所有操作使用同一套数据结构的规范时, 编程才能轻松
