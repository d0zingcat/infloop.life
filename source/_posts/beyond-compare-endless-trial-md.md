---
title: Beyond Compare 无限试用
tags: []
date: 2019-12-20 20:05:18
---

最近一阵子都在跟公司数据组同事对数据，因为涉及到了同样的安装数据的两套归因逻辑，因此检查数据的方式非常原始，就是分别比对不同的查询语句下的查询结果。然后就不得不使用了对应的工具——Beyond Compare（有大佬会说为啥不用vimdiff，emmmm，可能还是自己对命令行的工具链不够熟悉吧，所以还是更喜欢使用这类的图形化程序），感觉下来这个工具果真老牌（虽然没有拿来合代码，但还是觉得比对起来的效率非常之高）。因此本夸下海口说等试用期过了我就买个正版授权，结果跟同事说了一下之后同事告诉我可以无限试用。emmmmm～那好吧，谁让我是个穷人呢，况且我也没对软件进行crack，良心也还算过得去所以就有了这篇文章（当然，脚本主要还是从网上抄的，只是自己想找个地方记录一下）。
<!--more-->

## 原理

	BCompare是应用程序启动的程序，只要在在启动的时候删除registry.dat(Library/Application Support/Beyond Compare/registry.dat)注册信息就好了，为此可以在该目录下添加一个批处理文件用来处理这个操作（同时自动打开真正的应用程序）。

## 方法

1. 打开命令行，进入到对应的目录 `cd /Applications/Beyond\ Compare.app/Contents/MacOS/`
2. 修改可执行文件名，并创建启动脚本

```shell
mv BCompare BCompare.real
touch BCompare #
vim BCompare
```

输入脚本：

```shell
#!/bin/bash
rm "/Users/$(whoami)/Library/Application Support/Beyond Compare/registry.dat"
"`dirname "$0"`"/BCompare.real $@
```

3. 给脚本加上执行权限 `chmod a+x BCompare`

然后Voila！一切都好了，下次只要正常打开Beyond Compare的程序就可以。当然，坏处就是如果更新了应用程序可能需要重新写一下这个脚本。当然，做好备份到时候还原一下，我觉得成本还是蛮低的。

# Refer

[Mac下Beyond Compare不用破解码无限试用](https://www.jianshu.com/p/009e10209fba)

# Appendix
