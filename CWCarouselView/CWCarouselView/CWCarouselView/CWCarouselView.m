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

typedef enum : NSUInteger {
    CWScrollDirectionLeft = 0,
    CWScrollDirectionRight = 1
} CWScrollDirection;

@interface CWCarouselView () <UIScrollViewDelegate>

@property (weak, nonatomic) UIImageView *leftImageView;
@property (weak, nonatomic) UIImageView *middleImageView;
@property (weak, nonatomic) UIImageView *rightImageView;

@property (weak, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) UIPageControl *pageControl;

@property (assign, nonatomic) NSUInteger currentImageIndex;
@property (assign, nonatomic, readonly) NSUInteger leftImageIndex;
@property (assign, nonatomic, readonly) NSUInteger rightImageIndex;

@end

@implementation CWCarouselView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
  
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
    // 容错处理
    if (imageGroup.count == 0) {
        return;
    }
    if (imageGroup.count == 1) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.image = imageGroup.firstObject;
        [self addSubview:imageView];
        return;
    }
    
    [self setUpScrollView];
    
    self.leftImageView = [self addImageView:imageGroup.lastObject x:0];
    self.middleImageView = [self addImageView:imageGroup[0] x:CWWidth];
    self.rightImageView = [self addImageView:imageGroup[1] x:CWWidth * 2];
    
    [self updateScrollViewContentOffset];
    
    [self setUpPageControl];
}

- (NSUInteger)leftImageIndex {
    return (_currentImageIndex == 0) ? self.imageGroup.count - 1 : _currentImageIndex - 1;
}

- (NSUInteger)rightImageIndex {
    return (_currentImageIndex == self.imageGroup.count - 1) ? 0 : _currentImageIndex + 1;
}


#pragma mark - 初始化UI
- (void)setUpScrollView {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView = scrollView;
    [self addSubview:scrollView];
    
    scrollView.contentSize = CGSizeMake(3 * CWWidth, 0);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
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

#pragma mark - 更新UI

// 更新视图
- (void)updateCarousel:(CWScrollDirection)direction {
    [self updateScrollViewContentOffset];
    [self updateCurrentIndex:direction];
    [self updateImageViews];
    [self updatePageControl];
}

// 将scrollView的contentOffset恢复到初始位置
- (void)updateScrollViewContentOffset {
    self.scrollView.contentOffset = CGPointMake(CWWidth, 0);
}

// 更新currentIndex
- (void)updateCurrentIndex:(CWScrollDirection)direction {
    if (direction == CWScrollDirectionLeft) {
        _currentImageIndex = (_currentImageIndex == 0) ? self.imageGroup.count - 1 : _currentImageIndex - 1;
    } else if (direction == CWScrollDirectionRight) {
        _currentImageIndex = (_currentImageIndex == self.imageGroup.count - 1) ? 0 : _currentImageIndex + 1;
    }
}

// 更新所有imageView
- (void)updateImageViews {
    self.leftImageView.image = self.imageGroup[self.leftImageIndex];
    self.middleImageView.image = self.imageGroup[_currentImageIndex];
    self.rightImageView.image = self.imageGroup[self.rightImageIndex];
}

// 更新page圆点
- (void)updatePageControl {
    self.pageControl.currentPage = self.currentImageIndex;
}

#pragma mark - ScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    if (offsetX == 0) {
        // 向左滑动
        [self updateCarousel:CWScrollDirectionLeft];
    } else if (offsetX == 2 * CWWidth) {
        // 向右滑动
        [self updateCarousel:CWScrollDirectionRight];
        
    }
}

@end
