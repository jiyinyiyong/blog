
设计语法的一些感想
---

这些天也能感到越发拘束了, 上着网, 不知道该去做什么, 而且没动力
暗想过时隔一年, 有必要接下去看 Haskell, 另外还得过一遍 SICP, 但, 没精神a
我也想着早些把 `coffee.cn` 首页拼出来, 反正代码量很小, 也是没精神
下午想了下找到了些思路去设计语法, 花时间梳理了一下, 样例的代码
https://github.com/jiyinyiyong/cirru-editor/blob/gh-pages/compile/source.cr
还有用 coffee 写的, 到目前我只能把字符串打碎成为列表, 后边还不行
http://jiyinyiyong.github.com/cirru-editor/compile/array.html

我原先计划是把编译到 JS 的过程分为三歩, 第一步已经完成, 就是生成数组
然后对数组进行整理, 根据语法再厘清嵌套, 能得到比较清晰的树
再把树设计得更规范些, 以便在其他程序里重用. 用于生成 JS 代码
我没学会规范的 AST 解析和处理比较取巧, 而且这样生成代码也没好的调试功能
其中空格和 `()` 的处理我为一些原因弄得很不规范, 因此重用未必可行
这样思考了一遍, 关于代码的语法和宿主语言依然大同小异
毕竟底层的逻辑和写法是那样, 很难想想还能去创建一种新的思维方式

对于在缩进的同时使用括号进行分隔, 这种重复, 我依然深恶痛绝的
包括 C 风格的花括号, Ruby 的 `end` 还有 Python 和 Lisp 执行函数的圆括号
因为缩进已经带来了一层语意, 而人们却任由括号污染视野, 这是我疙瘩的
Lisp 的优雅在于其语法的简洁和抽象的强大, 是 coffee 难以媲美的
可芥蒂在于缺少 npm 一类包管理的方便, 特别还因为大量不修饰的括号
我想仅凭自动生成括号来简化, 但还是有几处比如 macro 和字符串破坏了语法

为什么要语法简洁, 首先, 学习记忆和转移的成本减小, 编程的目的是为解决问题
其次, 繁多的语法在人记忆时增加了规则有时遇到问题会不知所措
主要的精力不应消磨在怎样能让代码清晰和便于阅读和管理上
足够简单并且清晰的规则可以让这个世界运转得更加流畅
就像大千世界我总想找到最简的规律一样, 我期待流畅, 不愿看规则冲突
简洁于是不再向别处怀疑是否有错, 甚至茫然去寻找错误

我调试着自己写好了分解列表的代码, 也大致想了怎样才列表生成代码
当看清了这一条可行的路子, 我连想到挖掘世界运行的规律一直是当初我的懵懂
或许世界是很神奇的, 但这时我们能看到其中可以一步步有机械解释的规则
就像听懂口语, 就像眼睛辨认物体, 一切非常难以想象但又切实可行
那种感觉是, 在纷繁复杂的世界, 看到了万物运行的规律, 一种超脱的梦想
同时口语的复杂和灵活, 也让人开始为之着迷, 当然, 其中显然也有着规律

关于设想的语法的解析, 看几个例子, 这里 `_` 和 `-` 符号交换了的

```coffee
a = 1 + (2 _ 1)
```

实际操作我会先把括号内容转变为列表, 并且语句将根据空格打散, 省略了引号:

```coffee
[a = 1 + [2 _ 1]]
```

再处理这个列表时, `=` 将先被识别出来, 并再次形成嵌套

```coffee
[a = [1 + [2 _ 1]]]
```

那么用递归的表达式处理, 语句将被可行地编译成 JS
其中重要的是关键字的识别以及优先级的确定, 这里简化过了

然后复杂一些, 也是先识别一个部分形成嵌套, 嵌套再递归, 如此:

```coffee
re = a case 1 (" one) case 2 (" two) else (" else)
re = 1 == 1 then a + b else 1 == 2 then " 2
```

出于语法的多样, 实现时候需要不少的花招才能保证顺利
不过大体思路已经完成了, 什么时候有功夫了再想法子实现一下
