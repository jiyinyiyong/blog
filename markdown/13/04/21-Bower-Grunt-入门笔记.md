
浏览器模块化, Bower, Grunt 相关
------

原文在 coffee-js/languages Issues 里, 话题不符, 转移
https://github.com/coffee-js/languages/issues/51

寒假花了不少时间在模块化的问题上边, 也感到独自一个弄不除什么花头
大概外边公司里实用方案很多, 我挖 Github 上文档反而多余
JS 模块化的 `require` 更多用 AMD 规范, 而且有各种实现
但这只是一个加载器, 对比 Node  的模块化方案, 很多工具是却是的

### Bower

一个是用配置文件声明, 单独完成上传下载的功能, 这是用 Bower 来完成的
Bower 来自 Twitter, 仅仅是包管理的工具, 而不具备其他功能
主页上的文档对用途说明比较详细: http://twitter.github.com/bower/
还有已有的模块在网上可以看: http://sindresorhus.com/bower-components/
Bower 的模块都放在 Github 上, 通过 Git 的协议拷贝模块
存在 tag 时会下载 tag 里的压缩包, 否则直接 clone 源代码
其他的教程在网上可以找到, 但我不知道国内哪些在用的:
http://net.tutsplus.com/tutorials/tools-and-tips/meet-bower-a-package-manager-for-the-web/

Bower 常用的命令是 `bower search` `bower install` `bower register`
首先, 在项目里要有的 `component.json` 文件, 类似 Node 的 `package.json`
里边写上名字版本之类, 并且用 `dependencies` 声明依赖以及版本
版本号遵循 Semver 的规范, 看命名的方式, 似乎 Node 也是...
https://github.com/kainy/semver/blob/master/semver_zh.md
写了依赖之后, 用 `bower install` 就会下载对应的模块文件了
文件会在 `~/.bower/` 目录下缓存, 以便下次安装. 当然也有命令清除缓存
此外一个简便的 `--save` 参数, 用来自动在 `component.json`  文件增加模块

```bash
bower install jquery --save
```

模块的安装文件是在 `components/` 里面, 这个命名并不好
首先 Bash 里两个 `component` 开头不好办, 其次还跟 Component 项目不兼容
也许以后会换一个 `bower.json` 的文件名, 至少现在还不支持的
https://github.com/twitter/bower/issues/110

Bower 没有 Node 那样的中心仓库, 而仅仅是 Github 加上服务器是的模块列表
其他大概就是命令行上做的功能来支持了. 说真的, 麻烦真不小
刚开始我尝试在 Bower 上注册了 SeaJS, SeaJS 的 repo 没用 `compoent.json` 文件
下载后自动增加了这个文件, 但是下载非常耗时间, 因为 repo 本身非常大
后来才意识到这是从 Github 下载 repo 我发避免的问题
另外 Bower 注销模块也非常麻烦, 所以重命名跟着遥遥无期了
https://github.com/twitter/bower/issues/120

Bower 的模块和 Node 明显的差别是没有深度的嵌套..
因为前端的模块极容易污染全部变量, 再怎么嵌套也没有太多的意思
但这也许可以是致命的一个麻烦吧...

### Grunt 的构建工具

Grunt 的功能就偏向于前端实用的一些编译打包操作了
类似 Rake Cake 主要就是写 Task, 然后在命令行是启动 Task
http://gruntjs.com/
http://benalman.com/news/2012/08/why-grunt/
好处在于其配置文件更清晰, 不似 Cake 都得手写一遍
另外更难的是大量的插件, 保证了大多时候只要配置就足以完成操作
Grunt 的配置文件是 `Gruntfile.coffee` 或者 `Grunrtfine.js`
https://github.com/Takazudo/gruntExamples
当然要属官网的文档最清晰, 外边英文的教程就难懂
http://takazudo.github.com/blog/entry/2012-04-14-grunt-coffee.html
http://net.tutsplus.com/tutorials/javascript-ajax/meeting-grunt-the-build-tool-for-javascript/
中文的也有一些, 大概有类似经验看了马上就懂了. 我花了点时间
http://www.cnblogs.com/lhb25/archive/2013/01/24/grunt-for-javascript-project-a.html
http://ambar.li/blog/2012/11/30/grunt-intro/

我在网上找到一些教程, 慢慢看懂了里边的意思
https://github.com/Takazudo/gruntExamples/tree/master/tutorialthings
最简单的 Gruntfile 可以是下边这样的, 类似 Cake:

```coffee
module.exports = (grunt) ->

  grunt.initConfig
    log:
      foo: [1, 2, 3]
      bar: 'hello world'
      baz: false

  grunt.registerMultiTask 'log', 'Log stuff.', ->
    grunt.log.writeln "#{@target}: #{@data}"

  grunt.registerTask 'default', ['log']
```

实际一些, 用编译 CoffeeScipt 的插件做例子:
Grunt 模块的命名方式都是 `grunt-` 打头, `contrib` 是官方维护的模块
比如编译 coffee 的: https://github.com/gruntjs/grunt-contrib-coffee
首先要有全局安装的 `grunt-cli` 模块, 项目里要有 `grunt` 模块
接着用 NPM 下载对应的编译模块, :

```bash
npm install grunt-contrib-coffee --save-dev
```

下载完成是 `Gruntfile`, 我是用 coffee 写的..

```coffee
module.exports = (grunt) ->

  grunt.initConfig
    coffee:
      compile:
        options:
          bare: yes
        files:
          "page/main.js": "action/main.coffee"

  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.registerTask "dev", ["coffee"]
```

Gruntfile 里需要是 `module.exports`, 否则无法正常使用..
接着是 `initConfig`, 传入的是对某个 task 的配置
这里的 `coffee` 是在 `grunt-contrib-coffee` 里定义的, 所以配置要在那边生效
`loadNpmTasks` 加载 NPM 模块, 看其他的编译模块也是类似的写法
中间的 `options` 和 `files` 参照文档很好懂, 只是没试过能不能直接写目录..

上边的 `compile` 需要注意, `compile` 这里名字是随意取的..
Grunt 的 Task 分两种, `registerTask` 和 `registerMultiTask`
两者的区别就是前者只能加一个任务.. 后者可以按名字加多个任务
后者比如  `connect` 插件的配置, `coffee` 插件也是这种情况
https://github.com/gruntjs/grunt-contrib-connect

```js
grunt.initConfig({
  connect: {
    site1: {
      options: {
        port: 9000,
        base: 'www-roots/site1'
      }
    },
    site2: {
      options: {
        port: 9001,
        base: 'www-roots/site2'
      }
    }
  }
});
```

另外不错的是监视文件改动执行任务的插件, 对编译语言的用户比较实用
https://github.com/gruntjs/grunt-contrib-watch
此外 Grunt 提供了不少 API, 给开发插件提供方便, 不过,, 我还不会...
https://github.com/gruntjs/grunt/wiki
当然简单的插件仅仅像是 Cakefile 里的一个任务,,
https://github.com/gruntjs/grunt-contrib-clean/blob/master/tasks/clean.js

还一个我用到的功能是项目模版, Grunt 内置了一些, 但我自己弄了一个
http://gruntjs.com/project-scaffolding
安装命令后在 `~/.grunt-init/` 下可以创建文件, 需要包含一下文件:

```
my/template.js
my/rename.json
my/root/
```

`root` 里是项目模版的文件夹, `rename.json` 是一些名字的映射
主要是 `template.js` 文件来控制文件内容的拷贝等等过程
我自己凑出来一个很简化的版本... https://github.com/jiyinyiyong/page-template/

```coffee
exports.description = "Template for my Webkit-only pages"

exports.notes = "run `npm install` and `bower install`"

exports.warnOn = '*'

exports.template = (grunt, init, done) ->
  init.process {}, [], (err, props) ->
    files = init.filesToCopy props
    init.copyAndProcess files, props
    done()
```

实际上复杂太多. 真的很难用,, 请看有注释的源码....
https://github.com/gruntjs/grunt-init-jquery/blob/master/template.js
另外这里不能用 CoffeeScript, 太气人了...

我想 Grunt 的思路, 还是用配置文件取代 Bash 命令中间的麻烦
并且提供一些基础的文件操作和各种 Log 的接口, 方便开发
只是多多少少接口的设计上不那么亲近, 日常使用不是很开心..

### 其他

总之前端的功能很邪门地便复杂了, 我想说浏览器真心太复杂了
写代码的人们忙着赚钱, 搞来搞去一切都不再是那么好玩的东西
另外 Component 项目, 像 SeaJS 作者讨论帖说的, 调试时需要分离的文件
但现在其他方面的进展让我挺期待的 http://component.io/
