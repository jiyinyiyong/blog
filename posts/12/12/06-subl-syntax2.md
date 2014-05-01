
## 继续看关于 Sublime Text 语法高亮的文档


为了给 [Goose][goose] 增加可用的语法高亮, 我昨天又尝试看了下文档
官方给出的主要是两份. 是在说不上详细
http://docs.sublimetext.info/en/latest/extensibility/syntaxdefs.html
http://docs.sublimetext.info/en/latest/reference/syntaxdefs.html
我折腾了很久 Golang 在 Sublime 里默认的 `.tmLanguage` 文件都失败了
慢慢注意到其中的 `include` 有类似 PEG.js 的语法树形式
之后看到 `begin` `end` `capture` 终于有点思路了, 这在上边的文档上有的

[goose]: https://github.com/jiyinyiyong/Goose.sublime

另一个问题是 [AAAPackageDev][aaadev] 插件的问题, 之间一直处在不可用的状态
按 Issue 里的说法, 只有用 Folk 的 [enhanced_conversion][enhanced] 分支才是可用的
实际上我的在 Arch 上切换到该分支也没有成功, Ubuntu 上可以
同时 Sublime 的版本都是 dev 2220, 没有找到问题关键所在
上回就是因为 AAADev 不可用才放弃的, 于是昨天用 `sshfs` 挂载继续尝试了

[aaadev]: https://github.com/SublimeText/AAAPackageDev/issues/19
[enhanced]: https://github.com/FichteFoll/AAAPackageDev/tree/enhanced_conversion

貌似文档上最有用的几句话就是他兼容 TextMate, 相关主要是这篇:
http://manual.macromates.com/en/language_grammars.html
我一个不明白 `patterns` 里的 `name` 对应的什么, 设置和 Theme 怎么也能对应
在这里的 `12.4 Naming Conventions` 我找到了想要的内容, 果然有规定的结构
于是主要用正则匹配出来, 再给出对应的 `name`, 就能对应高亮了
当然, 具体到主题里哪些会是怎样的高亮, 不能立马知道怎么回事

另外 TextMate 上的正则注意会用到 `\b`, 其他我没细看了
http://manual.macromates.com/en/regular_expressions#regular_expressions

### 梳理一下

首先如果你的 Ubuntu 上的 Sublime 并不一定能正常运行这个包
正常的话, 可以手动下载并切换到该分支:

```
cd ~/.config/sublime-text-2/Packages/
git clone git://github.com/FichteFoll/AAAPackageDev.git
cd AAAPackageDev/
git checkout enhanced_conversion
```

`Tools > Packages > Pacakage Development > New Syntax Definition` 应该是可用的
点击后生成一个 JSON 语法的文件, 要保存到 `Packages/` 目录下
比如创建 `Goose/` 文件夹保存在里面, 对应的后缀是 `.JSON-tmLanguage`
然后按下 `F7` 有 `Build: Property List` 的选选项, 或者 Palette 里直接搜索
如果 JSON 文件已经编辑好, 就会生成一个 XML 文件
通用将其保存在 `Packages/Goose/` 文件下, 后缀是 `.tmLanguage`
Sublime 会马上识别, 并生成一个 `.cache` 文件, 说明文件开始起作用

### 语法文件的编写

语法文件用 JSON 的语法, 容易出错, 但比 XML 本身好很多了
有限 `name`, 它的值在识别文件后缀后会显示在状态栏最右, 对应语法的名称
再 `scopeName`, 一般是 `source text` 开头, 加上后缀, 这里我不懂..
后面的 `fileTypes` 数组写的是文件后缀, 但我觉得和上边功能重复到
`patterns` 里里所要匹配的规则, 一般 `match` 写正则, 再给出 `name`
其中 `name` 对应上边 TextMate 文档里的语法的 scope

除了 `match`, 用 `begin end` 写正则也能进行匹配, 用在注释之类跨行的位置
还有是 `captures`, 可以匹配语句, 对其中的子项目分别标记不同的 scope
按文档, 有 `include beginCaptures` 等高级的语法可用
我只尝试了简单的手法, 没有处理好正则相互之间的顺序.. 只当探路
