# CWCarouselView
[![GitHub license](https://img.shields.io/badge/license-Apache-blue.svg)](https://github.com/crespoxiao/CWCarouselView/blob/master/LICENSE)




## 功能简介

CPInfiniteBanner是一个无限轮播器控件。一行代码即可集成，可双向无缝无限滚动，可自定义点击事件。

## 使用方法


## 安装

暂未支持cocoaPods，请下载文件后拖动到项目文件夹中集成


## 设计思路
将3个imageView添加到scrollview上，左右2个imageview用于过渡，借助scrollview的`didEndDecelerating`代理方法监听滚动事件，并修改scrollView的contentOffset、修改三个imageView的image来实现无限轮播。相比于N+2个imageView的实现方式，内存占用更低。
