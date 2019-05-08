//
//  KenImgScroll.m
//  TwoCycleTest
//
//  Created by admin on 2019/5/8.
//  Copyright © 2019 admin. All rights reserved.
//

#import "KenImgScroll.h"

#define kWidth self.bounds.size.width
#define kHeight self.bounds.size.height
static NSString * const kCellID = @"kCellID";


@interface KenScrollCell : UICollectionViewCell
@property(nonatomic,strong)UIImageView *imageView;
@end
@implementation KenScrollCell

+(instancetype)showKenScrollCellWithCollectionView:(UICollectionView *)collectionView andIndexPath:(NSIndexPath *)indexPath{
    static NSString *KenScrollCellID = kCellID;
    
    KenScrollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KenScrollCellID forIndexPath:indexPath];
    if (!cell) {
        cell = [[KenScrollCell alloc]initWithFrame:CGRectZero];
    }
    return cell;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUpCellUI];
    }
    return self;
}

-(void)setUpCellUI{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.bounds];
    [imageView setBackgroundColor:[UIColor lightGrayColor]];
    imageView.userInteractionEnabled = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:imageView];
    self.imageView = imageView;
}

@end

@interface KenImgScroll ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation KenImgScroll
#pragma mark - Initialize
- (instancetype)initWithFrame:(CGRect)frame
                andDataSource:(NSMutableArray *)dataSource
{
    if (self = [super initWithFrame:frame]) {
       
        [self setUpUI];
        
        self.dataSourceArray = dataSource;
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUpUI];
    }
    return self;
}

- (void)dealloc
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

#pragma mark - Private
- (void)setUpUI{
    self.backgroundColor = UIColor.lightGrayColor;
    [self addSubview:self.collectionView];
    [self addSubview:self.pageControl];
}

//开始计时器
- (void)startTimer{
    [self stopTimer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(collectionViewScrolll) userInfo:nil repeats:YES];
    
    //修改timer的 优先级（nstimer优先级比较低）
    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
    [runloop addTimer:self.timer  forMode:NSRunLoopCommonModes];
    
}
//关闭计时器
- (void)stopTimer{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}
#pragma mark - Public
//设置dataSourceArray 滚动数据源
- (void)setDataSourceArray:(NSMutableArray *)dataSourceArray{
    _dataSourceArray = dataSourceArray;
    
    if ([dataSourceArray[0] isKindOfClass:NSString.class]) {// 图片链接
        NSMutableArray *tempArr = [dataSourceArray mutableCopy];
        [dataSourceArray removeAllObjects];
        [tempArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIImage *tempImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:obj]]];
            
            [dataSourceArray addObject:tempImg];
        }];
    }
    
    [self.collectionView reloadData];
    self.pageControl.numberOfPages = dataSourceArray.count;
    [self startTimer];
}

#pragma mark - Events
//计时器自动滚动
- (void)collectionViewScrolll {
    CGFloat currentOffsetX = self.collectionView.contentOffset.x;
    CGFloat offsetX = kWidth + currentOffsetX;
    [self.collectionView setContentOffset:CGPointMake(offsetX, 0) animated:YES];

}
#pragma mark - Callback

#pragma mark - Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSourceArray.count * 10000;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    KenScrollCell *cell = [KenScrollCell showKenScrollCellWithCollectionView:collectionView andIndexPath:indexPath];
    
    // 有数据时设置图片
    if (self.dataSourceArray.count > 0) {
        // 取余数 获取数据
        cell.imageView.image = self.dataSourceArray[indexPath.item % self.dataSourceArray.count];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate imgClickEvent:indexPath.item % self.dataSourceArray.count + 1];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 获取滚动偏移量,
    // + scrollView.bounds.size.width *0.5 作用: 滚动超过屏幕一半宽度时 currentPage 就改变
    CGFloat offsetX = scrollView.contentOffset.x + scrollView.bounds.size.width *0.5;
    if (self.dataSourceArray.count > 0) {
        self.pageControl.currentPage = (NSInteger)(offsetX / kWidth) % self.dataSourceArray.count;
    }
}

// 当用户拖动时取消定时滚播
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopTimer];
}

// 当用户拖动结束开启定时滚播
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self startTimer];
}

#pragma mark - LazyLoad
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(kWidth, kHeight);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        //代理和数据源
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        //colectionView的一些设置
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES; //翻页？
        [_collectionView registerClass:[KenScrollCell class] forCellWithReuseIdentifier:@"kCellID"];

    }
    return _collectionView;
}

- (UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake((self.bounds.size.width - 100)*0.5, self.bounds.size.height - 40, 100, 20)];
        _pageControl.currentPage = 0;
        _pageControl.userInteractionEnabled = NO;
        _pageControl.numberOfPages = self.dataSourceArray.count;
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        [_pageControl setBackgroundColor:[UIColor lightGrayColor]];

    }
    return _pageControl;
}



@end
