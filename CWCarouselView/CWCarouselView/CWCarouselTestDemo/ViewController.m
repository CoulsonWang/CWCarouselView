//
//  ViewController.m
//  CWCarouselView
//
//  Created by Coulson_Wang on 2017/7/22.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ViewController.h"
#import "CWCarouselView.h"

@interface ViewController ()

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
    
    CWCarouselView *carouselView = [CWCarouselView carouselViewWithFrame:frame imageGroup:imageArray];
                                    
    [self.view addSubview:carouselView];
    self.carouselView = carouselView;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
