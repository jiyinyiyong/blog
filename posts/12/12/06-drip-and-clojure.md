
## drip 和 lein 的配置(failed)

昨天看到 `drip` 命令说能提速 JVM 启动, 顿时有兴趣了 https://github.com/flatland/drip
安装 readme 上安装 drip 很快, 然后就是用下面的命令启动
```
drip -cp clojure.jar clojure.main
```
于是我到 [Clojure 的 Downloads][http://clojure.org/downloads] 里重新下载了 Clojure
正常解压后是作为 Java 启动的
```
java -cp clojure-1.4.0.jar clojure.main
```
现在用 `drip` 启动, 因为 Java 一直跑着, 启动速度就在后边几次打开加快了
```
drip -cp clojure-1.4.0.jar clojure.main
```
另一个是 Clojure 主要环境是 `lein`, 就需要 `lein` 上加速
起初看了 Github 上的 Issue, 知道是配置参数里事 https://github.com/flatland/drip/issues/35
邮件列表有更早的帖子在说 lein 命令不能加速, 还打开了多个 java 进程
https://groups.google.com/forum/?fromgroups=#!topic/clojure/FWIM-akbEL8
后来才弄明白, preview10 的版本依然不支持 https://github.com/flatland/drip/issues/36
具体要安装 Master 版本, 写在 Wiki 里了 https://github.com/flatland/drip/wiki/Clojure

于是我开始 build master branch 的 leiningen, 参考 leiningen 的 README:
https://github.com/technomancy/leiningen#building

装好之后在 `~/.lein/leinrc` 添加代码
```
LEIN_JAVA_CMD=${LEIN_JAVA_CMD-drip}
```
结果是有时能加速, 有时不能.... `ps aux | grep java` 还是有多个进程在跑.. 3~6 个徘徊