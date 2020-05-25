---
title: "Daily Trivials"
date: 2019-08-02T11:03:54+08:00
draft: false
---

> 其实日常的工作和学习中出现问题最多的倒不是一些比较大的课题，都是一些小问题小毛病，因此最多的是troubltshooting和tips。

这篇文章讲用于记录我日常遇到的一些问题的解决和一些小的hacks。话不多说，let's begin.


- start zookeeper error: ERROR Unexpected exception, exiting abnormally (org.apache.zookeeper.server.ZooKeeperServerMain)
java.io.IOException: No snapshot found, but there are log entries. Something is broken!

手动删除掉zookeeper下的数据后可以正常启动 `rm -rf /usr/local/var/lib/zookeeper`

- nginx测试配置是否正确

The -c flag indicates a certain configuration file will follow; the -t flag tells Nginx to test our configuration. 

`nginx -c /etc/nginx/nginx.conf -t`


- tigervnc-server 无法启动问题
Fatal server error:
(EE) Cannot establish any listening sockets - Make sure an X server isn't already running(EE) 

<!--more-->

```
touch /tmp/.X11-unix/X1
chmod 777 /tmp/.X11-unix/X1
```


- mac 移除外挂硬盘

   `diskutil unmountDisk force /Volumes/DISK_NAME`

- mac安装kafka

```
   brew cask install homebrew/cask-versions/java8
   brew install kafka
```
	To have launchd start kafka now and restart at login:
	brew services start kafka
	Or, if you don’t want/need a background service you can just run:
	zookeeper-server-start /usr/local/etc/kafka/zookeeper.properties && kafka-server-start /usr/local/etc/kafka/server.properties

- 误删macOS唯一一个administrator的用户admin组，不小心使用了`sudo dseditgroup -o edit -a $(whoami) -t user admin` （本意只是想从wheel组里面删掉）命令把系统上唯一一个具有超级管理员权限的用户的组权限给删了，导致使用sudo命令会提示 `$(user) not in sudoers file, this incident will be reported....`

   重启开机，按住或者按几下cmd+r进入recovery mode，然后选好语言进入安装系统的界面，打开disk utility 检查下叫做 Macintosh HD 的一块硬盘又没有mount，没有的话用工具栏的mount命按钮挂载，然后关闭disk utility，可以看到menu bar上的二级菜单里面找到terminal（默认是root用户），打开之后进入 `/Volumes/Machintosh HD/` 使用vim打开 `etc/sudoers` 文件，找到`%admin ALL=(ALL) ALL`这一行，在下面一行添加上错误删除的用户 `${username} ALL=(ALL) ALL`， 保存退出重启即可找回sudo权限。

   然后别忘了通过 `/usr/sbin/dseditgroup -o edit -a $(whoami) -t user admin` 来重新添加自己到超级管理员组，不然系统更新或是软件更新都会没法直接通过输密码来获取超级管理员权限。另外，就是下面这个命令让我失去了这一切：`sudo dseditgroup -o edit -a `whoami` -t user admin`

- 编译mac app时命令出错，提示`xcode-select: error: tool 'xcodebuild' requires Xcode, but active developer directory '/Library/Developer/CommandLineTools' is a command line tools instance`

   `sudo xcode-select -s /Applications/Xcode.app/Contents/Developer`

- Xcode tools install

   `xcode-select —install`

- Ffmpeg 下载m3u8视频流

   `./ffmpeg -i {src}.m3u8 -c copy  {dst}.mp4`

- 使用vim或者nano打开`crontab -e`

   ```
   # Specify nano as the editor for crontab file
   export VISUAL=nano; crontab -e
   # Specify vim as the editor for crontab file
   export VISUAL=vim; crontab -e
   ```

- 生成 ssh rsa key

   `ssh-keygen -t rsa -C “{your email}” -b 4096`

- CentOS 安装Erlang

   从Erlang solutions下载rpm文件： [Erlang Solutions](https://www.erlang-solutions.com/resources/download.html)

   ```
   # install dependencies
   yum install -y  wxBase
   yum install -y  wxGTK
   yum install -y wxGTK-gl
   yum -y install -y unixODBC
   yum -y install -y openssl-devel
   rpm -ivh {els-erlang.rpm}
   ```

- macOS 下通过brew安装的erlang 没有 man文档

   `export MANPATH='/usr/local/opt/erlang/lib/erlang/man'` 添加到`~/.zshrc`中，也取决于用的是zsh还是bash（~/.bash_profile）

- brew使用link时报错

   `sudo chown -R $USER:admin /usr/local/share` should set the correct ownership and group for all files and directories below and including /usr/local/share

- mac 安装MySQL

   ```
   brew install mysql
   brew install services
   mysqladmin -u root password ‘welcome’
   brew services start mysql 
   ```

- 注销vultr账号

    [Log In - Vultr.com](https://my.vultr.com/billing/cancel/)

- 查看服务器的进程状态/IO数据/网络实时流量的三个工具推荐：htop/iostat/nload
