//
//  ViewController.m
//  TwoCycleTest
//
//  Created by admin on 2019/5/8.
//  Copyright © 2019 admin. All rights reserved.
//

#import "ViewController.h"
#import "KenImgScroll.h"
#import "KenDLImgScroll.h"
@interface ViewController ()<KenImgClickDelegate,YSImgClickDelegate>
@property(nonatomic,strong)UILabel *indicatorLbl;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    
    KenImgScroll *scrollView = [[KenImgScroll alloc]initWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width,200) andDataSource:@[
                                                                                                                                                 [UIImage imageNamed:@"img1"],
                                                                                                                                                 [UIImage imageNamed:@"img2"],
                                                                                                                                                 [UIImage imageNamed:@"img3"]
                                                                                                                                                 ].mutableCopy];
    [self.view addSubview:scrollView];
//    scrollView.dataSourceArray = @[
//                                  [UIImage imageNamed:@"img1"],
//                                  [UIImage imageNamed:@"img2"],
//                                  [UIImage imageNamed:@"img3"]
//                                  ].mutableCopy;
    
    scrollView.delegate = self;
    
    KenDLImgScroll *imgScroll = [KenDLImgScroll initWithFrame:CGRectMake(0, 300, [UIScreen mainScreen].bounds.size.width,200) hasTimer:YES interval:2.0];
    [self.view addSubview:imgScroll];
    imgScroll.dataSourceArray = @[
                                  [UIImage imageNamed:@"img1"],
                                  [UIImage imageNamed:@"img2"],
                                  [UIImage imageNamed:@"img3"]
                                  ].mutableCopy;
    imgScroll.delegate = self;
    
    
    UILabel *indicatorLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 600, self.view.frame.size.width, 40)];
    indicatorLbl.text = @"have not choose any pic";
    indicatorLbl.textColor = [UIColor blackColor];
    indicatorLbl.textAlignment = NSTextAlignmentCenter;
    indicatorLbl.font = [UIFont systemFontOfSize:30];
    [self.view addSubview:indicatorLbl];
    self.indicatorLbl = indicatorLbl;
    

}

- (void)imgClickEvent:(NSInteger)index{
    NSLog(@"you click %ld picture",index);
    self.indicatorLbl.text = [NSString stringWithFormat:@"you click %ld picture",index];
}



@end
