
ssh config 文件配置等近期琐碎配置
------

补考前一天晚上正好 Robin 来办公室配置他的电脑
我看到他的 `~/.ssh/config` 配置就跟他学了那一段配置
大概意思是为 host 取别名, 并设置具体的信息方便登录
文件内容:

```
host info
user jiyinyiyong
hostname jiyinyiyong.info
port 22
identityFile ~/.ssh/id_rsa
```

更多细节可以参考下面链接:
http://www.lainme.com/doku.php/blog/2011/01/%E4%BD%BF%E7%94%A8ssh_config
http://www.csser.com/board/4f53875c55bdcb545c000d05
命令行工具往往隐藏了好多技巧, 要发现还是不容易的
虽然, 其中很多的确不够实用:
http://heikezhi.com/2011/08/26/ssh-productivity-tips/


再有我在服务器配置 Nginx 的 Node 反向代理遇到了问题
原先我只是抄的网上的配置例子, 他看了以后做了简化
虽然发现 Nginx 没跑起来, 但配置文件我做一下记录:

```nginx
server {
  listen 80;
  server_name linux.domain;
  access_log /var/log/nginx/linux-club.log;
  error_log /var/log/nginx/linux-club-error.log;
  location / {
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header Host $http_host;
#   proxy_set_header X-NginX-Proxy true;
    proxy_pass http://127.0.0.1:3000;
#   proxy_redirect off;
  }
}
```

后来他直接给配了 Apache 作为反向代理了, 网站是可以访问的
此前我还以为只有 Nginx 能搭配 Node, 对反向代理缺乏了解

```apache
<VirtualHost *:80>
      ServerName linux.domain
      ServerAdmin jiyinyiyong@qq.com
      ProxyPass / http://127.0.0.1:3000/
      ProxyPassReverse / http://127.0.0.1:3000/

     <proxy  http://127.0.0.1:3000>
      AllowOverride None
      Order Deny,Allow
      allow from all
     </proxy>
</VirtualHost>
```

另外 Node 现在尝试用 `forever` 命令跑了, 我的 `alias` 是这样的:

```bash
alias start-club='cd /app-path/; forever start -a -l /log-path/out.log -o /log-path/out.log -e /log-path/err.log app.js'
alias stop-club='cd /app-path/; forever stop app.js;'
```
详细的情况参考论坛和 Github 上的链接就好了
http://www.bishen.org/content/25925993071
http://cnodejs.org/topic/5048b5b4bcd422b444096540
https://github.com/nodejitsu/forever

前几天发现 byobu 真的是远程管理非常强大的工具
比如保存状态, 切换终端等等实用的功能. 甚至还有分屏和视野搜索之类的
我刚开始在服务器上遇到个去年启动的 byobu, 当时很幼稚地给关了..
学习的花没有文档是不行了, 主要看链接和自带的帮助命令:
https://help.ubuntu.com/community/Byobu
https://www.ibm.com/developerworks/cn/linux/l-cn-screen/
