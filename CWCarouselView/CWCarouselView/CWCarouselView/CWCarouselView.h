//
//  CWScrollView.h
//  CWCarouselView
//
//  Created by Coulson_Wang on 2017/7/22.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWCarouselView : UIView

/**
 显示的图片数组
 */
@property (strong, nonatomic) NSArray<UIImage *> *imageGroup;
/**
 轮播间隔
 */
@property (assign, nonatomic) NSTimeInterval interval;
/**
 点击图片时执行的操作数组，若只传入一个操作，则点击所有图片均执行该操作
 */
@property (strong, nonatomic) NSArray<void (^)()> *operations;



- (instancetype)initWithFrame:(CGRect)frame imageGroup:(NSArray<UIImage *> *)imageGroup;

+ (instancetype)carouselViewWithFrame:(CGRect)frame imageGroup:(NSArray<UIImage *> *)imageGroup;

@end
