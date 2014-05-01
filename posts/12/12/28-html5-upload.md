
## 尝试上传文件

我从一开始接触的就是 Socket.IO , 而不是 HTTP 主体的协议
我最初尝试的就是用 Socket.IO 传输 FileReader 读取的文件字符串
当时也勉强成功了, 但是没有上传进度的提示, 也不怎么好
https://github.com/jiyinyiyong/song-box/blob/b8ad90ac103aaee372a3c51f33a931a7f8f3365f/src/handle.coffee#L25
后来在 CNode 看到有人自己拆开数据增加一层提示, 我没有尝试

昨天尝试了一下用 XMLHttpRequest 直接传送文件字符串, 失败了
最开始有个我跨域的问题, 因为静态文件用 Nginx 跑的, 上传服务器是 Node
Express 的解决方案是用路由在请求处理路由之前允许跨域
http://stackoverflow.com/questions/7067966/how-to-allow-cors-in-express-nodejs

```coffee
express = require "express"
app = express()
log = console.log

app.use express.bodyParser()

allow = (req, res, next) ->
  res.header 'Access-Control-Allow-Origin', "*"
  res.header 'Access-Control-Allow-Methods', 'GET,PUT,POST,OPTIONS'
  res.header 'Access-Control-Allow-Headers', 'Content-Type'
  next()

app.configure ->
  app.use allow
  app.use express.bodyParser()
  app.use app.router

app.options "/upload", (req, res) ->
  log req.body
  res.send()

app.post "/upload", (req, res) ->
  log "event"
  log req.body
  res.send "end"

app.listen 3010
```

这时注意到多了一个 `OPTIONS` 请求, 起初不明白
后来看到是 CORS 跨域请求协议里的, 先用该请求查询是否有跨域的权限
就是查看返回的请求的头部是否声明了对应的跨域

然后遇到的问题是上传的整个字符串不能在 POST 请求中被显示
我于是做了另外的尝试, 用 FormData 试试看直接上传文件
http://stackoverflow.com/questions/3315429/xhr-sendfile-doesnt-post-it-as-multipart

```coffee
var formData = new FormData();
formData.append(file.name, file);

var xhr = new XMLHttpRequest();
xhr.open('POST', '/upload', true);
xhr.onload = function(e) { ... };

xhr.send(formData);  // multipart/form-data
```

中间 `http://` 字母写错遇到的报错说跨域请求只支持 HTTP..
解决后按搜索结果找到 `connect-form` 插件来管理 FormData 上传的文件
结果模块找不到 `./index.js` 文件, repo 上正常却是两年前的
Node 发展至于么.. 也是 TJ 的模块, 怀疑 Express 升级是替换了
恰好翻到一个 API 看到 `req.files`, 于是找到了出路
http://howtonode.org/really-simple-file-uploads
http://expressjs.com/api.html#req.files
按打印对象, 文件已经在 `tmp` 下缓存, 等待进一步的操作
那么用 `fs` 模块处理一下就能操作成功存放文件了

```coffee
app.post "/upload", (req, res) ->
  log "event"
  for key, value of req.files
    fs.readFile value.path, (err, content) ->
      fs.writeFile "#{__dirname}/files/#{key}", content, (err) ->
  res.send "end"
```

然后上传的部分, 翻来覆去确认 API 是 `xhr.upload.onprogress`
于是上传进度也能查看了, 具体的代码是这样的

```
window.onload = ->
  input = q "input"
  input.addEventListener "change", (file) ->
    item = file.target.files[0]
    formData = new FormData
    formData.append item.name, item
    xhr = new XMLHttpRequest
    xhr.open "POST", "http://192.168.1.19:3010/upload"
    xhr.onload = (e) -> log e
    xhr.upload.onprogress = (step) ->
      log step
      log (step.loaded / step.total)
    xhr.send formData
```

全部代码备份到了 GitCafe
https://gitcafe.com/jiyinyiyong/upload-center
https://gitcafe.com/jiyinyiyong/upload-center
