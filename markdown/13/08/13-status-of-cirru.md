
Cirru, 自己学写解释器
------

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
