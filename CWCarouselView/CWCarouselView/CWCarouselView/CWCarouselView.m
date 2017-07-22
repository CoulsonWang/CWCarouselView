//
//  CWScrollView.m
//  CWCarouselView
//
//  Created by Coulson_Wang on 2017/7/22.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "CWCarouselView.h"

#define CWWidth self.bounds.size.width
#define CWHeight self.bounds.size.height

@interface CWCarouselView () <UIScrollViewDelegate>

@property (weak, nonatomic) UIImageView *leftImageView;
@property (weak, nonatomic) UIImageView *middleImageView;
@property (weak, nonatomic) UIImageView *rightImageView;

@property (weak, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) UIPageControl *pageControl;

@end

@implementation CWCarouselView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self setUpScrollView];
        
        self.scrollView.delegate = self;
    }
    return self;
}

// 快速构造方法
- (instancetype)initWithFrame:(CGRect)frame imageGroup:(NSArray<UIImage *> *)imageGroup {
    self = [self initWithFrame:frame];
    self.imageGroup = imageGroup;
    return self;
}

// 工厂方法
+ (instancetype)carouselViewWithFrame:(CGRect)frame imageGroup:(NSArray<UIImage *> *)imageGroup {
    return [[CWCarouselView alloc] initWithFrame:frame imageGroup:imageGroup];
}

#pragma mark - setter和getter
- (void)setImageGroup:(NSArray<UIImage *> *)imageGroup {
    _imageGroup = imageGroup;
    if (imageGroup.count == 0) {
        return;
    }
    
    if (imageGroup.count >= 3) {
        self.leftImageView = [self addImageView:imageGroup.lastObject x:0];
        
        self.middleImageView = [self addImageView:imageGroup[0] x:CWWidth];
        
        self.rightImageView = [self addImageView:imageGroup[1] x:CWWidth * 2];
        
        self.scrollView.contentOffset = CGPointMake(CWWidth, 0);
        
        
        
    }
    
    [self setUpPageControl];
}



#pragma mark - 私有工具方法
- (void)setUpScrollView {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView = scrollView;
    [self addSubview:scrollView];
    
    scrollView.contentSize = CGSizeMake(3 * CWWidth, 0);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
}

- (void)setUpPageControl {
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = self.imageGroup.count;
    pageControl.currentPage = 0;
    pageControl.hidesForSinglePage = YES;
    pageControl.userInteractionEnabled = NO;
    
    CGFloat pageControlHeight = 20.0;
    CGFloat pageControlWidth = 100;
    pageControl.frame = CGRectMake(0, CWHeight - pageControlHeight, pageControlWidth, pageControlHeight);
    
    [self addSubview:pageControl];
    self.pageControl = pageControl;
}

- (UIImageView *)addImageView:(UIImage *)image x:(CGFloat)x {
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(x, 0, CWWidth, CWHeight);
    [self.scrollView addSubview:imageView];
    
    return imageView;
}

#pragma mark - ScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
}

@end
