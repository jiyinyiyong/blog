
## Sublime 写语法高亮一点尝试

[下午按着文档尝试了一下 Sublime 的语法高亮配置][highlight]
高亮关系到 `.tmLanguage .tmTheme`, 两个文件, 而是 XML 的文件格式
采用 XML 似乎是为了兼容 TextMate, 文档里也有内容指向 TextMate 的文档的

实际写的话, 前者需要先安装 [AAAPackageDev][aaa] 这个包
然后在 "Tools > Package > P.... > New Syntax ..." 选中生成文件
再保存在 `Package/` 下一个目录里, 然后按语法写好, 再找到菜单把 JSON 编译成 XML

我遇到的问题是两个菜单都是不存在的, 第一个参见[这个 Issue][issue1], 下载新的版本
第二个菜单在按下 `F7` 之后能在菜单里找到 `Property List` 相关的条目, 勉强

关于写的内容. 对应到 `.tmTheme` 的内容, 但是网上偏偏找不到 Theme 的文档
当然, 有很多模板可以参考, 我对比了两个文件觉得还是 JSON 生成的才对
语法文件用 Perl 的正则匹配出字符串, 再标记成一个 Theme 里定义过的标记
我从默认的 Monokai Theme 里找出一些标记填上了, 勉强能用

下面是我尝试的 JSON, 注意是 **尝试**...
```json
"patterns": [
    {
      "match": "\\d+",
      "name": "constant.numeric.source.she",
      "comment": "number"
    }, {
      "match": "\".*\"",
      "name": "string.source.she",
      "comment": "string"
    }, {
      "match": "'.*",
      "name": "keyword.source.she",
      "comment": "string"
    }, {
      "match": "^\\s*\\w\\S+",
      "name": "support.function.source.she",
      "comment": "string"
    }
  ]
```
我没有做出完整的 Theme, 另外, keymaps 和 setting 还是失败的

[issue1]: https://github.com/SublimeText/AAAPackageDev/issues/19
[aaa]: https://github.com/SublimeText/AAAPackageDev
[highlight]: http://docs.sublimetext.info/en/latest/extensibility/syntaxdefs.html

------

另外, 关于快捷键映射, [我在 Ruby 中文发帖求助了一下][ruby], 最后明白了
后面把 [Scheme Package][scheme] 再整了一遍, 大致原理是可行的
具体联系文档和之前的 [Issue][issue] 看, 不多解释了

[issue]: https://github.com/masondesu/sublime-scheme-syntax/issues/1
[scheme]: https://github.com/jiyinyiyong/She.sublime
[ruby]: http://ruby-china.org/topics/6746