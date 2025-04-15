<h1 align="center">造“派”计划</h1>
<div align="center">

<a href="https://github.com/Commander-bao/BlueberryPi/stargazers"><img src="https://img.shields.io/github/stars/Commander-bao/BlueberryPi" alt="Stars Badge"/></a>
<a href="https://github.com/Commander-bao/BlueberryPi/network/members"><img src="https://img.shields.io/github/forks/Commander-bao/BlueberryPi" alt="Forks Badge"/></a>
<a href="https://github.com/Commander-bao/BlueberryPi/pulls"><img src="https://img.shields.io/github/issues-pr/Commander-bao/BlueberryPi" alt="Pull Requests Badge"/></a>
<a href="https://github.com/Commander-bao/BlueberryPi/issues"><img src="https://img.shields.io/github/issues/Commander-bao/BlueberryPi" alt="Issues Badge"/></a>
<a href="https://github.com/Commander-bao/BlueberryPi/graphs/contributors"><img alt="GitHub contributors" src="https://img.shields.io/github/contributors/Commander-bao/BlueberryPi?color=2b9348"></a>
<a href="https://github.com/Commander-bao/BlueberryPi/blob/master/LICENSE"><img src="https://img.shields.io/github/license/Commander-bao/BlueberryPi?color=2b9348" alt="License Badge"/></a>

</div>

从左至右分别为AdorkableTV、BlueberryPi 1、BlueberryPi-Core
![](2.Docs/Images/All.jpg)

## 0.关于本项目

当我看到树莓派4b的那一刻起，我就对这个卡片大小的单板计算机深深的吸引，漂亮的布局、完整的功能...我能不能自己也做一个呢？  

这就是造“派”计划的由来。本人通过四处搜寻资料以及在[这个项目](https://oshwhub.com/logicworld/h6_board)的指引下，成功设计出**BlueberryPi 1**，又在自学Altium Designer后画了它的核心板**BlueberryPi-Core**。在蓝莓派成功后又以立创泰山派为原型，重构软硬件设计了**AdorkableTV**。  

我的“蓝莓派”是一板成功的，但是也免不了这一路上的曲折，中途因为短路等各种原因焊废了好几块板子，导致我一度怀疑人生。好在功夫不负有心人，当电源小灯亮起来，屏幕上出现Ubuntu界面的时候，我知道我成功了。  

## 1.硬件打样说明

电路板Gerber文件为Hardware文件夹下的zip压缩包，可以直接上传到嘉立创平台进行打样。  

- BlueberryPi 1、Adorkable_Base、Adorkable_EXP请使用嘉立创eda（专业版）打开。  

- BlueberryPi-Core、Adorkable_Core请使用Altium Designer打开。  

BlueberryPi 1请使用嘉立创3313阻抗，1.6mm板厚。  

Adorkabe_Core、Adorkable_EXP请使用嘉立创3313阻抗，1.2mm板厚；Adorkable_Base请使用嘉立创3313阻抗，1.6mm板厚。  

以上均选用免费20%阻抗管控，有半孔的请使用四边半孔工艺。  

## 2.镜像烧录说明

BlueberryPi 1目前使用的是香橙派官方的镜像文件[这是网址](http://www.orangepi.cn/html/hardWare/computerAndMicrocontrollers/details/Orange-Pi-3-LTS.html)（蓝莓版镜像待移植）。下载好镜像后可以使用balenaEtcher将镜像烧录至TF卡中。  

我还为立创泰山派移植了蓝莓版Ubuntu20.04桌面系统，Bootloader和Kernel放在了对应的文件夹下，大家可以根据需要下载，完整的镜像文件待我修正好一些小bug后会上传。下载好镜像后可以使用balenaEtcher将镜像烧录至TF卡中，也可使用瑞芯微烧录工具下载到板载EMMC中。  

如果要为RK3566定制Ubuntu镜像，请参考Script文件夹下的README文档制作文件系统，将官方提供的镜像文件通过RKDevTool解包后替换boot.img和rootfs.img（建议修改分区表文件，扩大rootfs分区容量），最后通过RKDevTool文件夹下的打包脚本打包。

## 3.硬件使用说明

- BlueberryPi 1使用说明：将烧录好镜像文件的TF卡插入TF卡槽内，micro-usb接通5V-2A的电源后即可通过串口/HDMI连接使用。  

- BlueberryPi-Core使用说明：参考全志官方/香橙派/BlueberryPi 1中的原理图，绘制底板后，将BlueberryPi-Core贴至底板上使用（待测试）。  

- AdorkableTV使用说明：绘制扩展底板，将核心板和功能板分别贴至底板两面，烧录镜像至EMMC中使用。