
Cirru 编辑器重写的感受
------

回到家这几天, 大学好绝望, 而且从没能很专心学东西过, 所以代码很慢
只是写了下, 感受良多. 而且边写边搜 jQuery 的 API 感觉不错
之前 fork nodeclub 的界面时被其中几行 jQuery 打动了
比如用 `.parent()` 用 `.find()` 在 DOM 里徘徊都是之前我没接触过的
https://github.com/jiyinyiyong/nodeclub/blob/master/views/topic/index.html#L195

```js
var editor = $btn.parents('.reply2_area').find('.reply2_editor');
editor.show('fast');
editor.find('textarea').focus();
var user = $btn.parents('.reply2_item').find('.reply_author').find('a').html();
var textarea = editor.find('textarea');
```

我所有的知识来源无非论坛, 新闻和搜索, 遇事也只好自己对付
那么摸索了最后自己能抱一个什么样的目标呢? 我一再一再惶惑
Cirru 是插曲, 本想设计很先进的聊天室等人去实现的, 可聊天室没动静
Cirru 只想未来能成就语言, 算我在赌一个未来, 人们接受自动管理括号么?
上一次尝试, 两个月前, 做得比较多, 详细的想法当时有记录:
https://github.com/jiyinyiyong/code_blocks/blob/gh-pages/about.md

关于代码, 主要是设置当前元素 `contenteditable = true` 来提供编辑能力
然后用 jQUery 不断调换 `editable` 绑定元素, 比如在响应事件时
嵌套关系映射在这里其实是 DOM 里的嵌套, 最后的 `parse()` 也是这么想的

```coffee
$ ->
  editable = 'contenteditable'
  caret = "<code id='target' #{editable}='true'/>"
  blank = ['', '<br>']
  paste = ''
```

正在编辑的元素标记名称为 `#point`, 另外 `#target` 和上面的 `caret` 对应
我重写的方案是在移动 `#point` 时不先移动, 而是先绘制一个 `#target` 作为目标
再调用 `point()` 将完成这一步转化

```coffee
  p = -> $ '#point'
  t = -> $ '#target'

  empty = (elem) -> elem.html() in blank
  root = (elem) -> elem.parent().attr('id') is 'editor'
  exist = (elem) -> elem.length > 0
  leaf = (elem) -> elem[0].tagName is 'CODE'
```

上面四个函数用来判断节点具体的位置, 具体用到时逻辑比较繁琐
`point()` 接收的参数只是为屏蔽 `click` 一次多余的 `focus()`, 意义不大
函数目标是将 `#point` 取消标记, 如果为空, 还要递归地将空元素删除
不过 `#point` 在 `delete` 时会强制删除, 因而可能元素已经不存在了

```coffee
  point = (refocus = yes) ->
    old = p().removeAttr('id').removeAttr editable
    if exist old
      old.html (old.html().replace /\<br\>/g, '')
      old[0].onclick = (e) ->
        old.attr('id', 'target').attr(editable, 'true')
        point off
        e.stopPropagation()
      while empty old
        up = old.parent()
        old.remove()
        old = up
        if root old
          if empty old then old.remove()
          break
    t().attr('id', 'point').attr(editable, 'true')
    if refocus then focus()
```

聚焦主要是处理怎样将光标放在字串结尾, 代码是搜索抄的, 不清晰
当时写着一遍测试 `collapse()` 不同参数的效果, 很不安全的代码
StackOverflow 的代码解释不够清晰, 没看懂只能带过了
`.inline` 是为了将单层的括号放在行内, 本想用 css 选择器, 最后换 jQuery

```coffee
  focus = ->
    sel = window.getSelection()
    sel.collapse p()[0], 1
    $('div').addClass 'inline'
    $('div:has(div)').removeClass 'inline'
    p().focus()
```

初始化最初的光标, 并指定 `click` 能将光标聚焦
`in_sight` 是光标是否聚焦的状态, 打算包装成 lib, 可能用到

```coffee
  $('#editor').append caret
  t().attr 'id', 'point'
  focus()
  $('#editor')[0].onclick = (e) ->
    focus()
    e.stopPropagation()
    parse()

  in_sight = yes
  $('#editor').bind 'focus', -> in_sight = yes
  $('#editor').bind 'blur', -> in_sight = no

  $('#editor').keydown (e) ->
    # console.log e.keyCode
    if in_sight
      switch e.keyCode
```

回车键创建嵌套, 跳出当前 `#point` 在后嵌入 `#target` 而已
Tab 就直接谁知 `#target` 就好了

```coffee
        when 13
          p().after "<div>#{caret}</div>"
          next = p().next()
          next[0].onclick = (e) ->
            next.append caret
            point()
            e.stopPropagation()
        when 9 then p().after caret
```

删除时默认落到前一个字串去, 没有前就往后, 再没有就尝试删除嵌套
当然向前向后遇到嵌套的话要进入到嵌套当中去

```coffee
        when 46 # key delete
          if exist p().prev()
            it = p().prev()
            if leaf it then it.attr 'id', 'target'
            else it.append caret
          else if exist p().next()
            it = p().next()
            if leaf it then it.attr 'id', 'target'
            else it.prepend caret
          else unless root p()
            p().parent().after(caret).remove()
          else unless p().html() in blank then p().after caret
          else return on
          p().remove()
```

上下键按字串跳, 遇到嵌套也会自动进入/退出

```coffee
        when 38 # up
          unless p().html() in blank then p().before caret
          else if exist p().prev()
            prev = p().prev()
            if leaf prev then prev.attr 'id', 'target'
            else prev.append caret
          else unless root p() then p().parent().before caret
          else return off
        when 40 # down
          unless p().html() in blank then p().after caret
          else if exist p().next()
            next = p().next()
            if leaf next then next.attr 'id', 'target'
            else next.prepend caret
          else unless root p() then p().parent().after caret
          else return off
```

剪切粘贴的实现比较粗糙, 快捷键绑定在 Chrome 里没多少键可指定
幸而有 `.outerHTML` 这个属性, 否则实现起来更麻烦了

```coffee
        when 219 # ctrl + [
          if e.ctrlKey and (not (root p()))
            up = p().parent()
            up.after caret
            point()
            console.log up.parent()
            paste = up[0].innerHTML or ''
            up.remove()
          return on
        when 221 # ctrl + ]
          if e.ctrlKey and paste.length > 0
            p().before paste
          return on
        when 33 # pgup
          unless root p() then p().parent().before caret
          else return on
        when 34 # pgdown
          unless root p() then p().parent().after caret
          else return on
        else return on
      point()
    e.stopPropagation()
    off
```

为了阻止键盘事件副作用, 上面有比较多的 `return` 来处理逻辑
`.stopPropagation()` 方法是 `click` 用的, 这边没必要
不过此前尝试多种尝试组织冒泡都没成功, 这个方法是很随意的了

```coffee
  parse = ->
    map = (item, b) ->
      if leaf [item] then item.innerText
      else [$.map item.children, (x) -> map x]
    res = $.map $('#editor')[0].children, map
    console.log 'res:', res
```

`parse()` 函数没完. 其中很奇怪, 对 DOM 用 `map` 很奇怪
`else` 那儿添加的 `[]`其实我很困惑, 按列表的操作那是不该有的呀
都是调试时候无奈写的代码, 不知道怎么改, 暂时是可以读出内容的

按计划, 后面应该写自动补全提示了的, 可整天打不起精神
如果事成, 我把 js 部分打包成接口放在 gh-pages , 再到别的项目调用
比如写个代号 `feather` 的 Shell 的图形版, 用 Node 写系统脚本
设置扩展到向数据库存取 Cirru 生成的文本的功能, 为模块做准备
但最大的问题是怎样设计语言, 心里没底, 的确, 表达式解析是不够的
现在能做的只是生成 JS, 大家都做的, 但我手头学过的技能并不够

而且最大的问题是我做怎样一门语言呢, 都已经缺失了各种文本工具了
`import` 是最头疼的功能, 我打算是从数据库调用, 然后加到作用域里
还有从网络上 import 的功能, hamony 版本记得是有说到的
但我设计的语言恐怕会和 JS 有不孝的差异, 直接用 JS 问题不会少
做不难, 只是持续前进的动力和光明在哪里?
