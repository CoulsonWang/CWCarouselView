//
//  ViewController.m
//  CWCarouselView
//
//  Created by Coulson_Wang on 2017/7/22.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ViewController.h"
#import "CWCarouselView.h"

@interface ViewController () <CWCarouselViewDelegate>

@property (weak, nonatomic) CWCarouselView *carouselView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect frame = CGRectMake(50, 100, 300, 150);
    
    // 通过本地图片创建
    UIImage *image1 = [UIImage imageNamed:@"img_01"];
    UIImage *image2 = [UIImage imageNamed:@"img_02"];
    UIImage *image3 = [UIImage imageNamed:@"img_03"];
    NSArray *imageArray = @[image1,image2,image3];
    CWCarouselView *carouselView1 = [CWCarouselView carouselViewWithFrame:frame imageGroup:imageArray];

    
    // 通过网络图片创建
    NSURL *url1 = [NSURL URLWithString:@"http://img2.niutuku.com/desk/1207/1005/ntk122731.jpg"];
    NSURL *url2 = [NSURL URLWithString:@"http://img2.niutuku.com/1312/0800/0800-niutuku.com-14339.jpg"];
    NSURL *url3 = [NSURL URLWithString:@"http://img2.niutuku.com/desk/anime/0529/0529-17277.jpg"];
    NSArray *urlArray = @[url1,url2,url3];
    CWCarouselView *carouselView2 = [CWCarouselView carouselViewWithFrame:frame imageUrls:urlArray placeholder:nil];
    
    // 通过block处理点击事件
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
    // 使用__weak修饰符避免循环引用
    __weak __typeof(self) weakSelf = self;
    carouselView2.operations = @[^{
        NSLog(@"%@",weakSelf.title);
    }];
    
    // 通过代理处理点击事件
    carouselView2.delegate = self;
    
    // 自定义轮播间隔
    carouselView2.interval = 1.0;
    
    // 禁止自动轮播
    carouselView1.interval = -1;
    
    // 自定义占位图片
    carouselView2.placeholderImage = [UIImage imageNamed:@"img_01"];
    
    // 空白的占位图片
    carouselView1.placeholderImage = nil;
    
    // 设置分页标签是否可见
    carouselView1.pageControlVisible = NO;
    
    // 设置分页标签的位置
    carouselView2.pageControlPostion = CWPageControlPostionMiddel;
    
    // 设置分页标签的主题色
    carouselView2.pageIndicatorTintColor = [UIColor redColor];
    carouselView2.currentPageIndicatorTintColor = [UIColor whiteColor];
    
    // 设置图片填充模式
    carouselView1.imageContentMode = UIViewContentModeScaleAspectFit;
    
    // 设置是否允许用户手动滚动
    carouselView2.allowDragging = NO;
    
    carouselView2.scrollDirection = CWScrollDirectionUp;
    
    [self.view addSubview:carouselView2];
    self.carouselView = carouselView2;

}



- (void)carouselView:(CWCarouselView *)carouselView didClickImageOnIndex:(NSUInteger)index {
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


@end
