
Grunt 插件的一些笔记
------

写插件比改 Bug 有意思多了, 毕竟 Grunt 没有时间深入
这次完成的是编写过程测试部分, 插件现在还没有在正式环境测试
有几个从前尝试没有弄清楚的地方:

`grunt.task.loadTasks 'tasks'` 这样本地测试是可行的
我参考 `grunt-contrib-coffee` 插件完成了具体的写法
这条表达式将会读取当前目录的 `tasks/` 目录下的文件作为命令
调试时我在 `Gruntfile.coffee` 里这样写就好了
实际环境中 Grunt 怎样读取并不清楚
总之这不是 Node 常规的做法, 不知道出于什么考虑

完整的插件见 https://github.com/jiyinyiyong/grunt-deploy-with-md5
