
基于 Stylus 和 Browserify 前端代码的想法
------

我从前想的是学会快速做各种原型给人展示我的想法就好了, 而不是维护
自己买 VPS 遇到被墙也只能不了了之, 代码压缩的场景也没有深入过
开源代码, 特别 JS 依靠源码明文传输, 压缩代码主要是网速的意义了
今天早上看 Bret Victor 的视频, 觉得一张白纸, 被错误观念影响很小还走运
晚上吐槽前端环境太复杂, 被指出基础不够扎实.. 唉, 总是要圣火在现实里的

### SeaJS 相关

![seajs](https://f.cloud.github.com/assets/661559/840596/ce1b55e4-f377-11e2-859c-ed1172ed632a.png)

很久都想尝试 [SeaJS](http://seajs.org), 因为有国内社区的氛围, 比起 @substack 近多了
SeaJS 一直以来文档不全, 这个夏天才看到 Issue 里排了相关计划
我近几天搜索网上博客, 零零散散介绍 SeaJS 有很多了, 只是 SeaJS 改版了
浏览器端按文件加载的语法不难, 文档很详细 https://github.com/seajs/seajs/issues/242
又接触到 Arale, 看到底部的导航, 之间的关系懂了个大概
```
Arale • Alice • Sea.js • spmjs.org • nico
```
Arale 是 JS 基础库, Alice 是 UI 框架, SPM 是打包, Nico 是文档

![arale](http://aralejs.org/static/arale.jpg)
![alice](http://aliceui.org/static/alice_by_meago.png)

有时间再啃一下 Alice 和 Arale 的文档, 怕都有惊喜的感觉
看 Issue 里说的, SeaJS 不少相关文档散落在这两个站点里边

当前我比较着急的是合并部署代码相关的文档, SPM 的文档相对是最缺的
由于改版, 采用了 Grunt, 加上支付宝并不是国外社区那样很多闲人参与
旧的文档大多不能在 SPM2 对应看, 现在主要剩下 https://spmjs.org/ 的几篇
另外关于代码合并, [为什么 SeaJS 模块的合并这么麻烦][concat]文章里做了比较清晰的解释
主要是简略的写法, 导致代码不能直接有 id 的命名空间, 需要先 transport
transport 以后, 再经过 concat 和 uglify 两个步骤, 才算完成. 打包都把我看晕了

[concat]: http://chaoskeh.com/blog/why-its-hard-to-combo-seajs-modules.html

关于 SeaJS 的实现 [HelloSea.js][hello] 的文章写了很长的教程, 非常推荐
还可以参考 [modjs][modjs], [modjs1][modjs1]重名比较高.. 谁给解释下

[hello]: https://github.com/Bodule/HelloSea.js
[modjs]: https://github.com/zjcqoo/mod/blob/master/mod.js
[modjs1]: http://madscript.com/modjs/

### [Stylus][stylus] 部署

![stylus-logo](http://learnboost.github.io/stylus/assets/stylus.png)
[stylus]: https://github.com/LearnBoost/stylus

我遇到的需求不够普遍吧, 没有经验把场景理解很透彻, CSS 是全打包压缩的
首先 concat 和 cssmin 通过 Grunt 插件是可以直接做到的
但直接管理 CSS 存在问题, 之前我也没想到过这样的不便:

* 没有用 Stylus, SASS 之类方案将 CSS 书写结构化, 修改不方便
* 页面引用大量 CSS 文件, 以及 Gruntfile, 管理不方便
* 服务器部署需要单一的 CSS 文件入口, 分散的 CSS 文件又需要合并
* CSS 文件代码重用, 文件树管理, 造成了不方便

于是想到通过编译文件常用的 join 方式将 CSS 在编译时合并
Stylus 支持 `@import` 语法, 可以在编译时加载 `*styl` 文件合并
对于 `.css` 文件默认是不合并的, 可以通过 `--include-css` 来完成开启
上边的功能通过对应 [Grunt 插件][grunt-stylus] 可以直接使用

[grunt-stylus]: https://github.com/gruntjs/grunt-contrib-stylus

另外 CSS 合并要考虑相对路径图片 url 的转换, 需要额外支持
搜索了一下, 在 [grunt-css-urls](https://github.com/Ideame/grunt-css-urls) 这个插件有支持
命令行有 [clean-css](https://github.com/GoalSmashers/clean-css) 可以用, 但估计不适合 Grunt
Stylus 最近的 commit 和 help 里有找到 `--relative-url` 来开启对应功能
我[尝试][try]了下, 被告知对应文件存在时, Stylus 可以正常工作
于是就剩下[插件里需要确认下][wait]是否已经支持这个功能了

[try]: https://github.com/LearnBoost/stylus/issues/1092
[wait]: https://github.com/gruntjs/grunt-contrib-stylus/issues/49

CSS 部分有 Stylus 这些功能支持, 探索暂时告一段落

### [Browserify][browserify] 打包 JS

![browserify-logo](http://browserify.org/images/browserify.png)
[browserify]: http://browserify.org/

[之前讲过][previous], 现在唠叨一下吧, 对于喜欢 CommonJS 的人来说, 魅力啊
Browserify 通过解析代码, 提取文件的依赖关系, 最后对代码进行打包
命令行 `browserify main.js -o bundle.js` 即可完成打包的过程
CoffeeScript 编译需要本地安装 [`coffeeify`][coffeeify] 插件, 还算可以
后来发布了 [watchify][watchify] 插件填坑做了监视文件保存自动刷新编译的功能
加上很久以来的 SourceMap, Chrome 调试已经感觉很好

相关的, [commonjs-everywhere][cjsify] 项目因为用了文档不全的 CoffeeScript 2.0
我个人受不了 2.0 一些没完善的地方, 估计现在用的人也不会多
另外看到有个 [onejs][onejs] 和 [gluejs][gluejs] 在 Browserify 上做封装, 没细看
对了 Browserify [一个模块已经改进了对 `.coffee` 后缀的识别][month-ago], [期待近期事情有个了结][days-ago]

[previous]: http://jiyinyiyong.github.io/blog/posts/130421-browserify-入门笔记.html
[grunt-browserify]: https://github.com/jmreidy/grunt-browserify
[coffeeify]: https://github.com/substack/coffeeify/
[watchify]: https://github.com/substack/watchify
[cjsify]: https://github.com/michaelficarra/commonjs-everywhere
[onejs]: http://github.com/azer/onejs
[gluejs]: https://github.com/mixu/gluejs
[month-ago]: https://github.com/substack/module-deps/pull/5#issuecomment-19870412
[days-ago]: https://github.com/substack/node-browserify/pull/336

预想里有合并好的 JS 的话, HTML 里引入的 JS 文件可以减少到很多
代码管理上, 可能存在其他疏忽, 但希望能避免当前的问题

### 还没做测试

没做过测试, 什么都可能发生. 希望文章对大家有用
另外这方面经验很少, 求指点