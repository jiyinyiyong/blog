
Cirru, 自己学写解释器
======

自己创造一门编程语言是理解编程语言原理很不错的一个方案
而且当我反感了大多数语言中充斥着括号时, 自己就很想尝试做一个
我还没有学编译原理, 所以这里参考的都是网上比较粗浅的资料
另外还有一些 Compile to JS 的语言, 尝试看了点源码, 尽管看懂挺少

最早把编程语言原理呈现在我面前的是 [Peter Norvig][peter] 的 [Lispy][lispy]
那是一个用 Python 写的 Lisp 语法解释器, 把编程语言基本的原理揭示出来了
后来他还有增强版的 [Lispy][lispy2], 可惜主要的部分我没有看懂
好在从这里, 基本的编程语言如何运行的概念已经清晰了, 就有了一个开始
那时我学着用 CoffeeScript 写了一遍, 可惜现在忘了存哪儿..

[peter]: http://norvig.com/
[lispy]: http://www.googies.info/articles/lispy.html
[lispy2]: http://norvig.com/lispy2.html

后来有尝试去学 [PEG.js][peg] 来生成语法树, 当时在缩进方面卡住了
我之前尝试写 Cirru 时用的还是 Lispy 的办法解析嵌套的括号
到看了 [Lispyscript][lispyscript] 以后会了点基础的 token 解析
但解析缩进语法我还是想不出来, Cirru 的计划就直接搁起来了

[peg]: http://pegjs.majda.cz/
[lispyscript]: https://github.com/santoshrajan/lispyscript/

因为对编程语言的疑问, 所以我一直在关注着相关的教程看进展
以及我后来[收集的编程语言资源][collection], 也是在中间积累起来的
还有[王垠也写了关于解释器的教程][yinwang0], 只是那是 Racket 不是基本的编程语言
而语法是我学编程语言纠结的第一道坎, 我很想从语法开始解决

[collection]: https://github.com/coffee-js/languages/wiki/简化的解释器入门和编程语言了解
[yinwang0]:http://www.yinwang.org/blog-cn/2012/08/01/interpreter/

重写 Cirru parser
------

是在看到 [Little Lisp interpreter][little-lisp] 文章以后重新想起这回事的
再后来突然想到其实 token 解析的中间状态其实可以更高效保存的, 比如:

```
print "string #{print "string"}"
```

这样的代码原先我只会通过一个变量保存当前状态, `""` 内如何如何
那么内部的一个 `"string"` 结束后遇到括号都不知道在什么状态了
这种情况下其实用一个先入后出的栈来解决, 而状态就是堆叠的
基于这样的理解, 我计划重写 [`cirru-parser`][cirru-parser] 这个模块
同时为了方便写判断条件, 我想实现了一个模式匹配的模块 [coffee-pattern][coffee-pattern]

[little-lisp]: http://maryrosecook.com/post/little-lisp-interpreter
[cirru-parser]: https://github.com/jiyinyiyong/cirru-parser
[coffee-pattern]: https://github.com/jiyinyiyong/coffee-pattern#usage

```coffee
{match} = require 'coffee-pattern'

match 'string or number here',
  'string', 'string'
  /^head/, (data) -> print "#{data} matches head"
  /tail$/, (data) -> print "#{data} matches tail"
  /fine/, 'fine'
  5, (data) -> print 'it is five'
  null, -> print 'matches null not undefined'
  undefined, (data) -> print "#{data} has no matching pattern"
  key: -> 'object as a shortcut'
```

主要提供了对应 CoffeeScript 里 `switch/when/else` 的功能
另外额外支持了一些语法糖和正则等复杂的方案备用

Cirru 语法
------

Cirru 解释器支持的语法现在是这样几条:

* 行内可以使用 `()` 进行代码的嵌套, 两格缩进产生行的嵌套
* 比如 `"a string"` 这样双引号包裹的 String, 其中 `\` 用来转义
* `a $ b c` 里用 `$` 表示直到行尾的嵌套 `a (b c)`

具体例子在 [README][parser-readme] 里给了比较详细的例子可以对照
以及做了, 自己觉得比较友好的错误提示, 提示到了字段上
解释器的作用是把字符串的文件, 转化成为可以递归处理的语法树
树上除了字段和嵌套结构, 还有为了打印出错信息而附加的行号和文件名的引用

[parser-readme]: https://github.com/jiyinyiyong/cirru-parser#syntax

中间 token 折叠为 AST 的步骤原先想会比较难, 做着发现有简单的方案:

```coffee
ast: proto.new
  init: ->
    @tree = []
    @entry = [@tree]
    @errors = []
  push: (data) ->
    @entry[@entry.length - 1].push data
  nest: ->
    new_entry = []
    @entry[@entry.length - 1].push new_entry
    @entry.push new_entry
  ease: ->
    @entry.pop()
  newline: ->
    @ease()
    @nest()
```

Demo:

```coffee
{protos} = require '../coffee/states'
ast = protos.ast.new()

print = (args...) -> console.log args...

print ast.tree

ast.push 1
ast.nest()
ast.push 2
ast.nest()
ast.push 3
ast.ease()
ast.push 4
ast.nest()
ast.push 6
ast.nest()
ast.push 7
ast.ease()
ast.push 5

print JSON.stringify ast.tree
```

之前有看到过用 JS 的引用机制, 巧妙地保留嵌套内数组的引用, 送入 token 的
上边的代码里, `next` 方法就制造了对内存数组的引用
这样保证了顺序进入的 token 能被正确折叠为树状, 能被递归函数处理
代码里用了基于原型的 OOP 可能带来疑惑, 可以看 [proto-scope][proto] 的介绍

[proto]: https://github.com/jiyinyiyong/proto-scope#proto-scope

现在的 Cirru Parser 模块是可以重用的, 如果认可我用缩进的方案的话
Cirru 现在其实没有其他语法, 很简陋, 只能作为学习用的代码
如果你用 CoffeeScript, 用 Cirru 意味着不用再手写一遍解释器部分
也期待有同学帮我改正 Cirru Parser 里一些问题来做更好

使用模块需要熟悉 Node, 然后安装模块到本地的项目里:

```
npm install --save cirru-parser
```

```coffee
{parse, error} = require 'cirru-parser'
```

模块提供了两个方法, 一个是根据文件名解析出 AST 树, 返回 AST 信息
另一个是根据给定的数据结构生成错误的格式化输出
目前这部分文档不够详细, 只能从我简单的代码和 README 里翻了

* parse

```
parse <filename>
=> { ast: <tree>, errors: [<error string>] }
```

`parse` 接受一个文件名, 返回解析的 AST 以及语法上的错误
如果返回结果的 `.errors.length > 0`, 说明有语法错误
`.errors` 里是已经格式化好的错误内容的字符串, 取出后还有打印
省略了 `.file` 属性的 AST 看起来是这样的一个树形结构:

```

demo
  demo $ demo
```
```json
[
  [],
  [
    {
      "text": "demo",
      "x": 4,
      "y": 1
    },
    [
      {
        "text": "demo",
        "x": 6,
        "y": 2
      },
      [
        {
          "text": "demo",
          "x": 13,
          "y": 2
        }
      ]
    ]
  ]
]
```

开头的空数组 `[]` 可以认为是 `parse` 方法的 Bug, 目前不影响使用

* error

```
error { text: 'msg', x: <x>, y: <line>, file: { path: '', text: '' }}
=> <error string>
```

`error` 是通过行号, 文件, 信息来生成错误提示的字符串, 再取出打印
错误的格式大概是这样的, 包括了需要查看的主要信息:

```
✗ ./test/piece.cr: 6
"ddd
   ^ quote at end
```

AST 中的一个 token 和 `error` 接受的参数都是同样结构的:

```coffee
text: 'token' # 在 error 里是错误信息
x: 0 # 发生错误的行坐标, 从 0 开始
y: 0 # 发生错误的行号, 从 0 开始
file: # 一个对象引用
  path: './code.cr' # 源码文件相对路径
  text: '' # 文件内容
```

`parse` 返回的 `.errors` 是在模块内通过 `error` 方法产生的, 样式一致

Cirru 解释器
------