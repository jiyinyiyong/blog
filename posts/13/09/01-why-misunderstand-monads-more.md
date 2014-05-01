
之前理解 Monads 出错的原因
======

### 空值的判断

有次项目代码遇到大量的 `if data?` 判断, 逐渐感到是代码的问题
因为我觉得代码应该抽象的话, 不应该每次用重复的代码去判断才对
而且 JS 里的判断空值相对麻烦, 我开始寻求好的代码模式来避免重复的判断
后来在[论坛上看 @luikore 讲 Haskell 用 Maybe Monad][reply] 来做这个的
当时觉得好像之前遇到过, 现在看来 do notation 的确带来这方面好处了

[reply]: http://ruby-china.org/topics/13225#reply5

于是找了些资料从这个切入点看懂 Maybe Monad 的用法.. 现在能看懂一点了
首先是生成一个 Maybe Monad 包裹的数据:

```haskell
myInt :: Int -> Maybe Int
myInt x
  | x < 0 = Nothing
  | otherwise = Just x

-- `Maybe` 类型有两类值, 一个 `Nothing`, 另一个是用 `Just` 封装的数据
-- 操作时通过 Haskell 的 Pattern Matching 分别判断数据
-- 比如我要个封装上的数据加上一个整数

myAdd :: Maybe Int -> Int -> Maybe Int
myAdd Nothing _ = Nothing
myAdd (Just x) y = Just (x + y) 

-- 后面我再用比较蹩脚的方案把内容打印出来

out :: Maybe Int -> IO ()
out Nothing = print "Nothing"
out (Just x) = print $ show x

main = out $ myAdd (myInt 3) 4
```

do notation 看来是做了隐式的转换, 对 `Nothing` 做了一些处理,

```haskell
a x = Just (x + 1)
-- a x = Nothing
-- 若 `a` 为 `Nothing`, 结果就变了
b x = Just (x + 2)
c x = Just (x + 3)
d x = Just (x + 4)

foo x = do
  x <- a x
  x <- b x
  x <- c x
  x <- d x
  return x

out :: Maybe Int -> IO ()
out Nothing = print "Nothing"
out (Just x) = print $ show x

main = do
  out (foo 1)
  print "end"
```

对这个的理解大概就是这样了. 估计还会有问题. 那评论吧...

### 理解的 Monads

已经花了很多时间在上边, 现在算初步有了解了, 可能还有问题, 先尝试写点
关于我看过的文章, 在 [coffee-js 的 Wiki 上][wiki]做了链接的记录
大多是通过 JS 描述 Monads 的文章, 因为 JS 相对更好懂一些吧
视频特别是 Brian Marick 和 Mark Grant (8th Light) 的介绍让我找到了方向
更详细的关于 Monads 的内容还要再学, 具体操作还是太难理解

[wiki]: https://github.com/coffee-js/languages/wiki/Monads,-articles-and-videos

Monads 的出发点才是关键的一环, 为什么要用 Monads 呢?
通常的解释是纯函数语言不允许有副作用, 因而需要用 Monads 模拟副作用
我的疑问是, Monads 怎么在纯函数的基础之上解决了这个问题呢?
如果有允许有复杂用了, 不允许有副作用的说法就存在问题了, 到底有没有副作用呢?
或者应该说, 副作用被包裹在 Monads 里边了, 就是进行了隔离

Haskell 里经常出现 Monads 的封装, 我很长时间不懂为什么要封装?
现在看来, Monads 主要是实现了命令式语言里原来通过语法生成的行为
命令式语言里顺序执行一行行的表达式, 在纯函数的语言里不被允许
**于是要强行封装成函数的样子, 下一条语句封装成传入当前语句的函数**
Node 的 CPS 风格有点类似, 可以作为解释的例子, 只是注意并不都一样
对比 Node 的回调, 很好理解为什么只要有 Monad 就不再是纯函数了

行为是传入的, 因此可以控制是回调执行, 或者任何需要的时候执行
比如异步的代码会在 Monads 中, 因为后续的操作和 Node 类似封装成函数了
并且执行过程中做些处理, 比如判断是否 `nil`, 就成了 Maybe Monad
而 List Monad 是在执行过程中增加了 `[]` 结构的相应操作
具体在 Brian Marick 的视频里很清晰, 我这里的表述大会有漏洞

[Mark Grant][mark] 的视频里用 CoffeeScript 对 Maybe Monad 等进行构造
至少看他的演讲比看博客上能更明白点为什么需要加这样的封装
可惜视频不够清晰, 他的幻灯片和个人网站都不方便找到.. 看起来比较累
而 "Dont fear of the Monad" 基本就在讲数学, 学了数学再看吧免得想歪了

[mark]: https://github.com/mg50

### 概括一下

今天弄懂了一些以前不明白的代码, 写了一些用来理解的代码
https://gist.github.com/jiyinyiyong/6403773
看起来质量很低.. 等纠正... 不过算是我第一次用 Monad 了
而且强类型语言在写代码时要思考类型的对应, 就算 Haskell 自动推断类型, 还是要想
我用 JS 都没这个意识. 脚本语言让编程更方便, 同时犯错很方便
通常写原型最多千行的代码, 能接受脚本的不严谨, 因为动态语言用来随时改的
应用再大, 我想思路该变了.. 总之要严谨吧

鉴于我描述的 Monads 是基于个人理解, 不能保证准确性
建议查看我 [Wiki][wiki] 里引用的文章, 还有下边的链接来具体了解 Monads
http://www.haskell.org/haskellwiki/Monad_tutorials_timeline