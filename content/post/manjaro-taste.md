---
title: "Manjaro Taste"
date: 2019-10-21T13:29:25+08:00
draft: false
---

> 之前有尝试过Arch Linux，但是因为arch本身折腾的属性实在是太过浓重（什么都需要自己进行配置），因此就“浅尝辄止”了。
> 最近在看到了这条信息：[Manjaro Linux的两项大胆举措](https://www.debian.cn/archives/3430) ，发现的重点有四个：1. 基于Arch Linux 2. 商业公司驱动 3. 使用了不开源但是兼容性更好的FreeOffice 4. 预装了N卡驱动免折腾 。在稍作查询之后我发现Manjaro对硬件兼容性的支持也很好，联想到最近使用Ubuntu 19.04的卡顿感（尤其是SSD下开机速度基本是2分钟），旋即决定尝试一下这个新鲜（对我而言）的系统。

参考 [First Steps](https://manjaro.org/support/firststeps/)以及google（其实不看任何教程直接安装就可以，千篇一律步骤很简单），需要注意的是如果选择使用自定义分区的起码建两个分区`/efi` 和 `/`，不过如果我的建议可能是直接通过自动格式化 `Erase Disk`来进行自动分区，选择`With Hibernate`进行安装（我的理解是这个分区会用于存储休眠的系统镜像，会加速休眠）。如果有需求的话（比如自动连接Wi-Fi和启动VNC Server）也可以在用户设置界面勾选 `autologin`，因为这边不勾选的话后面我google折腾了很久还是没能设置成功自动登录，后来直接放弃了重新安装了系统只为了这边的自动登录。 因为这台机器我是家用的pc，放在家里就自己用也没啥隐私，而且最关键的是我希望他能自动联网启动zerotier，这样我就能走到哪里都直接通过内网连到这台机器（ssh、vnc）进行操作了，这个依托于自动登录进系统这一步。


> 当进入系统后我会配置下列选项

### 初始化命令

```
sudo pacman -Syu
sudo pacman -S --noconfirm vim git 
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
curl -s https://install.zerotier.com | sudo bash
yay -yS go
yay -c
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
echo 'source $HOME/.cargo/env' >> ~/.profile
git clone https://github.com/asdf-vm/asdf.git ~/.asdf
cd ~/.asdf
git checkout "$(git describe --abbrev=0 --tags)"
echo -e '\n. $HOME/.asdf/asdf.sh' >> ~/.bashrc
echo -e '\n. $HOME/.asdf/completions/asdf.bash' >> ~/.bashrc
sudo systemctl start sshd
sudo systemctl enable sshd
```

### VNC相关

安装Tiger Vnc

`sudo pacman -S tigervnc`

首次输入 `vncserver` 会提示输入密码，也会询问是否设置view-only password，这个根据实际需要设置就好。

然后更改 `~/.vnc/config` 输入（根据实际情况填写，如果输入了localhost则只监听127.0.0.1，无法远程连接上）

```
desktop=sandbox
geometry=1366x768
dpi=96
alwaysshared
```

然后更改 `~/.vnc/xstartup`

```
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
exec startxfce4
```

然后重新使用 `vncserver` 启动vnc，如果提示的是`1`则表示端口是5901， `:2`则表示端口是5902，以此类推。然后就可以通过vnc 软件进行远程连接了。macOS可以使用[screens](https://edovia.com/en/screens-mac/)，还挺好用的。有一个小hack是安装完了vncserver可以重启一下，不然`:1` 是被占用的。

### 安装常用软件

我一般比较常用的软件有：

- docker
- neovim
- remmia(VNC viewer)
- liteide(golang)



### 国内加速Docker

- 如果通过阿里云镜像加速

可以到这边申请专属的加速链接：https://cr.console.aliyun.com/cn-hangzhou/instances/mirrors

```
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["加速链接"]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker
```


- 如果使用的是腾讯云镜像加速

修改 `/etc/default/docker`，添加（原先应该都是默认注释掉的）`DOCKER_OPTS="--registry-mirror=https://mirror.ccs.tencentyun.com"`这么一行，然后使用 `sudo systemctl restart docker`重启docker即可生效。

### 笔记本合盖不休眠

这项仅适用于使用笔记本的情况，我的笔电是Lenovo Y510P，但是BIOS做过破解（网卡白名单），网卡从原生的Intel更换成了博通BCM 94322（这也是我安装Manjaro的原因之一，对硬件的兼容性支持更好），我需要我的电脑长时间开机并且可以合上盖子息屏但是不睡眠，所以需要做一个修改（接通电源的情况下manjaro默认是不休眠的，当然这个也许会变，可以复合一下，在setting-power里面可以修改）。

sudo 修改 `/etc/systemd/logind.conf` ，找到 `#HandleLidSwitch=suspend` ，改成 `HandleLidSwitch=ignore` 即可合盖不睡眠。

当然，关于其他的电源选项可以去 `Settings-Settings Manager-Power Manager` 检查一下其他的电源选项，比如 Display tab 中的 Blank after、Put to sleep after、Switch off after 分别就是屏幕的黑屏、睡眠、关闭时间，而 System tab 中的 System sleep mode 就意味着当系统不活跃多久之后进行什么操作，电池和接电源分别的处理是什么，对于我而言就是直接全部改成 Never（因为我希望电脑一直不休眠/睡眠 方便我随时能连接上这台电脑，虽然可能可以配置下 wake on lan 但是就不继续折腾了，也不差这点电【大雾】），建议配置下 Critical Power, 改成 level 10%， 操作选 Hibernate， 这样就可以在只有10%的电量的时候直接休眠，以防数据丢失（这个下分区的时候选择的 With Hibernate 选项单独分出来的一个休眠分区就有用户之地啦）。顺带提一下，Sleep是睡眠，其实电脑的数据还都保存在内存中，电源还是对电源供电的。


### 关闭笔记本的蜂鸣器

manjaro默认是打开了笔记本的蜂鸣器的，所以当（比如）没有文字但是按退格键的时候，电脑会beep beep地叫，这个其实不是笔记本的speaker的声音，而是主板上的蜂鸣器发出的。晚上就比较恼人了，所以我还是比较希望能够关闭这个声音的。

- 方法一

对于X applications 关闭蜂鸣器的方法很简单（我假定既然是用manjaro就说明主要的使用场景是图形界面），命令行里面输入`xset b off`即可。

- 方法二

可以一劳永逸地做这个配置（网上其他方案是在开机的自动启动的脚本中加入一个rmmod命令把负责这块功能的内核模块移除掉，但是我有看到arch wiki资料说会导致问题，所以选择了下面这个方式）

使用命令`sudo vim /etc/modprobe.d/nobeep.conf`新增一个过滤文件，添加内容`blacklist pcspkr`保存重启即可。

也可以直接通过命令`rmmod pcspkr`进行内核模块的移除，如果不想要重启的话。

主要参考了这边：

[How to disable beep tone in xfce when the delete button is pressed?](https://wiki.archlinux.org/index.php/PC_speaker#Disable_PC_Speaker)

[Kernel module](https://wiki.archlinux.org/index.php/Kernel_module#Using_kernel_command_line_2)

[[SOLVED] Disable PC Speaker when Backspace is pressed on Log In](https://forum.manjaro.org/t/solved-disable-pc-speaker-when-backspace-is-pressed-on-log-in/76538)

[Disable PC speaker beep (简体中文)](https://wiki.archlinux.org/index.php/Disable_PC_speaker_beep_(简体中文)#全局设置)

### 解决和windows 10 dual boot

我的电脑上加装了一块硬盘，所以有两块SSD，其中一块上面安装了windows10，但是EFI分区在另一块硬盘上面（当时安装了Ubuntu 19.04），所以当我安装manjaro的时候直接把安装了Ubuntu的硬盘格式化了， 所以这个启动分区就丢失了。当打开电脑的时候会自动进度manjaro，手动唤出BIOS的启动选项的时候也并不能检测到Windows的启动选项。因此为了解决这个问题需要以下步骤：

1. 制作Windows的usb启动镜像（可以使用[Rufus](https://rufus.ie)），镜像可以从这边下载：https://share.weiyun.com/5BFi4gv
2. 使用usb启动（如果是USB 3.0的U盘可以使用2.0的插口，我的电脑检测不出来不确定会不会别人有同样的问题），可以具体搜索不同型号的电脑的boot的快捷键，比如Lenovo是F12。如果BIOS不支持快速选择的话那就需要进入具体的BIOS去调整启动盘的顺序，这个可以具体去**Google**。
3. 进入安装界面之后按Shift+F10可以唤出Windows的安装命令行，依次输入：

```
bootrec /FixMBR 
bootrec /FixBoot
bootrec /rebuildbcd
```

但是我使用上述命令（输入`bootrec /FixBoot`）进行修复的时候提示了“拒绝访问”，继续查询解决办法后得到一个解决方法（输入以下命令）：

```
bootrec /FixMBR 
bootsect /nt60 sys /mbr
bootrec /FixBoot
bcdboot c:\windows /s c:
bcdboot c:\windows /v 
bcdedit /enum
```

然后发现bcd文件已经修复好，但是步骤并没有结束。

4. 重启进入Windows系统（默认就是进入Windows，其实这个时候如果打开BIOS的boot options也可以看到有windows10 的选项），打开控制面板-电源选项-系统设定，去掉快速启动的选项。也可以参考这篇文章：[How To Disable Fast Startup in Windows 10](https://help.uaudio.com/hc/en-us/articles/213195423-How-To-Disable-Fast-Startup-in-Windows-10)
5. 然后可以重启一下进入Windows10（也可以先通过boot option先进入manjaro，然后再重启进入Windows 10），不确定这一步的意义，但是我是这么做的，也许可以省略。
6. 重新回到Windows后以管理员命令打开命令指示符，输入`bcdedit /set {bootmgr} path \EFI\manjaro\grubx64.efi`，参考：[Dual-boot Manjaro - Windows 10 - Step by Step](https://forum.manjaro.org/t/howto-dual-boot-manjaro-windows-10-step-by-step/52668)
7. 重启则会发现默认进入了manjaro，再次重启（boot option）进入windows后再次重启就会发现进入了manjaro的GRUB的菜单，然后就可以选择到底是windows还是manjaro了。