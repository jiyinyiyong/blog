
## 关于网页编写的习惯

从暑假回校写了 [Doodle][doodle] 命令开始, 我慢慢形成了编写网页的习惯
得益于 Node 平台针对 Web 方便的工具, 搭配页面对我不再艰难了
对于昨天写的 [Clojure 资源页面][clj-links] 页面, 我记录下我先进所用的方案

[doodle]: https://github.com/jiyinyiyong/doodle
[clj-links]: https://github.com/coffee-js/clojure-learning

首先我会创建一个 `dev.sh` 脚本, 前面来用试探性创建需要的文件
之后是编译的命令, 还有在 `read` 之后关闭编译命令的 Bash 命令

```bash
cd `dirname $0`

mkdir -p src
mkdir -p page

touch src/index.jade
touch src/page.styl
touch src/handle.coffee

jade -O page/ -wP src/*jade &
stylus -o page/ -w src/*styl &
coffee -o page/ -wbc src/*coffee &
doodle page/ &

read

pkill -f jade
pkill -f stylus
pkill -f coffee
pkill -f doodle
```

脚本是 `chmod +x` 可执行脚本, Cake 还有 Make 我还不会用
脚本启动后在 `read` 阻塞, 命令在后台执行, 按下回车后开始 `pkill`
我的目录有 `src/ page/`, 前者是脚本, 后者是编译目标的代码
按照 Doodle 的设计, 需要在 HTML 理由对应的引用, 我写在 Jade 里

```jade
script(src="http://192.168.1.101:7777/doodle.js")
```

其中是我局域网的 IP, 方便打开另一个屏幕直接看效果

Jade 比较漂亮的特性比如 `:markdown` 的过滤器, 可以在页面使用 Markdown
代价是主要 `npm install -g marked` 保证环境里有对应的命令
另一个漂亮的功能是 `mixin`, 有了这, 很长的 Markdown 内容就可以分开了
还有 Disqus 代码在调试过程中我通过 Mixin 关闭, 而不是全部靠注释

完成的页面借助 `gh-pages` 分支直接显示在 Github Pages 上了
