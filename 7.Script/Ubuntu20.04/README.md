# 造“派”计划

## 简介

为瑞芯微系列芯片移植Ubuntu文件系统的脚本，魔改自鲁班猫（ https://github.com/LubanCat/ubuntu ）

## 适用板卡

- 使用RK3566处理器的板卡
- 使用RK3568处理器的板卡
- 使用RK3588处理器的板卡

## 安装依赖

推荐使用Ubuntu20.04及以上版本主机构建根文件系统

```
sudo apt-get install binfmt-support qemu-user-static
sudo dpkg -i ubuntu-build-service/packages/*
sudo apt-get install -f
```

## 构建 Ubuntu20.04镜像（仅支持64bit）

- lite：控制台版，无桌面
- xfce：桌面版，使用xfce桌面套件
- xfce-full：桌面版，使用xfce桌面套件+更多推荐软件包
- gnome：桌面版，使用gnome桌面套件
- gnome-full：桌面版，使用gnome桌面套件+更多推荐软件包


#### step1.构建基础 Ubuntu 系统。

```
# 运行以下脚本，根据提示选择要构建的版本
./mk-base-ubuntu.sh
```
#### step2.添加 rk overlay 层,并打包ubuntu-rootfs镜像

```
# 运行以下脚本，根据提示选择要构建处理器版本和ubuntu的版本
./mk-ubuntu-rootfs.sh
```

## 定制化说明

### 1.开机桌面壁纸设置：  

默认桌面壁纸为蓝莓派logo  

如要更改，请在/usr/share/xfce4/backdrops/目录下添加壁纸图片，并将mk-ubuntu-rootfs.sh文件下的blueberry_wallpaper.png替换为自己的壁纸图片

### 2.开机终端输出logo设置：  

默认输出图像为蓝莓派logo和BlueberryPi  

如要更改，请在/overlay/etc/update-motd.d/目录下更改00-header和10-help-text文件

### 3.主机名设置：  

默认主机名为BlueberryPi  

如要更改，请在mk-base-ubuntu.sh将`HOST=`后面的内容替换成你设置的主机名

### 4.用户名密码设置：  

默认用户名为blueberry，密码为pi；超级用户root，密码为root  

如要更改，请在mk-base-ubuntu.sh将全部`blueberry`换成你设置的用户名

