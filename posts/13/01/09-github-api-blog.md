
## Github 静态博客用 API 加强

本来想如果 Github Pages 有静态博客的目录 API, 那完全不用服务器了
只要从 JS 发请求获取文件列表, 就能完成内容的渲染, 而不用手动生成目录
就往 Github 反馈了, 收到 @pengwynn 的回信:

> We don't have any plans to offer dynamic features for Pages,
> but you can use [CORS][1] or [JSONP][2] to get the [Content][3] of your repository from the API in the browser.

[1]: http://developer.github.com/v3/#cross-origin-resource-sharing
[2]: http://developer.github.com/v3/#json-p-callbacks
[3]: http://developer.github.com/v3/repos/contents/#get-contents

我的博客能直接通过 GET 请求得到 JSON 格式的目录:
https://api.github.com/repos/jiyinyiyong/blog2/contents/
并且用 JS 改写 HTTP 请求头部的 API 也是存在的:
```js
xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded")
```
http://www.w3schools.com/ajax/ajax_xmlhttprequest_send.asp

大概看了不难, 只是本地开发或者预览时要有个 API 服务器才行
比我想得要好多了, 这星期要试试看. 顺便看下其他的 API
此外想想专心的话, 我对博客的需求会比现在大一些,, 需要前端的技能更高
