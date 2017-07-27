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
    
    UIImage *image1 = [UIImage imageNamed:@"img_01"];
    UIImage *image2 = [UIImage imageNamed:@"img_02"];
    UIImage *image3 = [UIImage imageNamed:@"img_03"];
    UIImage *image4 = [UIImage imageNamed:@"img_04"];
    UIImage *image5 = [UIImage imageNamed:@"img_05"];
    
    NSArray *imageArray = @[image1,image2,image3,image4,image5];
    
    CWCarouselView *carouselView1 = [CWCarouselView carouselViewWithFrame:frame imageGroup:imageArray];
    
    NSURL *url1 = [NSURL URLWithString:@"http://img2.niutuku.com/desk/1207/1005/ntk122731.jpg"];
    NSURL *url2 = [NSURL URLWithString:@"http://img2.niutuku.com/1312/0800/0800-niutuku.com-14339.jpg"];
    NSURL *url3 = [NSURL URLWithString:@"http://img2.niutuku.com/desk/anime/0529/0529-17277.jpg"];
    NSURL *url4 = [NSURL URLWithString:@"http://img2.niutuku.com/desk/1208/1450/ntk-1450-9891.jpg"];
    NSURL *url5 = [NSURL URLWithString:@"http://bizhi.zhuoku.com/2013/08/22/zhuoku/zhuoku050.jpg"];
    
    NSArray *urlArray = @[url1,url2,url3,url4,url5];
    UIImage *placeholder = [UIImage imageNamed:@"img_01"];
    CWCarouselView *carouselView2 = [CWCarouselView carouselViewWithFrame:frame imageUrls:urlArray placeholder:placeholder];
    
    
    carouselView2.delegate = self;
                                    
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
        case 3:
            NSLog(@"点击了第4张图片");
            break;
        case 4:
            NSLog(@"点击了第5张图片");
            break;
            
        default:
            break;
    }
}


@end
