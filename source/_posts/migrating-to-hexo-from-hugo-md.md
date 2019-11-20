---
title: Migrating to hexo from hugo
date: 2019-11-20 16:54:40
tags: ["hexo", "hugo", "blog", "static"]
---

> 先辈们说：[Don't Reinvent The Wheel, Unless You Plan on Learning More About Wheels](https://blog.codinghorror.com/dont-reinvent-the-wheel-unless-you-plan-on-learning-more-about-wheels/)，反正就是不要重复造轮子，因为这本身是一件浪费时间的事情。

最早的时候我是使用[Wordpress](https://wordpress.com)的，那个时候是还是LAMP、LNMP满天飞的时代，各种一键脚本层出不穷，虽然我不一定会用，但是事实证明我总是重复地去配置，也没有整理成自动化的脚本最后对于我掌握这门技巧还是没有任何实质性的帮助。就这样用了很久很久，博客也得到了比较好的发展也有不少的访问量了，突然发现了[Github Pages](https://pages.github.com)，而且借助[Cloudflare](https://www.cloudflare.com)也可以实现半程的HTTPS访问，具体怎么做可以自行Google，这边不作赘述。然后折腾了一段时间之后得到了最优解（也使用过[Pelican Static Site Generator](https://blog.getpelican.com)）：[Hexo](https://hexo.io)+[NexT](https://theme-next.iissnan.com)。当然，维护了一段时间之后发现场上除了经久不衰的Wordpress之外还出现了[Grav](https://getgrav.org)、[Ghost](https://ghost.org)、[Typecho](typecho.org)等优秀的CMS搅局者，但是这些都没有吸引住我的目光，直到[GoHugo](https://gohugo.io)。
<!--more-->
Gohugo是个非常高效的静态博客生成器，而且是用我当时最痴迷的[Golang](https://golang.org)编写的，切举例子说当博客数量在100+篇时Hexo的生成速度非常的缓慢，但是Hugo几秒钟就生成好了（当然随着版本的迭代我相信Hexo已经解决了这个问题）。所以当时二话不说直接再次抛弃之前的博客（尽管配置好了很多东西），采用了[Hugo](https://gohugo.io)+[cocoa-eh-hugo-theme](https://github.com/mtn/cocoa-eh-hugo-theme)来生成我的个人博客，然后托管在VPS上。而为了实现真·HTTPS，我自己购买了SSL证书配置了Nginx+HSTS，每次写完博客之后通过Rsync增量同步到VPS的nginx目录上面去，同时为了实现清真的部署方式我的Nginx是容器部署的。具体怎么做的如果有人感兴趣可以留言让我介绍一下，有这个需求的话我可以再写一篇唠唠嗑介绍一下，这边略过。

直到最近我了解到了现在大家偏向于把自己的博客部署在[Netlify](https://www.netlify.com)或是[Zeit](https://zeit.co)上，当然还有持续的生命力的Github Pages，我猜测可能是前面两种支持无痛的CI吧（当然之前也有人会使用[Travis CI](https://travis-ci.org)自动生成静态网页然后部署在Github Pages上，因为我本来就不会选择部署在Github Pages上所以就直接忽略了）。虽然现在Github已经开放了[GitHub Actions](https://github.com/features/actions)，可能更加方便CI了吧，但是我还没好好了解过所以就先不谈了。另外Netlify和Zeit都支持自动申请和续期[Let's Encrypt ](https://letsencrypt.org)的免费HTTPS证书，甚至自己也不用使用[Acme.sh](http://acme.sh)去申请和管理自己的证书，非常方便，所以我决定尝试一下（而且可以每个月省一笔VPS的开销，何乐而不为？虽然早晚会被割韭菜的，但是到时候再说吧）。

因为之前的主题实在是不够美观（虽然真的非常简洁），所以我选择更换主题为[Even](https://github.com/olOwOlo/hugo-theme-even)，但是碰到了个很大的问题是这个主题是从Hexo移植的，最后一次更新还是在2018年，算是很久没更新了。另外就是如果打开了TOC会导致浏览器的滚动条无限滚动，我还[提了个issue](https://github.com/olOwOlo/hugo-theme-even/issues/209)。所以我就很没骨气地准备迁移回Hexo，就为了用这个我比较喜欢地主题。嗯，我真是个渣男+外貌协会。

所以这次结论就很明确了，使用Hexo+Netlify+Even来部署我的个人博客，接下来简单介绍一下步骤。

1. 创建一个repo，名字无所谓，提交到Github上。
2. 本地初始化hexo：`hexo init blog`
3. fork一个主题的分支（因为我们需要自己对主题做一些更改而且又希望能够拉取到上游的更新，这意味着我们需要维持repo的git目录且需要有自己的主题仓库。），比如我就fork了[even](https://github.com/D0zingcat/hexo-theme-even)。
4. 进入目录`blog`之后clone主题，比如：`git clone https://github.com/D0zingcat/hexo-theme-even themes/even`, 如果是even的话还需要安装一个依赖 `npm install hexo-renderer-scss --save`，同时复制一份主题的配置文件出来到一个全新的配置文件 `cp themes/even/_config.yml.example themes/even/_config.yml`。
5. 使用Github授权登陆Netlify，并且授权blog那个repo的访问权限，设置好部署命令 `hexo generate` 设置好域名（CNAME指向这个netlify的域名），其他的默认就会启用这个生成的功能，只要那个repo有提交就会自动启动拉取数据并部署。

比较坑的是Netlify在拉取信息的时候，如果主Repo中有repo的嵌套，必须添加submodule，但是submodule中不一定会追踪文件的更改。可以使用命令 `git submodule add -b master https://github.com/D0zingcat/hexo-theme-even themes/even` 进行添加子模块，然后重新提交一下整个项目文件即可。submodule不会追踪子模块的更改，换言之如果要对子模块进行更改，那么需要进入到子模块提交文件修改之后再在主目录下进行提交，这时子模块是作为一个特殊的文件引用（160000 mode）提交的。如果子模块添加错了可以参考[这个](https://stackoverflow.com/questions/1260748/how-do-i-remove-a-submodule)。但是有个比较坑的地方是even这个主题里面的`.gitignore`中有`_config.yml`，所以自己自定义的配置文件更改都默认被忽略掉了（我找了半天的问题就是不明白为什么submodule会没法追踪文件的修改），记得从中删除之后[重新提交](https://blog.csdn.net/yingpaixiaochuan/article/details/53729446)配置文件，不然Netlify也没法拿到正确的配置。同时Even因为有gh-pages的分支，Netlify会自动拉取这个分支然后就报错了，具体原因未知，也懒得追溯。手动[删除master之外的分支](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/creating-and-deleting-branches-within-your-repository)之后重新deploy得到解决。
