//
//  KenImgScroll.h
//  TwoCycleTest
//
//  Created by admin on 2019/5/8.
//  Copyright © 2019 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol KenImgClickDelegate <NSObject>
/**
 轮播图点击事件
 
 @param index 被点击图片位置
 */
-(void)imgClickEvent:(NSInteger)index;

@end

@interface KenImgScroll : UIView
@property(nonatomic,strong)NSMutableArray *dataSourceArray;

@property(nonatomic,weak)id <KenImgClickDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame
               andDataSource:(NSMutableArray *)dataSource;

@end

NS_ASSUME_NONNULL_END
