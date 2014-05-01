
## 关于作用域

我从不同的角度去理解作用域, 发现有趣而麻烦的问题
这里不想涉及类型系统, Haskell 我还没入门. 这里我只能用 CoffeeScript 做例子
函数式编程强调不可变的数据, 回调和闭包, 重点至少不是我这里想说的
面向对象我觉得基本理解了, ..虽然我又叉开了往别的地方想
想看下有没有同学和我一样去想过, 然后这样是不是有用的..
而且我看到的教程都没往这方面讲, 搞得我自己也有些怀疑这条理解的思路

#### 关于 CoffeeScript

后面用的例子是 CoffeeScript(coffee), 大概要介绍下
学 coffee 入门有些无奈, 高考.. 买电脑.. 也许 JS 还是很多人看不上的
coffee 实际上完全是 JS, 除了语法, 紧凑简洁一些

JS 里每个元素是对象, 定义个对象很方便, 但我想更应该叫表 (table) 才对
一个表的例子是下面这样的:
```coffee
# 井号开头是注释, 下面是表
table1 =
  name: "a string"
  "table1.1":
    name: "a nested table"
    list: []
  value: 3.14
```
JS 学的 Scheme, 函数作为基本数据类型可以用在赋值和传参
```coffee
log = console.log
f3 = (a_function, a_string) -> a_function a_string 
```
coffee 里函数的写法过于简洁.. 大概学的 Erlang
匿名函数的写法, 函数声明, 以及函数调用就像下面这样:
```coffee
-> log "hello world" # 匿名函数, 没有参数的情况

f = -> log "hello world" # 赋值给变量
f2 = (x, y) -> # 如果带两个参数
  log x
  log y # 函数默认 return 一个结果

f3 = (a_function, a_string) -> a_function a_string # 调用函数, 省略括号
f3 log, "demo" # 调用函数, 省略括号, 但逗号还是要的
```

JS 更重要的是每个函数应该是方法, 并从函数内能访问到 `this` 指向所属对象
浏览器里初始是 `window`, Node 默认大概是 `global`(?)
coffee 里用 `@` 简写了 `this`, 比如 `this.a` 就是 `@a`:
```coffee
log = console.log

# 运行函数是 Node, 默认的 @ 是模块的 @, 有些古怪..

global.name = "at global"
f = ->
  log @name # 函数内的 @ 就是 global 了
  log @ is global # 运行返回的 true

f() # 打印 "at global"
log global.f # <- 这是我没想通的... 结果是 undefined

table1 =
  name: "a table1"
  f: -> log @name

table1.f() # 打印 "at table"
```

JS 作为动态语言也有 `eval` 的功能, 配合 `Function.prototype.toString`
用代码可以展示 `eval` 用另一种方式操作作用域:
```coffee
log = console.log

f = ->
  log (typeof inner)
  if inner? then log inner

nest = (func) ->
  log "\ndo nest"
  inner = "yes" # 在当前作用域标记个 inner
  func() # 函数数据从闭包取出, 打印 undefined

eat = (func) ->
  log "\ndo eat"
  inner = "yes"
  code = func.toString()
  func = eval "(#{code})"
  func() # 函数重新定义了一遍, 因而能所引到 inner, 打印出字符串

nest f
eat f
```

再还有是 JS 的原型链, 用隐藏属性 `__proto__` 表示, 写出来就简单了:
```coffee
log = console.log

table_a =
  name: "a"
  text: "this is a table"

table_b =
  name: "b"
  __proto__: table_a # 原型指定为 table_a

log table_b # { name: 'b' }
table_b.text = "assignment" # 赋值还是在自身的, 原型不会改变
log table_b # { name: 'b', text: 'assignment' }

log table_a # { name: 'a', text: 'this is a table' }
```

上边基本理解的话, 可以进入正题了

### 作用域获取变量的方式

编程相关的名词非常多, 各种范式, 我觉得都太难了...
我打算从简单一致的方式去理解, 就是函数执行过程的数据从哪里来
一般语言里就是变量, 变量来自参数, 或者来自外部作用域
但 JS 里一切都是对象, 作用域也很像是对象, 那么作用域是不是对象?

好吧, 不是... 而且汗我没有看过语言实现的代码, 不能解释..
但是, 作用域和原型的结构很相似, 有变量名, 会从上层索引, 这两点
一个特例是浏览器环境顶层作用域 `window`, 对象和作用域是一致的
那么我假设, 在这里讨论的作用域内部的实现是一个对象, 一个表
我的思路是把概念弄清晰, 如果作用域是表, 就好理解多了

因此, 作用域应 `__proto__` 类似的结构来实现对外层作用域的索引
并且函数当中应该能指定对外层的作用域进行操作的方式才对
既然作用域是表, 那么表也应该是作用域才对, 就应该有方法索引
我想这就是为什么有 `this`, 一个方法能获取对象的其他数据
`this` 的存在, 允许函数内部的代码有多一种获取数据的方式
比如这样一个例子, 就有了另一个存取变量的方法:
```coffee
log = console.log

a =
  name: "name of a"
  value: "value of a"

a.with = (f) ->
  @f = f # 得到的 @f 的 this 会改变
  @f() # 那么执行时候就能正确索引了

a.with ->
  name = "demo"
  log name # "demo"
  log @name # 打印出来 this 里对应的值
  log @value
```

上面都建立在 JS 或假设之上, Haskell 这样的函数式语言可不遵循
而且函数式语言反对可变的数据, 大致因为影响了并行和编译器优化
Lisp Haskell 我不懂为什么没有直接的表数据结构, 也不好说了
从灵活度上说, 我比较纳闷早的函数式语言是那样, 难不成只因为早..?
还是说安全性? 或者使用代码如何对于入门更方便只是 M$ 该考虑的..?

我的想法是基于 coffee 的, 动态语言相似, 其他语言大概不能类似强解
抛开 coffee 的语法, 抽象地说这是一个函数执行时如何取数据的问题
底层上看, 是寄存器和内存地址(..?没错吧), 但在语言执行环境有语义
那么加上我其他的想法, 大概有这么几个:

* 从函数参数
* 从外层作用域
* 从方法所属对象
* 从代码执行环境

前二容易被用到, 而对象.. 有的没有对象依然能有很强的表达能力
函数式语言强大的递归和参数传递, 经常解决起问题经常很优雅
最后从执行环境, 我认为是宏的用法, 不过在 JS 里比较弱
而函数参数, 也主要是从执行环境传递数据到函数内部的用途
可说到操作数据的话, 函数参数是单向的, 只有传递的对象才可以修改

而 `eval` 的代码能改变作用域, 也就能做一些别的做不到的事
比如一个模板引擎的代码, 因为能控制作用域, 就很短:
```coffee
log = console.log

tmpl = (f) ->
  ret = ""
  elems = "div nav footer"
  eval "var #{elems.replace(/\s/g,",")}" # 声明外层变量

  elems.split(" ").forEach (tag) ->
    action = (f1) ->
      ret += "<#{tag}>"
      f1()
      ret += "</#{tag}>"
    eval "#{tag}=(#{action.toString()});" # 赋值到外层变量

  text = (text) -> ret += text

  f = eval "(#{f.toString()})" # 重新生成函数闭包
  f()

log tmpl -> # 模板函数接受一个函数
  div -> # 这时作用域里没有 div 函数, 实际不是在这里执行
    nav -> text "inside"
    nav -> text "inside"

# 结果是 <div><nav>inside</nav><nav>inside</nav></div>
```
我想说, 如果存在直接操作指定作用域的运算符, 事情会简单
`eval` 并不是极好的方案, 而且必须配合 `var` 才有效
只能上伪代码了, 用 `&` 表示执行环境外层作用域:
```coffee
log = console.log

tmpl = (f) ->
  ret = ""
  elems = "div nav footer"

  elems.split(" ").forEach (tag) ->
    &[tag] = (f1) -> # 向外边一层作用域定义函数
      ret += "<#{tag}>"
      f1()
      ret += "</#{tag}>"

  text = (text) -> ret += text

  f()

log tmpl ->
  &div -> # 调用执行环境里的 div 函数
    &nav -> &text "inside"
    &nav -> &text "inside"
```
于是我想, 面对作用域就能有更多的手法去操作数据

同样的 HTML, 敢于手写或者用 doT 类似模板引擎也能很快写出来
可想要更紧凑灵活的表达, 想要更多操作的自由, 只能求助其他符号
是不是.. 太过灵活容易带来混乱, 所以人们不想在语言加功能
... 我还是期待有这样的功能可以去绕开一些坑
至于 Haskell 不喜欢副作用不喜欢对象, 好难接受, 上半年别想入门了..
