//
//  KenDLImgScroll.h
//  TwoCycleTest
//
//  Created by admin on 2019/5/8.
//  Copyright © 2019 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol YSImgClickDelegate <NSObject>


/**
 轮播图点击事件
 
 @param index 被点击图片位置
 */
-(void)imgClickEvent:(NSInteger)index;

@end
@interface KenDLImgScroll : UIView

/**
 图片点击事件
 */
@property (nonatomic, weak) id<YSImgClickDelegate> delegate;

/// 数据源
@property (nonatomic, strong) NSArray *dataSourceArray;

@property (nonatomic, assign)  NSTimeInterval interval;

/**
 *  类初始化方法；
 *
 */
+ (instancetype)initWithFrame:(CGRect)frame
                     hasTimer:(BOOL)hastimer
                     interval:(NSUInteger)inter;

@end

NS_ASSUME_NONNULL_END
