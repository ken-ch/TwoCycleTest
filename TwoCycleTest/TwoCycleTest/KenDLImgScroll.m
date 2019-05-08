//
//  KenDLImgScroll.m
//  TwoCycleTest
//
//  Created by admin on 2019/5/8.
//  Copyright © 2019 admin. All rights reserved.
//

#import "KenDLImgScroll.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <NerdyUI.h>
#import <Masonry.h>

#define kScreenWidth self.bounds.size.width
#define kHeight self.bounds.size.height
// 定义这个常量，就可以不用在开发过程中使用"mas_"前缀。
#define MAS_SHORTHAND
// 定义这个常量，就可以让Masonry帮我们自动把基础数据类型的数据，自动装箱为对象类型。
#define MAS_SHORTHAND_GLOBALS

@interface KenDLImgScroll()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) UIPageControl *mainPageControl;
@property (nonatomic, strong) NSMutableArray<UIImageView*> *imgViewArray;
@property (nonatomic, strong) UIImageView *leftImgView;
@property (nonatomic, strong) UIImageView *midImgView;
@property (nonatomic, strong) UIImageView *rightImgView;


@property (nonatomic, strong) NSTimer *timer;

@end

@implementation KenDLImgScroll
{
    CGFloat willEndContentOffsetX;
    CGFloat startContentOffsetX;
    NSInteger _imgIndex;// 当前图片资源
    BOOL _isWebImg;
}

#pragma mark - Initialize
+ (instancetype)initWithFrame:(CGRect)frame
                     hasTimer:(BOOL)hastimer
                     interval:(NSUInteger)inter{
    KenDLImgScroll *bannerScroll = [[KenDLImgScroll alloc]initWithFrame:frame];
    // 是否需要定时器
    bannerScroll.interval = inter;
    if (inter == 0) {
        bannerScroll.interval = 1.f;
    }
    return bannerScroll;
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self setUpUI];
        _imgIndex = 0;
        
    }
    return self;
}

#pragma mark - Private
-(void)setUpUI{
    
    [self addSubview:self.mainScrollView];
    
    _imgViewArray = @[].mutableCopy;
    int i = 0;
    while (i<3) {
        UIImageView *imgView = ImageView.bgColor(@"#F5F6FA").addTo(_mainScrollView);
        imgView.clipsToBounds = YES;
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        //        imgView.contentMode = UIViewContentModeScaleAspectFit;
        if (i == 0) {
            _leftImgView = imgView;
        }
        else if(i == 1){
            _midImgView = imgView;
        }
        else{
            _rightImgView = imgView;
        }
        
        [_leftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(self.mainScrollView);
            make.width.mas_equalTo(self.mas_width);
            
        }];
        [_midImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.leftImgView.mas_right);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(self.mainScrollView);
            make.width.mas_equalTo(self.mas_width);
        }];
        [_rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.midImgView.mas_right);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(self.mainScrollView);
            make.width.mas_equalTo(self.mas_width);
            make.right.mas_equalTo(0);
            
        }];
        
        i++;
    }
    
    self.mainPageControl.currentPage = 0;
    self.mainPageControl.addTo(self);
    [self.mainPageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
    }];
}

#pragma mark - Public
-(void)setDataSourceArray:(NSArray *)dataSourceArray{
    _dataSourceArray = dataSourceArray;
    self.mainPageControl.numberOfPages = dataSourceArray.count;
    
    if (dataSourceArray.count == 1) {
        if ([dataSourceArray[0] isKindOfClass:NSString.class]) {// 图片链接
            [_midImgView sd_setImageWithURL:dataSourceArray[0]];
            [_leftImgView sd_setImageWithURL:dataSourceArray[0]];
            [_rightImgView sd_setImageWithURL:dataSourceArray[0]];
            _isWebImg = YES;
            
        }
        else if ([dataSourceArray[0] isKindOfClass:UIImage.class]){// 本地图片
            _leftImgView.img(dataSourceArray[0]);
            _midImgView.img(dataSourceArray[0]);
            _rightImgView.img(dataSourceArray[0]);
        }
    }else{
        if ([dataSourceArray[0] isKindOfClass:NSString.class]) {// 图片链接
            [_leftImgView sd_setImageWithURL:dataSourceArray[dataSourceArray.count - 1]];
            [_midImgView sd_setImageWithURL:dataSourceArray[0]];
            [_rightImgView sd_setImageWithURL:dataSourceArray[1]];
            _isWebImg = YES;
            
        }
        else if ([dataSourceArray[0] isKindOfClass:UIImage.class]){// 本地图片
            _leftImgView.img(dataSourceArray[dataSourceArray.count - 1]);
            _midImgView.img(dataSourceArray[0]);
            _rightImgView.img(dataSourceArray[1]);
        }
    }
    [self startTimer];
}

#pragma mark -
- (void)startTimer{
    [self stopTimer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:_interval target:self selector:@selector(timerChanged) userInfo:nil repeats:YES];
    
    //修改timer的 优先级（nstimer优先级比较低）
    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
    [runloop addTimer:self.timer  forMode:NSRunLoopCommonModes];
    
    
}
- (void)timerChanged{
    if (self.mainScrollView.userInteractionEnabled == NO) {
        self.mainScrollView.userInteractionEnabled = YES;
    }
    
    
    CGPoint offset = self.mainScrollView.contentOffset;
    offset.x += self.mainScrollView.frame.size.width;
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         [self.mainScrollView setContentOffset:offset];
                     }completion:^(BOOL finished) {
                         if(self->_imgIndex==self.dataSourceArray.count - 1){
                             self->_imgIndex = self.mainPageControl.currentPage = 0;
                         }
                         else{
                             self->_imgIndex ++;
                             self.mainPageControl.currentPage ++;
                         }
                         
                         
                         [self viewChange];
                     }];
}

- (void)stopTimer{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark - Events
// 图片点击事件
-(void)scrollClick:(UITapGestureRecognizer *)sender{
    [self.delegate imgClickEvent:_imgIndex + 1];
    
}

#pragma mark - Callback
#pragma mark - Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self stopTimer];
    startContentOffsetX = scrollView.contentOffset.x;
    
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    willEndContentOffsetX = scrollView.contentOffset.x;
    [self startTimer];
    
    if (scrollView.userInteractionEnabled == YES) {
        scrollView.userInteractionEnabled = NO;
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat endContentOffsetX;
    
    if (scrollView.userInteractionEnabled == NO) {
        scrollView.userInteractionEnabled = YES;
    }
    endContentOffsetX = scrollView.contentOffset.x;
    if (endContentOffsetX < willEndContentOffsetX && willEndContentOffsetX < startContentOffsetX) {//画面从右往左移动，前一页
        if(_imgIndex==0){
            _imgIndex = self.mainPageControl.currentPage = self.dataSourceArray.count - 1;
            
        }
        else{
            _imgIndex --;
            self.mainPageControl.currentPage --;
        }
        
    } else if (endContentOffsetX > willEndContentOffsetX && willEndContentOffsetX > startContentOffsetX) {//画面从左往右移动，后一页
        
        if(_imgIndex==self.dataSourceArray.count - 1){
            _imgIndex = self.mainPageControl.currentPage = 0;
        }
        else{
            _imgIndex ++;
            self.mainPageControl.currentPage ++;
        }
    }
    [self viewChange];
    
}

// 视图修改
-(void)viewChange{
    [self imgDataChange];
    [self.mainScrollView setContentOffset:CGPointMake(kScreenWidth, 0) animated:NO];
}

-(void)imgDataChange{
    if (_imgIndex == 0) {
        _isWebImg?[_leftImgView sd_setImageWithURL:self.dataSourceArray[self.dataSourceArray.count - 1]]:
        [_leftImgView setImage:self.dataSourceArray[self.dataSourceArray.count - 1]];
    }
    else{
        _isWebImg?[_leftImgView sd_setImageWithURL:self.dataSourceArray[_imgIndex - 1]]:
        [_leftImgView setImage:self.dataSourceArray[_imgIndex - 1]];
        
    }
    
    _isWebImg?[_midImgView sd_setImageWithURL:self.dataSourceArray[_imgIndex]]:
    [_midImgView setImage:self.dataSourceArray[_imgIndex]];
    
    
    if (_imgIndex == self.dataSourceArray.count - 1) {
        _isWebImg?[_rightImgView sd_setImageWithURL:self.dataSourceArray[0]]:
        [_rightImgView setImage:self.dataSourceArray[0]];
    }
    else{
        _isWebImg?[_rightImgView sd_setImageWithURL:self.dataSourceArray[_imgIndex + 1]]:
        [_rightImgView setImage:self.dataSourceArray[_imgIndex + 1]];
    }
    
}
#pragma mark - Set&&Get

- (UIPageControl *)mainPageControl
{
    if (!_mainPageControl)
    {
        _mainPageControl = [[UIPageControl alloc] init];
        [_mainPageControl setBackgroundColor:[UIColor clearColor]];
        _mainPageControl.currentPage = 0;
        _mainPageControl.numberOfPages = self.dataSourceArray.count;
        [_mainPageControl addTarget:self action:@selector(pageControlValueChange:) forControlEvents:(UIControlEventValueChanged)];
    }
    
    return _mainPageControl;
}

- (UIScrollView *)mainScrollView{
    if (!_mainScrollView) {
        _mainScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _mainScrollView.bgColor(@"#F5F6FA");
        _mainScrollView.showsHorizontalScrollIndicator=NO;
        _mainScrollView.showsVerticalScrollIndicator=NO;
        _mainScrollView.pagingEnabled=YES;
        _mainScrollView.bounces=NO;
        _mainScrollView.delegate=self;
        //        _mainScrollView.contentOffset = CGPointMake(kScreenWidth, 0);
        _mainScrollView.contentSize = CGSizeMake(320*3, 0);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scrollClick:)];
        [_mainScrollView addGestureRecognizer:tap];
    }
    return _mainScrollView;
}

-(void)pageControlValueChange:(UIPageControl *)sender{
//    sender.currentPage
}


@end
