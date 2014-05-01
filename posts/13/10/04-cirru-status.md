
Cirru 的进展
====

[cirru-parser]: https://github.com/jiyinyiyong/cirru-parser
[cirru-interpreter]: https://github.com/jiyinyiyong/cirru-interpreter
[cirru.subl]: https://github.com/jiyinyiyong/Cirru.subl
[cirru-shot]: http://ww2.sinaimg.cn/large/62752320gw1e99528qzsdj21540nsq76.jpg
[node-dev]: https://github.com/fgnass/node-dev

Cirru 解释器没有部署完成, 目前无法做演示, 只有基本的测试功能
Cirru 目标是可以解释执行的脚本, 现在 NPM 上的模块可以安装一个命令行
```
npm install -g cirru-interpreter
```
这时创建一个 `demo.cr` 文件, 并且运行 `cirru demo.cr` 命令
`cirru` 命令是阻塞终端的, 会一直监视文件, 直到手动 `^C` 终止运行
然后写入如下的文本, 并且保存, 代码将会自动重新载入
```
echo hello world
```
并且输出重启的时间戳, 以及要打印的内容
```
✦✦✦✦ 14:43:23 demo.cr ✦✦✦✦
hello world
```

### 组成部分

目前已经成型的部分是

* 语法解析器 [cirru-parser][cirru-parser]
* 解释器 [cirru-interpreter][cirru-interpreter]
* Sublime Text 上可用的语法高亮 [Cirru.subl][Cirru.subl]

三者都比较粗糙, 不过除了解释器部分比较复杂外, 另外两部分不打算做大的改动了

### 语法

语法上讲, Cirru 是极简的, 借鉴了 Lisp 语法, 纯粹用嵌套来表达语法
即便注释, 在 Cirru 当中也是通过嵌套一个表达式来完成, 而不是增加符号
```
print (-- 注释)
-- 这里是注释
```
准确地说, 语法的规则主要是:

* 圆括号表达了表达式的嵌套关系, 但括号不允许跨行
* 缩进语法表示了表达式的嵌套关系, 用来取代跨行的嵌套关系
* 为了减少缩进和闭括号泛滥, 增加了 `$` 添加到行尾或者缩进结尾的嵌套
* 顶层的表达式裸露不嵌套
* 一般空格分隔开可以是语法以外所有符号的 token, 但可以用双引号转义

下面是几个例子:

Cirru 中
```
print a
```
等于 Lisp 语法的
```ss
(print a)
```

Cirru 中
```
print
  string a
  string b
```
类似 Lisp 中
```ss
(print (string a) (string b))
```

Cirru 中
```
print $ string a
```
类似 Lisp 中
```ss
(print (string a))
```

Cirru 中
```
set a $ hash
  a (number 1)
  b (number 2)
```
类似 Lisp 中
```ss
(set a (hash
  (a (number 1))
  (b (number 2))))
```

Cirru 中没有 `succ`, 仅作为伪代码
```
print (succ $ number 1)
```
类似 Lisp 中的
```ss
(print (succ (number 1)))
```

Cirru 没有提供直接的语法让数字和其他数据类型被标记, 而是靠语法生成
比如下面这些方案来提供基本的数据类型
```
number 1
string demo
string "demo with spaces"
array (number 1) (number 2) (number 3)
```

而关于变量, Cirru 中并不明确一个符号一定是作为变量传入
```
pseudo-f var-a
```
比如 `var-a` 在这里并不确定是字符串或者变量, 而是由 `pseudo-f` 自行决定
这样比如函数调用时, 可以直接获取字符串, 而不是只能获取变量
这将带来更多的灵活性, 但为了便利, 恐怕还是要做很多别的绑定

关于语法高亮的效果, 可以看这个[图片][cirru-shot], 大概不够高端...
![highlight][cirru-shot]

### 报错

将运行过程可视化是调试程序主要的手段, 当然这也可以有很多方案
首先打印数据的函数是一个, 用的是 `print`, 而 `echo` 无法读取环境
```
set a $ number 1
print a
```

关于错误的话, 首先是语法解析方案会发现错误, 比如 `print` 参数是必需的
```
set a $ number 1
print
```
当参数没有写明时, 解释器就会抛出错误, 提示
```
AssertionError: args should be longer then 0
    at Console.assert (console.js:102:23)

✗ demo.cr: 3
print
    ^
```

然后其中数据出错的话, 比如引用了一个不存在的变量 `b`
```
set a $ number 1
print b
```
解释器也报错. 只是这里处理得不够细, 在 `b` 才对
```
AssertionError: undefined not allowed
    at Console.assert (console.js:102:23)

✗ demo.cr: 3
print b
    ^
```

也会存在调用栈中某个位置出错了, 比如下边这个 `$` 替代了括号的表达式,
```
print $ print $ print $ print $ print a
```
Cirru 做了比较傻的错误栈记录, 结果是这个样子的, 可惜也不够准确
```
AssertionError: undefined not allowed
    at Console.assert (console.js:102:23)

✗ demo.cr: 2
print $ print $ print $ print $ print a
                            ^

✗ demo.cr: 2
print $ print $ print $ print $ print a
                    ^

✗ demo.cr: 2
print $ print $ print $ print $ print a
            ^

✗ demo.cr: 2
print $ print $ print $ print $ print a
    ^
```

错误报在 `console.assert` 上, 因为我是通过 `assert` 产生错误的
关于报错, 在 [cirru-parser][cirru-parser] 中做了些处理, 可以看模块
我特意抽出模块, 希望语法有人重用, 后来发现方案也不够好, 跨文件解析还是有麻烦
关于报错目前我只到这个, `debugger` 一样允许查看变量不知如何实现

另一方面, [node-dev][node-dev] 风格的 reload 方案代替了 REPL
REPL 通常没有编辑器支持, 输入长代码就成为麻烦, 我觉得不可取

### 模块系统

模块系统直接搬照 CommonJS 的 `require` `exports` 语法
而且本来就是 JS 里的对象, 其他的就是大幅简化的问题了
之前想过用 `include`, 因为引入的文件就是代码, 而代码可以作为变量引用的
后来想还是算了, 毕竟模块概念不强, 而且部署自动加载也有问题

比如再创建文件 `lib.cr` 编辑文件内容
```
echo running lib.cr

set exports $ hash
  value $ number 9
```
随后在 `demo.cr` 中输入代码用来引用模块
```
set x $ require lib.cr
print x (at x value)
```
代码在保存时就会输出如下的内容
```
running lib.cr
{ value: 9 } 9
```

自动重载代码依赖的是模块化记录的文件路径, 然后开始 watchFile
还有重载时清空记录和重新生成作用域的操作, 大概也就那个样子, 简化过

### 作用域

我之前比较想做的事情是将作用域和代码本身作为暴露给代码的操作的内容
因为, 比如 JS 新语言特性, 比如 `Object.observe`, `__proto__`,
还有 `Buffer`, `Stream` 等等, 就是暴露更底层 API 给语言使用
Continuation 和 Generator 则是把执行过程都暴露给语言了
那么, 作用域和代码可以在语言操作时, 我认为自由度会更大
虽然, 结果我只是在几个特例上得到了满足...

基本的操作是 `code` 保存代码然后 `eval`, 代码在 `test/feature/` 下有
```
set c $ code
  print (number 1)

print $ eval c
```

稍微复杂的是模拟函数, 需要考虑暴露原始的字符串, 会比从前的复杂
我的方案是暴露一个 `args` 数组记录两个参数的原始字符串内容,
由于函数作用域内能访问外层作用域 `outer`, 于是传入的数据就确定了
```
set pseudo-func $ code
  set a $ at outer $ at args $ number 1
  set b $ at outer $ at args $ number 2
  add a b

set num-a $ number 3
set num-b $ number 4

print $ call pseudo-func num-a num-b

pseudo-func num-a num-b
```

结尾的语法, 对 `pseudo-func` 作为函数开头写做了兼容, 其实是调用 `call`

随 `code` 传递的还有定义位置的作用域 `parent`, 用来模拟 `this` 指针
但 Cirru 没有规划过如何模拟各种不同编程范式, 这方面只能说是象征性的

### 其他特性

Cirru 计划里为了能日用有不少内容的

* 以及流程控制 [成形]
* 模块系统 [成形]
* JS 基本数据结构的封装 [成形, 难以使用]
* 作用域的操作和引用 [成形, 难以使用]
* 数值计算 [难以使用]
* 文件 [没做]
* JS 代码的调用 [没做]

不过我以前最想探索的几个特性拖这么久终于弄了, 后边反正会无限期拖下去
相应代码在 `test/` 目录下有, 至少我也写了几十行 Cirru 了

### 感想

不能编译到汇编从而让语言实现自举, 方向总是有问题, 况且我看起来啥都没做
通过 JS 函数完成调用和从汇编上完成调用还是有区别
没正经学过汇编表示压力很大.. 其次是推断类型的实现我一点概念都没有
我只看过 Parrot 文档初步了解动态语言虚拟机汇编, 但那是无法部署 Cirru 的
了解下底层的知识, 找一下自由度高的实现方案再说了...

Cirru 不是编程语言, 仅仅是脚本, 意味着追求表达能力而不是编写软件
代码正确当然是第一位的, 但严谨不是目标, 因为这是个探索
严谨的编程语言已经太多了, 而能取代 Bash 的语言很少很少
Coffee 语法已经简单到适合日用, 只是 Moon 和 Coffee 都有些严谨
如果编程不是一件有趣的事情, 那么除了钱不会有其他原因带来创造力了

另外一个问题是 Cirru 究竟能多大程度丰富我写代码的经验和理解呢?
通过实现想要的功能理解背后如何运行, 并接触那些技术..
可能吧, 仅仅是保持兴趣一直在编程上的手段, 没了兴趣恐怕是大麻烦