//
//  CWScrollView.m
//  CWCarouselView
//
//  Created by Coulson_Wang on 2017/7/22.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "CWCarouselView.h"
#import "CWImageView.h"
#import <SDWebImageManager.h>
#import <UIImageView+WebCache.h>
#import "UIView+CWFrame.h"

#define CWWidth self.bounds.size.width
#define CWHeight self.bounds.size.height

typedef enum : NSUInteger {
    CWScrollDirectionLeft = 0,
    CWScrollDirectionRight = 1
} CWScrollDirection;

@interface CWCarouselView () <UIScrollViewDelegate>

@property (weak, nonatomic) CWImageView *leftImageView;
@property (weak, nonatomic) CWImageView *middleImageView;
@property (weak, nonatomic) CWImageView *rightImageView;

@property (weak, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) UIPageControl *pageControl;

@property (assign, nonatomic) NSUInteger currentImageIndex;
@property (assign, nonatomic, readonly) NSUInteger leftImageIndex;
@property (assign, nonatomic, readonly) NSUInteger rightImageIndex;

@property (weak, nonatomic) NSTimer *timer;

@end

@implementation CWCarouselView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _pageControlVisible = YES;
    }
    return self;
}

- (void)removeFromSuperview {
    [self.timer invalidate];
    self.timer = nil;
    [super removeFromSuperview];
}

#pragma mark - 构造方法
// 构造方法
- (instancetype)initWithFrame:(CGRect)frame imageGroup:(NSArray<UIImage *> *)imageGroup {
    self = [self initWithFrame:frame];
    self.imageGroup = imageGroup;
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame imageUrls:(NSArray<NSURL *> *)imageUrls placeholder:(UIImage *)placeholder {
    self = [self initWithFrame:frame];
    self.placeholderImage = placeholder;
    self.imageUrls = imageUrls;
    return self;
}

// 工厂方法
+ (instancetype)carouselViewWithFrame:(CGRect)frame imageGroup:(NSArray<UIImage *> *)imageGroup {
    return [[CWCarouselView alloc] initWithFrame:frame imageGroup:imageGroup];
}

+ (instancetype)carouselViewWithFrame:(CGRect)frame imageUrls:(NSArray<NSURL *> *)imageUrls placeholder:(UIImage *)placeholder {
    return [[CWCarouselView alloc] initWithFrame:frame imageUrls:imageUrls placeholder:placeholder];
}


#pragma mark - setter和getter
- (void)setImageGroup:(NSArray<UIImage *> *)imageGroup {
    _imageGroup = imageGroup;
    // 容错处理
    if (!imageGroup) {
        return;
    }
    if (imageGroup.count == 0) {
        return;
    }
    if (imageGroup.count == 1) {
        CWImageView *imageView = [[CWImageView alloc] initWithFrame:self.bounds];
        imageView.image = imageGroup.firstObject;
        [self addSubview:imageView];
        return;
    }
    
    [self setUpAll];
}

- (void)setImageUrls:(NSArray<NSURL *> *)imageUrls {
    _imageUrls = imageUrls;
    
    NSMutableArray<UIImage *> *tempImageArray = [NSMutableArray array];
    
    // 开启一个gcd组
    dispatch_group_t group = dispatch_group_create();
    for (int i = 0; i < imageUrls.count; i++) {
        // 下载图片
        NSURL *url = imageUrls[i];
        // 添加一个任务到gcd组
        dispatch_group_enter(group);
        [[SDWebImageManager sharedManager] loadImageWithURL:url options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            // 将下载好的图片赋值给数组
            if (!error && image) {
                [tempImageArray addObject:image];
            } else {
                UIImage *placeholder = (self.placeholderImage == nil) ? [[UIImage alloc] init] : self.placeholderImage;
                [tempImageArray addObject:placeholder];
            }
            dispatch_group_leave(group);
        }];
    }
    // 所有下载任务完毕后才执行
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        self.imageGroup = tempImageArray;
    });
}

- (void)setInterval:(NSTimeInterval)interval {
    _interval = interval;
    [self setUpTimer];
}

- (void)setPageControlVisible:(BOOL)pageControlVisible {
    _pageControlVisible = pageControlVisible;
    
    [self updatePageControlProperty];
}

- (void)setPageControlPostion:(CWPageControlPostion)pageControlPostion {
    _pageControlPostion = pageControlPostion;
    
    [self updatePageControlProperty];
}

- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor {
    _pageIndicatorTintColor = pageIndicatorTintColor;
    
    [self updatePageControlProperty];
}

- (void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor {
    _currentPageIndicatorTintColor = currentPageIndicatorTintColor;
    
    [self updatePageControlProperty];
}

- (NSUInteger)leftImageIndex {
    return (_currentImageIndex == 0) ? self.imageGroup.count - 1 : _currentImageIndex - 1;
}

- (NSUInteger)rightImageIndex {
    return (_currentImageIndex == self.imageGroup.count - 1) ? 0 : _currentImageIndex + 1;
}

#pragma mark - 事件响应
-(void) imageTapped{
    
    [self.delegate carouselView:self didClickImageOnIndex:self.currentImageIndex];
    
    // 如果设置了代理，则不继续执行block方法
    if (self.delegate != nil) {
        return;
    }
    
    if (self.operations.count == 0) {
        return;
    }
    if (self.operations.count == 1) {
        if (self.operations.firstObject != nil) {
            self.operations.firstObject();
        }
        return;
    }
    
    if (self.operations.count == self.imageGroup.count) {
        void (^operation)() = self.operations[self.currentImageIndex];
        if (operation != nil) {
            operation();
        }
    }
    
}

#pragma mark - 初始化UI

- (void)setUpAll {
    [self setUpScrollView];
    
    [self setUpImageViews];
    
    [self updateScrollViewContentOffset];
    
    [self setUpPageControl];
    
    [self setUpTimer];
}
// 初始化scrollView
- (void)setUpScrollView {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    
    scrollView.contentSize = CGSizeMake(3 * CWWidth, 0);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
}

// 添加imageViews
- (void)setUpImageViews {
    self.leftImageView = [self addImageView:self.imageGroup.lastObject x:0];
    self.middleImageView = [self addImageView:self.imageGroup[0] x:CWWidth];
    self.rightImageView = [self addImageView:self.imageGroup[1] x:CWWidth * 2];
    
    __weak __typeof(self) weakSelf = self;
    self.middleImageView.operation = ^{
        [weakSelf imageTapped];
    };
}

// 初始化pageControl
- (void)setUpPageControl {
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    [self addSubview:pageControl];
    self.pageControl = pageControl;
    
    pageControl.hidesForSinglePage = YES;
    pageControl.userInteractionEnabled = NO;
    pageControl.numberOfPages = self.imageGroup.count;
    pageControl.currentPage = 0;
    
    [self updatePageControlProperty];
}

// 初始化定时器
- (void)setUpTimer {
    // 先清空，再设置
    [self.timer invalidate];
    self.timer = nil;
    
    // 特殊值,取消轮播
    if (self.interval == -1) {
        return;
    }
    
    NSTimeInterval interval = (self.interval == 0) ? 2.0 : self.interval;
    NSTimer *timer = [NSTimer timerWithTimeInterval:interval target:self selector:@selector(moveScrollView) userInfo:nil repeats:YES];
    [NSRunLoop.currentRunLoop addTimer:timer forMode:NSRunLoopCommonModes];
    
    self.timer = timer;
}

- (CWImageView *)addImageView:(UIImage *)image x:(CGFloat)x {
    CGRect frame = CGRectMake(x, 0, CWWidth, CWHeight);
    CWImageView *imageView = [[CWImageView alloc] initWithFrame:frame];
    imageView.image = image;
    [self.scrollView addSubview:imageView];
    
    return imageView;
}

#pragma mark - 更新UI

// 更新视图
- (void)updateCarousel:(CWScrollDirection)direction {
    [self updateScrollViewContentOffset];
    [self updateCurrentIndex:direction];
    [self updateImageViews];
    [self updatePageControlCurrentPage];
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

// 更新page当前圆点
- (void)updatePageControlCurrentPage {
    self.pageControl.currentPage = self.currentImageIndex;
}
// 更新分页标签对外属性
- (void)updatePageControlProperty {
    CGFloat pageControlHeight = 20.0;
    CGFloat pageControlWidth = self.imageGroup.count * 20;
    CGFloat pageControlX = 0;
    switch (self.pageControlPostion) {
        case CWPageControlPostionMiddel:
            pageControlX = (CWWidth - pageControlWidth) *0.5;
            break;
        case CWPageControlPostionLeft:
            pageControlX = 0;
            break;
        case CWPageControlPostionRight:
            pageControlX = CWWidth - pageControlWidth;
            break;
        default:
            break;
    }
    self.pageControl.frame = CGRectMake(pageControlX, CWHeight - pageControlHeight, pageControlWidth, pageControlHeight);
    self.pageControl.hidden = !self.pageControlVisible;
    self.pageControl.pageIndicatorTintColor = self.pageIndicatorTintColor;
    self.pageControl.currentPageIndicatorTintColor = self.currentPageIndicatorTintColor;
}

// 定期滚动
- (void)moveScrollView {
    [UIView animateWithDuration:0.5 animations:^{
        self.scrollView.contentOffset = CGPointMake(2 * CWWidth, 0);
    } completion:^(BOOL finished) {
        [self scrollViewDidEndDecelerating:self.scrollView];
    }];
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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.timer invalidate];
    self.timer = nil;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self setUpTimer];
}

@end
