
## 写一个 Lua Rock

昨天在犹豫要不要用 Lua 写一个遍 Cirru, 趁断网看了 rocks 的文档
中间走了很久弯路, 另外也暂时放弃用 MoonScript 写 Cirru 的念头
Lua 语言有很多我在 JS 中得不到的特性, 但用来做原型还是继续 Node 吧
看看 Go 我是学不会的, 只能期待别人在原型基础上增强 Cirru 了
也许一辈子困在 JS 里出不去了我

这里会记录一些写 Rocks 的要点, 因为我发现文档不够友好
官方的文档写的很简练精确, 大概是 Lua 一贯的作风
一份是创建 Rock 的过程, `.rockspec` 的例子在里边也出现了
http://luarocks.org/en/Creating_a_rock
再就是 Rockspec 具体参数的意思, 手册里详细做了说明
http://luarocks.org/en/Rockspec_format
另外 Rockspec 有 MoonScript 和各种 Rock 的例子可以参考
https://github.com/leafo/moonscript/blob/master/moonscript-dev-1.rockspec
http://luarocks.org/repositories/rocks/

Luarocks 是 Lua 一种包管理工具, NPM 与之相似度很大
Lua 另外有 LuaDist, 从模块上说不如 rocks 多, 我也没具体了解
Lua 用 `require` 加文件名进行引用, 得到一个 table, 具体参看
http://lua-users.org/wiki/ModulesTutorial
和 Node 不同的是 Node 中 `exports` 作为对象返回
而 Lua 将文件中没有指定为 `local` 的变量返回
另外 MoonScript 中通过手动 `export` 声明将要返回的数据

### 最终成功的版本

尝试了很久才成功的, 基本满足需求了, 看文件树:
```
➤➤ tree
.
|-- cirru-1.0-1.rockspec
`-- src
    |-- cli.lua
    `-- eval.lua

1 directory, 3 files
```
然后是 Rockspec, 注意文件名的格式, 需要有 `-1` 这样表示 Reversion,
本地安装主要是 `build` 部分, `source` 部分大概在仓库上用到
```
package = "cirru"
version = "1.0-1"
source = {
  url = "http://jiyinyiyong.github.com/cirru.lua"
}
description = {
  summary = "Cirru is a toy language.",
  detailed = [[
    with merely several syntax rules.
  ]],
  homepage = "http://jiyinyiyong.github.com/cirru.lua",
  license = "MIT"
}
dependencies = {
  "lua >= 5.1"
}

build = {
  type = "builtin",
  modules = {
    ["cirru.eval"] = "src/eval.lua"
  },
  install = {
    bin = {cirru = "src/cli.lua"}
  }
}
```
`buildin` 是指 Lua 或 C 模块, 此外这里可以是 `make`, 我就算了
`modules` 是模块, 可以是 C 和 Lua, 可以被外边引用
`install` 是命令, 最终会安装一个 `cirru` 命令到 `/usr/bin/`
看下 `src/cli.lua` 具体的文件内容:
```lua
#!/usr/bin/env luajit

eval = require "cirru.eval"
eval.foo()
```
还有 `src/eval.lua`, 注意表明模块的名字:
```lua
module("cirru.eval", package.seeall)
function foo() print("Hello World!") end
```
然后运行 `sudo luarocks make` 将其安装, 就有了 `cirru` 命令
这里的 `cirru` 命令执行时会打印一个 `Hello world` 字符串

### 关于 Luarocks 仓库

一般 `sudo luarocks install lpeg` 这样即可安装来自仓库的模块
或者 `luarocks install lpeg --local` 安装模块到 `~/.luarocks/` 下
如果是后者, 那就要修改 `$PATH` 变量使命令能被获取到

`luarocks` 我没看到上传模块的命令
大概上传只需要一个 `.rockspec` 文件就能成功了
前几天看到 MoonScript 作者上线了一个 MoonRocks 网站
修改了 `config.lua` 文件之后就可以使用了
```lua
➤➤ cat /etc/luarocks/config.lua 
rocks_trees = {
   home..[[/.luarocks]],
   [[/usr]]
}
rocks_servers = {
  "http://rocks.moonscript.org/",
  "http://www.luarocks.org/repositories/rocks"
}
```
http://rocks.moonscript.org/
但我在微博上还有 Google 看了下, 用 Rocks 的人似乎不多
弄不懂怎么回事, 对我显然不是什么好的事情
或者 Lua 就是那么一门沉静的语法, 不会去做什么激进热闹的事情

### 对比一下 Go

Golang 的模块跟 Lua 又不同了, 弄明白了还是蛮简单的
先要指定一个 `$GOPATH` 所有代码和文件都放到那里:
```
➤➤ c $GOPATH
bin/  pkg/  src/
```
还要设置 `$GOBIN` 这样一个变量, 可以用在 `$PATH` 的索引位置
```
➤➤ go env
GOARCH="amd64"
GOBIN="/bin"
GOCHAR="6"
GOEXE=""
GOGCCFLAGS="-g -O2 -fPIC -m64 -pthread"
GOHOSTARCH="amd64"
GOHOSTOS="linux"
GOOS="linux"
GOPATH="/home/chen/kit/golang"
GOROOT="/usr/lib/go"
GOTOOLDIR="/usr/lib/go/pkg/tool/linux_amd64"
CGO_ENABLED="1"
```
代码存储在 `$GOPATH/src` 目录下, 比如 `$GOPATH/src/my/go-demo`
```
go install my/go-demo
```
运行命令后就在 `$GOPATH/bin` 或者 `$GOPATH/pkg` 下生成文件了
大概取决于源码里声明的是 `package main` 或者什么之类

Golang 模块以 Github 或其他网站网址这样的方式安装
Rocks 有类似, 就是写在 `source` 参数里可能会自动抓取
而 NPM 的话则是 `git clone` 然后 `npm install`, 也挺不错
通过在代码托管网站方代码已经是常态了, 想来也是趋势
但 Node 有一套很顺手的工具, 可能是 Python Ruby 那学的, 也算优势
