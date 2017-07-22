//
//  CWScrollView.m
//  CWCarouselView
//
//  Created by Coulson_Wang on 2017/7/22.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "CWScrollView.h"

#define CWWidth self.bounds.size.width
#define CWHeight self.bounds.size.height

@interface CWScrollView ()

@property (weak, nonatomic) UIImageView *leftImageView;
@property (weak, nonatomic) UIImageView *middleImageView;
@property (weak, nonatomic) UIImageView *rightImageView;

@end

@implementation CWScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentSize = CGSizeMake(3 * frame.size.width, 0);
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.pagingEnabled = YES;
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
    return [[CWScrollView alloc] initWithFrame:frame imageGroup:imageGroup];
}


- (void)setImageGroup:(NSArray<UIImage *> *)imageGroup {
    _imageGroup = imageGroup;
    if (imageGroup.count <= 0) {
        return;
    }
    
    if (imageGroup.count >= 3) {
        self.leftImageView = [self addImageView:imageGroup.lastObject x:0];
        
        self.middleImageView = [self addImageView:imageGroup[0] x:CWWidth];
        
        self.rightImageView = [self addImageView:imageGroup[1] x:CWWidth * 2];
        
        self.contentOffset = CGPointMake(CWWidth, 0);
        
    }
}



#pragma mark - 私有工具方法
- (UIImageView *)addImageView:(UIImage *)image x:(CGFloat)x {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(x, 0, CWWidth, CWHeight);
    [self addSubview:imageView];
    
    return imageView;
}

@end
