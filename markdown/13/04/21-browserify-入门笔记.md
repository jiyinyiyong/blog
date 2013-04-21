
Browserify + coffeeify 的前端调试方案
------

文章原在 coffee-js/Languages 的 Issues 里边, 转移过来
https://github.com/coffee-js/languages/issues/5

#### SPM 更新

开头还是留给 [spm2][ann] 发布的广告, 期待能快壮大起来
同时 [CDN][cdn] 也提前放出来, 尽管和 spmjs 源是分开的, 还是觉得挺有意思
我觉得编程就应该更简单, 因此对 CommonJS 语法的喜爱远胜 AMD
SeaJS 的语法不错... 可惜种种原因我个人做玩具首选 Browserify 了
[ann]: http://weibo.com/1748374882/zqaz6pYMG
[cdn]: http://cdn.menkr.com/index.html

#### Browserify

[Browserify][repo] 看这里, 按描述上它是用 Node 自身的模块机制来加载模块的
模块编译成一个比如 `build.js` 文件, 浏览器这样只要一个 JS 文件较好了
和 Component 项目的不同是这里用的 Node 模块, 而不是另外的办法
[repo]: https://github.com/substack/node-browserify

使用时要用 `browserify main.js > bundle.js` 这样的命令进行一次编译
在 `main.js` 里 `require` 的其他文件, 会被自动加载过来, 打包到 `bundle.js` 里
`browserify` 命令有更多的参数, 具体就看 README 的说明了
除了 NPM 上安装的模块, 部分 Node 官方模块按文档有浏览器版本直接可用
注意的是 `watch` 命令在[某个版本移除了, 不知什么时候回来][removed]
[removed]: https://github.com/substack/node-browserify/issues/210

重要的一点是 [SourceMap 支持][support], Component 文档里就没说
Browserify 似乎是一个月前有的 SourceMap 支持, 这以后意义就不同了
加上 `-d` 参数, 生成的 `.js` 脚本就一段 dataURL 形式的 sourceURL 注释
注意开启 Chrome 调试工具的 Enable SourceMap 选项, 然后开始吧

[support]: https://github.com/substack/node-browserify/issues/259

#### coffeeify

Browserify 支持一些[插件][plugin], 可以把其他代码编译到 JS 当中去
对我来说, 主要就是 [coffeeify][coffeeify] 了, 支持 CoffeeScript 的插件
不过现在几个不好, 一个是[模块需要在本地安装才行, 否则会报错]
还有是[需要 `.coffee` 后缀写好, Browerify 才能识别], 而不像 Node 中那样
另外目前[有行号的 bug, 在当前的 coffee `v1.6.2` 版本中会出错][line-number]
不过按链接说的, 其实 bug 已经修复, 手动才 Github 下载模块替换是可以解决的

[plugin]: https://github.com/substack/node-browserify#list-of-source-transforms
[coffeeify]: https://github.com/substack/coffeeify
[local-installation]: https://github.com/substack/node-browserify/issues/367
[line-number]: https://github.com/substack/coffeeify/issues/7
[extname]: https://github.com/substack/coffeeify/issues/1

这样就能在 Chrome 终端直接看 `.coffee` 代码了, 第一次单步调试 coffee :sparkling_heart: 
不太好的是 @substack [大神本人不写 coffee, README 有提到][maintainer]
另外写 coffee 的倒是有 [commonjs-everywhere][everywhere] 作者写出来东西
后者, 上次我尝试了没能玩转, 只好往后更新出来的详细文档了, 期待啊

[maintainer]: https://github.com/substack/coffeeify#maintainers-wanted
[everywhere]: https://github.com/michaelficarra/commonjs-everywhere

#### 我的尝试

我的 [snowflake][snow] 是对此的一个尝试吧, 昨晚调试行号我没调整好的
感觉轻松多... 不过外部模块调用我没尝试, 到时也许有些问题, 再看
另外我的自动编译和浏览器刷新, `browserify` 的 `watch` 参数没好, 绕了点弯子
但以后, 保存代码, 浏览器自动刷新那是必须, 必须把工具做好

[snow]: https://github.com/jiyinyiyong/snowflake

#### asm.js

跑题... ASM 的速度好快, JS 编译都常态啊. 各种编译
http://blog.skeeterhouse.com/9032.html
http://kripken.github.com/mloc_emscripten_talk/#/
http://asmjs.org/faq.html

------

近几天看了下 `commonjs-everywhere` 的用法, 觉得可以考虑尝试了
https://github.com/michaelficarra/commonjs-everywhere
相对于 `browserify` 来说的确有一些难得的优点:

* 命令有 `watch` 参数, 关注依赖的内容自动编译, 省了一些麻烦
* 对 CoffeeScript 支持更好, 不需要后缀, 作者本身就是写 coffee 的
* 部分 Browserify 没有自带的 Node 模块在这里是默认的, 方便一些

麻烦当然有还不少:

* `watch` 过程中如果出现错误, 整个程序就会挂掉
* 依赖的是 CoffeeScriptRedux, 文档不多, [`test/`][test] 下的代码看来和 coffee 语法有区别
* [Redux 的函数参数不允许换行, 大概是 Bug][args], 以后应该会好的
* 我现在的 `index.html build.js` 以及编译命令需要在同一路径, 不清楚剧场限制..

[test]: https://github.com/michaelficarra/CoffeeScriptRedux/tree/master/test
[args]: https://github.com/michaelficarra/CoffeeScriptRedux/issues/83

相对来说我探索的还太少, `cjsify` 是暴露 AST 的, 信息量更多
话说回来这名字取得, 其实也是 `browserify` 的一个相似方案
很多模块应该也是可一样 `require` 的, 以后再看吧
