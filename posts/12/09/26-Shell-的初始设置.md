
### Shell 的初始设置

这两天遇到创建新用户, 记得以前 `useradd` 命令会交互式提示输入内容的
不过这几次在服务器遇到都没有提示输入具体内容了, 可能是参加吧
这样会遇到几个问题:

1) 默认的 Shell 是 `/bin/sh` 而不是 `bash`
这样的话方向键会失效. `<tab>` 失效, 当然应该会有其他问题
解决方案是在 `/etc/passwd` 里把对应用户的 `shell` 改成 `/bin/bash`

2) 没有用户主目录. 这个添加即可, 还有用 `chown` 修改权限

3) 没有 `.bashrc` 的配置. 这样很多 shell 常用的功能用户起来
我一般用 `scp` 复制到主目录, 然后重新登录
如果还不行就是脚本没有被加载. 还要在 `.bash_profile` 添加脚本加载

4) 没有 `sudo` 权限. 这个当然是 `root` 权限才能改
服务器一般有 `root` 用户, 相对比较放心, 修改错了用 `root` 进入更改
或者, `sudo` 权限可能是给一个组的. 那么就要加入组
用 `gpasswd -a [name] [group]` 可以完成添加
我发现添加到组之后, 用 `sudo` 的话还是要 `root` 的密码, 而不是自己

5) 自动登录, `ssh` 生成密钥, 然后加到 `authorized_keys` 文件
注意权限, 我出于方便记忆, 用了 `600` 修改这个文件
退出后登录即可

发现 `mosh` 用 `ssh` 的配置在服务器上也快速登录了, 这个好
从完成了 Arch 的安装之后, 我渐渐能感受到 Linux 的知识开始串在一起
当然在这个时候值得再花费一些时间在回溯一遍 Linux 教程了
