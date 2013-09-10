
Fish-Shell 的尝试
------

对 Shell 我的期望不太高, 毕竟纯文本闹不出什么花样, 界面最后还是要淘汰的
Bash 一类古怪语法, 学了会增加以后 unlearn 的成本, 我这种智商还是别碰吧
这是我对  Shell 大概的态度, 但完全没有 Shell, 还是会觉得难以忍受
比如 Chromebook 上死活想用上自己熟悉的操作方式的时候, 没有 Shell 又不成
只是现在对 Shell 能期待的, 也就是命令行上能顺一点锦瓷而已了

以前找 Bash 替代的时候找到过 [Fish][fish-shell], 安装尝试了, 觉得界面挺漂亮的
只是具体的配置不懂, Bash 命令直接用过来不能正常跑, 于是放弃了
包括后来的习惯也是直接到网上找 Bash 命令去尝试, 结果配置不成功
比如设置环境变量, 定义函数, 修改 prompt 颜色这些. 决定了 Shell 好不好用
当然 Fish 智能快速的提示给我留下了很深的印象

[fish-shell]: http://fishshell.com/
![Fish](http://ww3.sinaimg.cn/large/62752320gw1e8hf0xy5aaj20lw0f03zx.jpg)

前几天为了翻 Shell 的例子找出来 Fish, 结果还返出来 [oh-my-fish][oh-my]
之后又翻出来 [fishmarks][fishmarks], 突然觉得使用的障碍低了不少
因为我非常依赖 [bashmarks][bashmarks] 的跳转, 如果 Fish 有习惯就比较快了
于是我装上 Fish 又玩了下, 这次的感觉好多了

[oh-my]: https://github.com/bpinto/oh-my-fish
[fishmarks]: https://github.com/gonsie/fishmarks
[bashmarks]: https://github.com/huyng/bashmarks

![](http://fishshell.com/assets/img/screenshots/autosuggestion_thumb.png)

Fish 的自动补全比 Zsh 夸张很多, 效果比较炫, 出现的种类也很多
我输入第一个字符的时候 Fish 已经根据 history 提示出补全了
或者命令刚输入使用 Tab 可以列表补全的命令, 有些还带注释
因为 Fish 定义函数时就带有注释, 因而好多地方是有注释可看的

```bash
function demo -d 'this is a demo'
  echo 'by demo function'
end
```

另外命令输入时, 不存在时字符为红色, 存在时命令显示为蓝色
对于参数, 当对应的文件存在时, 参数会显示出下划线, 提示文件存在
存在提示时, 方向键上下选择, 会在历史里进行搜索, 虽然不是头部匹配..
当然这个提示主要基于历史, 不像 Sublime 的 Command 那么好用的

![](http://fishshell.com/assets/img/screenshots/colors_thumb.png)

Fish 界面颜色算是非常艳的, 比 Bash 开启强制颜色要炫多了, Zsh 不知道..
比较让我意外的一点是 Fish 设置里支持 RGB 颜色值
之前在 Bash 和里调颜色, 要对付 escape 字符, 又不会, 头疼死了
Fish 里, 比如我在用的 prompt 用的颜色, 就是几行 RGB 颜色就写好的

```bash
function fish_prompt
  set_color 23F
  printf '➤➤ '
  set_color normal
end
```

只是说所谓 Shell, 还是有大量的 escape 字符存在, 我觉得头疼

![](http://fishshell.com/assets/img/screenshots/scripting_thumb.png)

Fish 的语法相对 Bash 友好多了, 基本上是动态语言常见的 token
函数参数的处理, 这里是一个 `$argv` 变量, 相对好懂..

```bash
function ll
  ls -l $argv
end
```

Fish 的 [Tutorial][tutorial] 其实停好懂的, 相对内容也简单
至于 [Manual][manual] 我现在恐怕没有心情看, 好长.. 总之印象比 Bash 要好多了

![](http://i.minus.com/jq1OuTCg12GE0.png)

[tutorial]: http://fishshell.com/tutorial.html
[manual]: http://fishshell.com/docs/2.0/index.html