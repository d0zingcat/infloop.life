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


比较坑的是Netlify在拉取信息的时候，如果主Repo中有repo的嵌套，必须添加submodule，但是submodule中不一定会追踪文件的更改。
