
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

#### parse

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

#### error

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

目前解释器仅仅完成了基本的 Demo, 没有想通语言特性方面的事情
主要是基本数据类型, 作用域读写, 跨作用域数据交互, 三个方面

#### 基本数据类型

就是对 JS 原有数据类型的封装, 比如 Number, 通过一个名字比如:

```
number 2
```

对应的代码实现要预先检查 token, 生成报错, 下边的例子里我去掉了:

```coffee
number: (scope, list) ->
  x = list[1]
  number = parseInt x.text
  if isNaN number
    log_error x, "#{stringify x.text} is not valid number"
  else
    number
```

因为 Cirru 是不通过语法区分数据类型的, 所以其他数据也要名字

```
string "a string"
bool yes
```

复杂的数据类型需要递归调用 `intepret` 方法, 这个是解释器的核心,
解释器就是需要树状的数据结构, 以便递归结算然后对数据进行合并
比如 `array` 的实现, 就会从表达式进行递归:

```coffee
array: (scope, list) ->
  list[1..].map (x) ->
    the_type = type x
    if the_type is 'object' then x
    else if the_type is 'array'
      main.interpret scope, x
```

#### 作用域的实现

每个表达式有对应的作用域, 简单的情况下用一个 `{}` 来保存
代码执行的过程抽象为对作用域的读写, 主要是 `get set` 操作:

```coffee
set: (scope, list) ->
  the_type = type list[1]
  if the_type is 'object'
    scope[list[1].text] = main.interpret scope, list[2]
  else if the_type is 'array'
    scope[main.interpret scope, list[1]] = main.interpret scope, list[2]
get: (scope, list) ->
  the_type = type list[1]
  if the_type is 'object'
    scope[list[1].text]
  else if the_type is 'array'
    scope[main.interpret scope, list[1]]
```

在 Cirru 里, 对应的想法被增强了, 作用域应当作为一等公民被传递
比如把当前作用域取出, 再手动打开作用域运行代码:

```coffee
'get-scope': (scope, list) -> scope
'load-scope': (scope, list) ->
  if (type list[1]) is 'object'
    child = scope[list[1].text]
  else if (type list[1]) is 'array'
    child = main.interpret scope, list[1]
  list[2..].map (expression) ->
    main.interpret child, expression
```

#### 跨作用域的数据

有了上边的想法, 我想做更远, 将作用域传递到其他作用域去执行代码
前面说, Cirru 是不区分代码和数据的, 意味着代码可以作为数据传递
这样就不需要通过 Macro 展开, 只要把代码作为数据传递过去即可
对应需要两个 `code eval` 两个函数完成获取代码和手动执行代码的过程:

```coffee
code: (scope, list) ->  parent: scope
  list: list[1..]
eval: (scope, list) ->  code = main.interpret scope, list[1]
  child =
    parent: code.parent
    outer: scope
  code.list.map (expression) ->
    main.interpret child, expression
```

此外象征性做了一个 `import` 方案, 仅仅是引入代码的功能

```coffee
import: (scope, list) ->
  module_path = path.join list[1].file.path, '..', list[1].text
  unless fs.existsSync module_path
    log_error list[1], "no file named #{module_path}"
  main.run scope, (parse module_path)
```

对应的代码是演示性质的, 并不能真实地使用, 而且我目前不打算继续
希望这个作为一个学习解释器的例子会有用.. 虽然更可能带上歧途...

猜想: Cirru 的函数
------

看到这里可能发现, Cirru 里没有尝试做定义函数的语法, 而函数是编程的基础
对于函数我想这样理解, 函数相当于手动在一个作用域里执行代码,
手动执行时可以传入原先作用域没有的数据, 以便函数做更强大的操作
而函数的功能就在于一段代码存入一个变量, 可以被使用者控制而执行

那我想以更底层的一种方式去理解这样一个过程, 函数是很多个操作的组合
1) 有一段代码, 用户获取了, 但不会立即执行, 而可以在需要时执行
2) 代码片段附带一个作用域, 用户可以随时将代码在对应作用域的子域执行
3) 用户执行代码片段时可以传递进来一些其他作用域的数据

我觉得其中有两点可以替换, 来换取比函数更强大的操作方案:
1) 执行的作用域, 当作用域是一等公民, 可以传递任何作用域给代码执行
2) 传进数据的方式, 让代码获取当前用户所在作用域, 自己取数据

我的想法是每次执行通过手动管理作用域以及代码之间的组合获得更多灵活性
代码片段中可以通过 `parent` 和 `outer` 两个引用来直接访问作用域
比如下边的 Cirru 伪代码展示从 `scope b` 运行 `scope a` 的代码:

```
scope a
  set a $ number 2
  set c $ code
    print a
    print $ get parent
    print $ get outer
    print $ scope-get parent a
    print $ scope-get outer a
scope b
  set copy-a $ scope-get parent a
  scope-eval copy-a $ scope-get copy-a c
```

当然这样的设计严重偏离设计和开发的模式, 让新手更容易写出难以维护的代码
我主要想说, 如果 Scope Code 都像数据可以随意使用的话,
Lisp 让函数成为数据自由被调用和传递, 带来了高度灵活的函数式编程
Go 让 Channel 成为语言里可以赋值传值的数据, 带来强大的并发管理方式
很多想法在脑海里思考时没有界限, 那么我希望在语言当中可以少一些障碍

一个简单清晰的例子比如我常用 `console.log` 打印数据来看报错,
为了直观, 打印变量 `juice` 我会写 `console.log "juice", juice`
我很想, 如果 `console` 可以读到当前作用域, 那同个单词不需要写两遍,
可以写 `console.log2 "juice"`, Cirru 里是 `console.log2 juice`
因为后面更接近我们脑子里所想的, 也是更明了的一种表达

更多
------

这样的设计的确会造成更多的误用, 对于这我是这样考虑的
首先, 人们需要语言有无比的灵活性, 来避免一些障碍, 或者更快做一些简单的事情
同时, 人们需要自己学会怎么不犯错误, 而不是用一门永远不会犯错的语言
Bash 很糟糕, 但有很多场景人们还是用 Bash, 因为有时不需要考虑太多
我希望 Cirru 有机会是. 当然我先要学好多东西才能做下去

Cirru 另外的计划是图形化的编辑界面, 我说过, 代码就是一棵棵树
看过 [Python 实现的 Emacs 上语言编程视频][voice]吗? 编程未必是编辑字符串
需要的是好的代码展示, 还有好的内容编辑, 字符串仅仅是最常用的方式
很多年以后我们会看到各种新的方式, Cirru 计划有图形, 只是估计很原始

[voice]: http://python-china.org/topic/645

最后我最期待的是来个牛人把图形编程还有灵活语义的语法做出来
那样就不必我等爱好者冒着风险头脑风暴了 >_<