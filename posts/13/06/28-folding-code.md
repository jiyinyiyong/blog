
Sublime 折叠代码的
------

### 快捷键

折叠展开代码的快捷键是 `Ctrl + Shfit + [` 和  `Ctrl + Shift + ]`
单这组命令并不怎么实用, 因为憧憬需要定位光标才能折叠
然后看到今天这个介绍, 可以通过 `Ctrl K 然后数字` 来制定缩进的层级进行折叠
http://wesbos.com/sublime-text-code-folding/
`0` 对应的全部展开, 有了这个快捷键, 折叠全部代码查看就方便多了

搜索中看到一个 [BufferScroll 插件][plugin]可以用来保存相关的折叠信息
http://stackoverflow.com/questions/11369071/how-can-i-save-text-folds-and-folded-code-block-data-to-sublime-workspace
[plugin]: https://github.com/titoBouzout/BufferScroll

BufferScroll 的配置是要到菜单里单独看的, 不能搜索有点麻烦
具体配置看 Github 上的文件示范,
https://github.com/titoBouzout/BufferScroll/blob/master/BufferScroll.sublime-settings
中间有个 `typewriter_scrolling` 可以让高亮行尽量呈现在屏幕, 虽然不能么实用...
还有个 `synch_scroll` 说是在不同的 View 之间同步代码, 也许有用
