//
//  ViewController.m
//  CWCarouselView
//
//  Created by Coulson_Wang on 2017/7/22.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ViewController.h"
#import "CWScrollView.h"

@interface ViewController ()

@property (weak, nonatomic) CWScrollView *scrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect frame = CGRectMake(50, 100, 300, 150);
    
    CWScrollView *scrollView = [[CWScrollView alloc] initWithFrame:frame];
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    UIImage *image1 = [UIImage imageNamed:@"img_01"];
    UIImage *image2 = [UIImage imageNamed:@"img_02"];
    UIImage *image3 = [UIImage imageNamed:@"img_03"];
    
    
    scrollView.imageGroup = @[image1, image2, image3];
    
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
