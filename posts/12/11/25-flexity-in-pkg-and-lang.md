
# 包的灵活性

看了几种 Scheme 方言后我在 [V2EX][v2ex] 发帖对比了一下几种 Lisp 的模块管理
算抱怨一直以来我对 Lisp 的不满, 虽然到底说什么价值的观点
一个平台想要方便, 语言之外, 模块管理工具的设计尤为重要
主流动态语言大多靠这特性而形成不能比拟的优势, 因为模块非常多
特别是模块编写的方便改善了许多创造力比研究更擅长的人们的开发环境

所以此前想过要给 Cirru 设计好的模块管理功能
当初的想法是, 既然我有了在线的编辑器, 很可能把所有的开发做在浏览器里
先不管这能不能成. 这个目标就是快速安装进行代码的调试
具体我还不会, 总体上应该只是数据库当作文件系统用的例子, 不会太难
后来我考虑是需要更多类型得跳出 JS, 纯粹浏览器端代码就不可行了

这些天看了些 Golang 入门的资料. 其中 [pkg 管理][go-get]让我眼前一亮
除了自带的包, Golang 可以用 `go get` 命令抓取 Github 等网站上的模块进行 build
原先我在想 Golang 怎样才能扩展其功能, 上传包的步骤会多么艰难
看起来 [pgkdoc][pkgdoc] 上的模块绝大部分都是托管在 Github 和 Google Code 等网站的
在 [Dashboard][dashboard] 也给出了选项让人提交模块的 repo, 而不是代码

对我来说这已经是个很奇妙的设计了, 因为 NPM 上的模块几乎都这样
对于 Cirru 我想参考这样的方案, 以便直接享有 Github 的方便
那么只要 `git clone` 相应模块, 然后编译, 事情就完成了
此外跟 Golang 一样, 要有个靠谱的索引. 否则寻找模块又将成为麻烦了

[v2ex]: http://v2ex.com/t/52511
[go-get]: http://tonybai.com/2012/10/25/go-package-distributing/
[pkgdoc]: http://go.pkgdoc.org/
[dashboard]: http://godashboard.appspot.com/

# 语法的灵活性

选择 Golang 目标会是为了自举, 毕竟 JS 不能算自举. 编译才是
脚本语言创造出什么, 估计需要宿主语言做相应的支持才行
比如 Lua, Chicken, Node 与 C/C++ 结合的紧密程度
我暗想 Cirru 会不会也要 Golang 做补充才能正常运行, 那就麻烦了
另一面, 如果能编译成二进制代码, 能摆脱关系那就再好不过了
其实说到底, Cirru 只能是 toy language, 不需要在这想什么

昨天写 Clojure 的资源页面, 我暗暗抱怨 HTML 设计多么糟糕
一般遇到问题, 不难的问题, 当人们能用简洁的思路给出, 就尽量简洁
比如 HTML 会有嵌套会有重复, 所有被重复的结构最终只要一次描述就够了
那么所在重复的概念实际上都要有被简化的能力, 特别是标记语言
体现在代码就是不同用户能分享代码, 简洁地引用模块
如果设计出一门新的语言甚至没有这样的方便, 不如手写 Golang 去

Lisp 一直成为有灵活的语法, 可我看 Lisp 不够灵活, 一方面是宏
宏的语法打破了花括号的简洁, 因为 Lisp 原先只要保证列表和字符串即可运行的
另一方面是 Lisp 不常作为脚本用, 因其向来不用来解决琐碎问题
Scsh 个人认为是好的方向. 问题在于, 过度纵容了花括号
Bash 成功在用难看的语法换来了高效, 而 Lisp 连括号都不肯放弃
总的说, Cirru 依然基于 Lisp 的语法而建立, 这是根基

漂亮的代码有一个麻烦在于单行长度, 特别如果是很长的字符串
通常语法里可以允许跨行的音好把问题解决, 可对 Cirru 就不合适了
需要拼凑碎片的语法将其完成. 还好不是太难的事情
但代码层叠在嵌套和行元素上的麻烦无法根除, 只能做些准备