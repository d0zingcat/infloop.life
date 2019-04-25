+++
title = 'Setting Shadowsocks Libev With Obfs'
date = 2019-02-05T20:58:41+08:00
draft = true
meta_img = "/images/image.jpg"
tags = ["tags"]
description = "Desc"
hacker_news_id = ""
lobsters_id = ""
+++

> 今天是2019年2月5日，农历大年初一。但是今天发现昨天icloud photos加载不出来不是空穴来风，应该是GFW升级了之类导致的，起码在目前的网络环境下（江苏电信），是电脑和手机全线崩，不能访问Google的。

所以第一时间考虑如何修复这个问题。但是对于我而言翻墙成本有以下几个需要考虑的点：

1. 多用户多端口（小伙伴们合租）
2. 上网习惯了PAC模式自动切换代理开关
3. PAC模式可以随时新增网址（算是第2点的补充，这个列表需要不停地update）

但是先应急使用了Cisco Any connect（Open Connect Server，也就是ocserv），现在不比以前需要shell安装配置一大堆的东西，直接[docker镜像](https://github.com/TommyLau/docker-ocserv)跑一下即可。

    docker run --name ocserv --privileged -p 8080:443 -p 8080:443/udp -d tommylau/ocserv
    
也就是内部端口443，映射到外部8080，主机没有配置iptables，然后果然在两个环境下都可以正常翻墙了，但是anyconnect有个我最不喜欢的地方就是全局代理，即便是通过CIDR进行智能路由，也存在着IP错杀或是不准确的情况，更新起来也必须要改服务端，很麻烦。所以就先作为一个应急手段吧。脑袋里就想起来[破娃酱](https://github.com/breakwa11)之前有发过一篇文章是关于识别ss的流量的，然后引发了巨大的争议和批判（而且还导致他删除了自己大部分的repo，当然，早期他的shadowsocksr-windows不开源也引发过很大的争议，但是没这次这么夸张，其实这个很不应该），所以就连带地想起来破娃酱的shadowsockr-windows的一个特性就是支持混淆，当然，那篇文章之后（前因后果就不谈了，感兴趣的自己去搜索吧）[https://github.com/madeye](madeye)也发过文章说明了一些情况，也给了解决方案－－混淆。所以这边我想先试着通过插件进行混淆流量能不能成功翻墙。

*闹了个乌龙，可能是主机程序原因高位端口被占用冲突了所以不能访问，改个端口问题得到了解决。*不过还是能继续捣鼓下去的，这边也记录下来。初步尝试v2ray-plugin，开启80端口混淆配上shadowsocksx-ng是可以正常访问的。不过距离我的tls混淆，以及多账户同端口共用（通过ng转发）的设想还有点远，所以目前先凑活用下去。等我下次捣鼓https混淆的时候，我就会完整地把过程记录下来了。



