# CWCarouselView
[![GitHub license](https://img.shields.io/badge/license-Apache2.0-blue.svg)](https://github.com/crespoxiao/CWCarouselView/blob/master/LICENSE)
[![CocoaPods](https://img.shields.io/cocoapods/p/CWCarouselView.svg)](http://cocoadocs.org/docsets/CWCarouselView)




## 功能简介


CWCarouselView是一个无限轮播器控件。一行代码即可集成，可双向无缝无限滚动，可自定义点击事件。



## 框架依赖

本控件依赖于SDWebImage，实现网络图片的加载和缓存。



## 安装

暂未支持cocoaPods，请下载文件后拖动到项目文件夹中集成



## 使用方法

#### 创建轮播器

只需一行代码即可创建一个图片轮播器。提供了通过本地图片创建和通过网络图片创建两种方式：

```objective-c
// 通过本地图片创建
    CGRect frame = CGRectMake(50, 100, 300, 150);
    
    UIImage *image1 = [UIImage imageNamed:@"img_01"];
    UIImage *image2 = [UIImage imageNamed:@"img_02"];
    UIImage *image3 = [UIImage imageNamed:@"img_03"];
    
    NSArray *imageArray = @[image1,image2,image3];
    
    CWCarouselView *carouselView1 = [CWCarouselView carouselViewWithFrame:frame imageGroup:imageArray];
```

```objective-c
// 通过网络图片创建
    NSURL *url1 = [NSURL URLWithString:@"http://img2.niutuku.com/desk/1207/1005/ntk122731.jpg"];
    NSURL *url2 = [NSURL URLWithString:@"http://img2.niutuku.com/1312/0800/0800-niutuku.com-14339.jpg"];
    NSURL *url3 = [NSURL URLWithString:@"http://img2.niutuku.com/desk/anime/0529/0529-17277.jpg"];

    NSArray *urlArray = @[url1,url2,url3];

    CWCarouselView *carouselView2 = [CWCarouselView carouselViewWithFrame:frame imageUrls:urlArray placeholder:nil];
```

轮播器控件创建完毕后，将其添加到需要显示的View上，就可以自动实现图片的展示和自动轮播了。

#### 处理图片点击事件

CWCarouselView支持了block和代理两种方式来监听图片的点击，实现其中任意一种即可(两者不共存，若设置了代理，则block失效)

###### 利用block处理图片点击的代码：

```objective-c
// 给控件的operations属性传入等同于图片数量个数的block，即可在被点击时调用
carouselView1.operations = @[ ^{
                                    NSLog(@"第1张图片被点击");
                                },
                                   ^{
                                       NSLog(@"第2张图片被点击");
                                   },
                                   ^{
                                       NSLog(@"第3张图片被点击");
                                   }
                               ];
// 如果传入的block数组只有1个元素，则点击任意图片均会调用者一个block
// 如果传入的block数组长度既不是1也不等于图片数量，则不会处理事件
```

###### 利用代理处理图片点击的代码：

```objective-c
// 设置代理(需要遵守CWCarouselViewDelegate协议)
carouselView2.delegate = self;
// 实现代理方法
- (void)carouselView:(CWCarouselView *)carouselView didClickImageOnIndex:(NSUInteger)index {
  // 分别设置每张图片的响应事件即可
    switch (index) {
        case 0:
            NSLog(@"点击了第1张图片");
            break;
        case 1:
            NSLog(@"点击了第2张图片");
            break;
        case 2:
            NSLog(@"点击了第3张图片");
            break;
        default:
            break;
    }
}
```

#### 自定义属性

CWCarouselView提供了一系列API用于自定义控件属性

###### 自定义轮播间隔：

```objective-c
// 设置轮播时间间隔
carouselView2.interval = 5.0;
// 如果希望禁止掉自动轮播，可将间隔设置为 -1
carouselView1.interval = -1;
```

###### 自定义占位图片：

```objective-c
// 通过网络的方式加载的图片，可以设置一张占位图片，如果图片未正常下载，则会显示占位图片
carouselView2.placeholderImage = [UIImage imageNamed:@"img_01"];
// 如果设为nil，则显示一张空白图片
carouselView1.placeholderImage = nil;
```




## 设计思路

- 将3个imageView添加到scrollview上，左右2个imageview用于过渡，借助scrollview的`didEndDecelerating`代理方法监听滚动事件，并修改scrollView的contentOffset、修改三个imageView的image来实现无限轮播。相比于N+2个imageView的实现方式，内存占用更低。
- 不仅实现了无限滚动，也解决了滚动到最后一张图片时，下一次滚动效果丑陋的问题。
=======
将3个imageView添加到scrollview上，左右2个imageview用于过渡，借助scrollview的`didEndDecelerating`代理方法监听滚动事件，并修改scrollView的contentOffset、修改三个imageView的image来实现无限轮播。相比于N+2个imageView的实现方式，内存占用更低。
不仅实现了无限滚动，也解决了滚动到最后一张图片时，下一次滚动效果丑陋的问题。

