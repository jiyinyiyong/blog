
SeaJS 使用 coffee 的尝试
------

写 cirru-editor 刚开始用了一个 `require` 脚本模拟 CommonJS 规范
结果出问题不晓得怎么办, 在社区卖萌也没人理, 太没意思了
http://cnodejs.org/topic/5067ba8c01d0b80148863ae7
也这几天意识到模块化的重要性了, 因为我开始需要写规模更大的代码
一直在关注, 文档最丰富的还是 SeaJS, 此前因为陌生原因没有深入

有一点是 SeaJS 多用了一层 `define`, 弄得我莫名奇妙
仔细看虽然并不明白多么重要, 但其内部的确是 CommonJS 的习惯没错
SeaJS 对 coffee 的支持我是早就看到了, 作为插件进行支持
https://github.com/seajs/seajs/issues/265
注意写 coffee 的函数需要多写一个 `return`, 这个以后在看看

我模仿了一下官方的例子写了一段代码进行测试, 感觉还是不错的
http://seajs.org/docs/examples/coffee-and-less/
https://gitcafe.com/jiyinyiyong/seajs-coffee-demo

另外 SeaJS 的模块没有发现 Jade 和 Stylus,, 有点烦
两者是有浏览器端实现的, 我找到了两对应的代码:
https://github.com/visionmedia/jade/blob/master/jade.js
https://github.com/LearnBoost/stylus/blob/gh-pages/stylus.js
发现代码中有关于 CommonJS 规范的实现, 大致的 API 我认得
不清楚具体的依赖和冲突.. 不晓得能不能改成 spm 模块
如果有的话, 以后我放到 Git repo 的代码就不用全部编译后代码了
对于 `require` 的实现到现在我还是不清晰的, 再说..

关于 SeaJS 的重要性, 在网上也比较好的介绍
http://cyj.me/why-seajs/zh/#basic
我的感觉就是我在另一个项目里要引用之前写过的代码,
而之前的代码也是用多个文件分层写的, 于是重用代码就会很烦
相对于每次复制粘贴代码, 我更倾向调用 gh-pages 上的链接
或者 SeaJS 有更好的方案, 细节还不清楚...

关于 SeaJS 看官方索引的中文文档, 很全的样子
http://seajs.org/docs/#api
SPM 以后可能还会是大头, 毕竟冲着另一个 NPM 样子去的
https://github.com/seajs/spm/blob/master/README.md
另外之前曾经误会 SeaJS 是 AMD 的, 确认了一遍是 CMD
https://github.com/seajs/seajs/issues/242
http://wiki.commonjs.org/wiki/Implementations

还有就是调试时页面自动刷新. SeaJS 的插件我在推上看到了
https://github.com/seajs/reload-server#readme
当然既然用了 SeaJS, 我的 doodle 就有点多余了. 除非前者出问题
