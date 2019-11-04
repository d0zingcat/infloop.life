---
title: "推荐使用Beancount来记账及部署私服记录"
date: 2019-06-12T22:40:43+08:00
draft: false
---

在[郭大神][1]的《在Google的這四年》系列文章中提到了他是一个重度记账用户，他选择使用[beancount][2] 来进行他的日常记账工作，于是从这里我接触到了double-entry accounting，也就是[复式簿记][3]啦，感兴趣的可以自己主动去google具体的原理等，其实我也只是一知半解，仅停留在知道是啥而已。但是其实账目相平，从不同的桶将豆子都来倒去的原理让我耳目一新，因为之前自己的记账方式太过原始，只是简单记录下自己的花销等。当消费习惯引入了信用卡，花呗等贷记方式之后就会发现记账变得非常困难（比如还款和具体交易金额无法区分），只是能看到自己的花费而不能明白如：自己的钱从哪来，又到了哪去这个问题。于是我选择尝试一下beancount。

说白了beancount就是一个基于python的记账工具，他定义了一套自己独有的语法，让我们可以通过一个文本编辑器就可以轻松地开始记账，自己保存好自己的记账文件就不会出现使用记账app数据无法导出，或是突然倒闭/开发者跑路数据丢失的问题。主要的参考文档还是[官方的][4]，开发者非常勤奋贡献了很多文档，但是可能全是英文的对国内的使用者而言非常的不友好，所以这边主要推荐几个我看的：

[Beancount複式記賬（一）](https://www.byvoid.com/zht/blog/beancount-bookkeeping-1)

[Beancount —— 命令行复式簿记](https://wzyboy.im/post/1063.html)

[beancount 起步](http://morefreeze.github.io/2016/10/beancount-thinking.html)

[Beancount使用经验](http://lidongchao.com/2018/07/20/has_header_in_csv_Sniffer/)

[beancount 简易入门指南](https://yuchi.me/post/beancount-intro/)

[基础认识｜利用 Beancount 打造个人的记账系统（1）](http://freelancer-x.com/82/%E5%9F%BA%E7%A1%80%E8%AE%A4%E8%AF%86%EF%BD%9C%E5%88%A9%E7%94%A8-beancount-%E6%89%93%E9%80%A0%E4%B8%AA%E4%BA%BA%E7%9A%84%E8%AE%B0%E8%B4%A6%E7%B3%BB%E7%BB%9F%EF%BC%881%EF%BC%89/)

也基本算是中文圈中能找到的"大部分"文章了。这边不对语法做过多的介绍，请感兴趣的同学自己翻阅这些文章（其实还有其他文章写的也很好，请自行google），写的可比我好多了靠谱多了，而且我目前只是停留在记录日常流水（消费习惯比较单一，支付方式只有支付宝、微信、常用的两张借记卡、两张双币信用卡、花呗，基本不用现金，偶尔互相发发红包，连朋友间的垫付、借款以及其他大牛说的用beancount记录债券投资、折现之类的强大的特性一个都没用到，也没有实现其他大牛实现的自动话导入账单，举个例子就是郭大神的三篇文章我只看了两篇就急不可耐地开始记起了帐，搞起了后面的这些东西，可能现在需求还比较单一，之后如果有什么新的折腾的话可能会补充在这边），我仅介绍我的一些小的tips。

## 采用git管理文件历史

这个比较好解释，毕竟git可以追溯到文件的历史版本。我推荐使用[bitbucket](https://bitbucket.org/)的私有仓库，这样就可以保证数据的安全性，也可以通过这个来实现多平台的简单同步（服务器和本地）。

## 开户文件独立开来

我的目录形式为:

```
./ppb(可能意思是personal private beancount)
|__main.bean
|__accounts.bean
```

accounts中只存储开户相关的，比如我的就是：

```
1970-01-01 open Assets:Cash
1970-01-01 open Assets:Bank:CN:BOCOM
1970-01-01 open Assets:Bank:CN:SPDB
1970-01-01 open Assets:Bank:CN:CMB
1970-01-01 open Assets:Org:CN:ALIPAY
1970-01-01 open Assets:Org:CN:WECHAT
1970-01-01 open Assets:Pension:CN:SH
1970-01-01 open Assets:Provident:CN:SH
1970-01-01 open Liabilities:CreditCard:SPDB
1970-01-01 open Liabilities:CreditCard:CMB
1970-01-01 open Liabilities:ALIPAY
1970-01-01 open Income:Lilith:Salary
1970-01-01 open Income:Redpacket
1970-01-01 open Expenses:Clothing
1970-01-01 open Expenses:Other
1970-01-01 open Expenses:Food
1970-01-01 open Expenses:Transport:Metro
1970-01-01 open Expenses:Transport:Airline
1970-01-01 open Expenses:Transport:Railway
1970-01-01 open Expenses:Transport:Coach
1970-01-01 open Expenses:Transport:Texi
1970-01-01 open Expenses:Housing:Rent
1970-01-01 open Expenses:Housing:Utilities
1970-01-01 open Expenses:Health:Medical
1970-01-01 open Expenses:Love
1970-01-01 open Expenses:Life
1970-01-01 open Expenses:Leave
1970-01-01 open Expenses:Tax
1970-01-01 open Expenses:Cloud
1970-01-01 open Expenses:Entertainment
1970-01-01 open Expenses:Travel
1970-01-01 open Expenses:Electronics
```

分类仅供参考，因为我就补了6月起的账单所以还没统计全我的所有消费类别。然后定义完了这个文件之后呢在 `main.bean`中只需新增一行 `include "accounts.bean"`即可实现导入。

## 使用fava做web页面的预览和编辑



### 安装beancount和fava

可以额外说明下beancount和fava（fava的界面和功能真是比原生强大太多）的安装。直接安装我发现会有错误，具体错误不贴了，可能是python3.7导致的，所以需要现在服务器上（我使用的Debian 9.4）使用 `sudo apt update && sudo apt install python3.7-dev` 安装最新的python3，然后使用`sudo update-alternatives --install /usr/bin/python python /usr/bin/python2.7 1` 和 `sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.7 2`来设置python3.7为优先使用，这样使用`python --version`就可以看到默认的版本就是3.7了（请尽可能抛弃python2.7，现在已经慢慢各种问题不兼容了，况且官方明年6月就停止支持了）。然后可以使用 `curl -O https://bootstrap.pypa.io/get-pip.py && sudo python get-pip.py`来安装pip。接着再使用 `pip install beancount && pip install fava` 就可以无痛安装beancount和fava啦。

### 鉴权的配置

我本来采用的是vs code（安装了beancount 0.3.5的插件）编辑然后push到git，服务器pull然后fava展示的方案，后来发现fava自带的编辑也很好用，就直接主力用服务器的了。但是存在一个问题，权限。因为fava原生是不支持鉴权的，开发者认为这也不是fava应该具备的能力，所以我们可以通过[反向代理](https://zh.wikipedia.org/wiki/%E5%8F%8D%E5%90%91%E4%BB%A3%E7%90%86)来实现鉴权，我使用的是`nginx version: nginx/1.14.2`。安装也是一行 `sudo apt install nginx`的事情，但是需要外注意的是nginx需要包含http_auth_request_module这个模块，否则下面的配置是无效的，可以通过 `/usr/sbin/nginx -V | grep --color=red 'http_auth_request_module'`来检查。如果不包含的话，请自行google如何开启此模块的支持。当安装好了nginx之后就是需要添加账号了，可以通过 `sudo bash -c "echo -n 'alice:' >> /etc/nginx/.htpasswd"` 和 `  sudo bash -c "openssl passwd -apr1 >> /etc/nginx/.htpasswd"`

两个命令来实现账号（此处就是alice）和密码（会提示输入）的定义，也可以定义多个用户，可以自行尝试下。这个方法只需要用openssl免去了安装apache2-utils这个东西，比较清真。

我先本地创建了git repo然后push到了bitbucket，然后在服务器上pull下来的，为了方便后续的操作其实可以在服务器上生成一个公钥，生成公钥的命令是 `ssh-keygen -t rsa -C “your.email@example.com” -b 4096` ，然后[导入到bitbucket](https://confluence.atlassian.com/bitbucket/set-up-an-ssh-key-728138079.html)。接着直接使用ssh的链接地址就能把bitbucket的私有仓库clone下来而不需要每次提示输入账号密码了（要命的是这个输入账号密码的操作还不能通过传参来实现，会不方便做文件的自动push）。

然后需要进入这个目录，比如我就是 `/home/d0zingcat/ppb/` 使用命令 `nohup fava main.bean &`来启动，这样默认fava就启动在5000端口了。其实按理说fava通过反代的方式是可以指定prefix，但是我怎么尝试都是失败的，所以就放弃了。所以这决定了我5000这个端口就只能被fava独占了（不过服务器上也只起了这一个服务所以也就无所谓了:P）。然后改nginx的配置，新增文件/etc/nginx/conf.d/bean.conf，编辑如下：

```
server {
        listen 80;
        server_name bean.d0zingcat.xyz;
        location / {
                auth_basic "d0zingcat's personal area";
                auth_basic_user_file /etc/nginx/.htpasswd;
                proxy_pass http://localhost:5000/;
                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
                #auth_request_set $auth_status $upstream_status;
        }
}

```

然后在自己的DNS那边配置对应的域名解析到这台服务器就ok了，推荐使用[cloudflare](https://www.cloudflare.com/) 来管理自己的域名解析。重启nginx：`sudo systemctl restart nginx` ，访问对应的域名就会发现弹出提示：![](https://files.d0zingcat.xyz/blog/posts/beancount-recommendation/WX20190613-105814@2x.png) 

输入完账号和对应的密码之后就能进去看到自己的端口啦。如果尝试输入一个错误的密码则会看到：

![](https://files.d0zingcat.xyz/blog/posts/beancount-recommendation/WX20190613-105833@2x.png)

所以到这基本就完成了反向代理和鉴权的配置。但是我可能觉得这样还不够安全，在这个全名https的时代，况且有ACME这种好东东，所以我决定继续折腾一把，加上tls证书。
参考[An ACME Shell script: acme.sh](https://github.com/Neilpang/acme.sh) 的README进行安装，其实也就一行 `curl https://get.acme.sh | sh` ，就是需要注意的是如果想要使用standalone模式（也就是单独起一个http服务不依赖于nginx或者apache），那么需要自己安装依赖socat，其实也就一行 `sudo apt install socat`就能搞定。安装好了之后直接敲命令，比如我就是` sudo ~/.acme.sh/acme.sh --issue -d bean.d0zingcat.xyz --standalone -k ec-256` 然后就能完成证书的签发（记得现在DNS那边把对应的域名解析道这台主机的ip，也先提前停止这台机子上占用了80端口的服务）。

然后就是改nginx配置文件啦，比如我的：

```
server {
	listen 80;
	server_name bean.d0zingcat.xyz;
	return 302 https://$host$request_uri;
}
server {
				listen 443 http2 ssl;
				ssl_certificate /root/.acme.sh/bean.d0zingcat.xyz_ecc/fullchain.cer;
        ssl_certificate_key /root/.acme.sh/bean.d0zingcat.xyz_ecc/bean.d0zingcat.xyz.key;
        add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
        keepalive_timeout   70;
        ssl_session_cache   shared:SSL:10m;
        ssl_session_timeout 10m;
        ssl_session_tickets on;
        ssl_stapling        on;
        ssl_stapling_verify on;
        ssl_ciphers 'ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:ECDHE-RSA-DES-CBC3-SHA:ECDHE-ECDSA-DES-CBC3-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:AES:DES-CBC3-SHA:HIGH:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!MD5:!PSK:!aECDH:!EDH-DSS-DES-CBC3-SHA:!EDH-RSA-DES-CBC3-SHA:!KRB5-DES-CBC3-SHA';
	server_name bean.d0zingcat.xyz;
	#root /var/www/html;
	location / {
		auth_basic "Lee's personal area";
		auth_basic_user_file /etc/nginx/.htpasswd;
		proxy_pass http://localhost:5000/;
		proxy_set_header Host $host;
    		proxy_set_header X-Real-IP $remote_addr;
	}
}
```

对应我的配置替换 *server_name* *ssl_certificate* *ssl_certificate_key* 几个字段就ok。然后重启nginx就大功告成，那么一个带s带鉴权的beancount线上服务就完成啦。

![](https://files.d0zingcat.xyz/blog/posts/beancount-recommendation/WX20190613-133123@2x.png) 

### 监控文件变化及自动push

程序完成中，待续。



[1]: https://www.byvoid.com/
[2]: https://github.com/beancount/beancount
[3]: https://zh.wikipedia.org/wiki/%E5%A4%8D%E5%BC%8F%E7%B0%BF%E8%AE%B0
[4]:  http://furius.ca/beancount/doc/index