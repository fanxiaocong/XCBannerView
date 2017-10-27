//
//  HeaderBannerView.m
//  DaJiaWang
//
//  Created by 樊小聪 on 16/6/3.
//  Copyright © 2016年 樊小聪. All rights reserved.
//

#import "XCBannerView.h"
//#import "UIImageView+WebCache.h"

#define MIN_MOVING_TIMEINTERVAL       0.1 //最小滚动时间间隔
#define DEFAULT_MOVING_TIMEINTERVAL   3.0 //默认滚动时间间隔
#define SELF_WIDTH              self.frame.size.width
#define SELF_HEIGHT             self.frame.size.height

/* 🐖 ***************************** 🐖 HeaderBannerCell 🐖 *****************************  🐖 */

@implementation XCBannerCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        // 设置默认参数
        [self setupDefaults];
    }
    
    return self;
}

// 设置默认参数
- (void)setupDefaults
{
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.bounds];
    
    imgView.contentMode   = UIViewContentModeScaleAspectFill;
    imgView.clipsToBounds = YES;
    
    _imgView = imgView;
    [self.contentView addSubview:imgView];
}

@end


/* 🐖 ***************************** 🐖 HeaderBannerView 🐖 *****************************  🐖 */

@interface XCBannerView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSTimer *timer;

/** 👀 是否需要 刷新 👀 */
@property (nonatomic, assign, getter=isNeedRefresh) BOOL needRefresh;

@end

static NSString * const identifier = @"identifier";

@implementation XCBannerView

#pragma mark - ⏳ 👀 LifeCycle Method 👀

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 👀 Init Method 👀 💤

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        // 设置默认参数
        [self setupDefaults];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
}



- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    if (self = [super initWithFrame:frame collectionViewLayout:layout])
    {
        // 设置默认参数
        [self setupDefaults];
    }
    
    return self;
}

// 设置默认参数
- (void)setupDefaults
{
    self.delegate      = self;
    self.dataSource    = self;
    self.pagingEnabled = YES;
    self.autoMoving    = YES;
    
    self.placeholderImgName = @"empty_picture.png";
    self.backgroundColor    = [UIColor whiteColor];
    
    self.showsHorizontalScrollIndicator = NO;
    
    if ([self.collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]])
    {
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
        layout.scrollDirection         = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing      = 0;
        layout.minimumInteritemSpacing = 0;
        layout.itemSize                = CGSizeMake(SELF_WIDTH, SELF_HEIGHT);

    }
    
    // 注册
    [self registerNofitication];
}

- (void)layoutSubviews
{
    if (self.isNeedRefresh)
    {
        if (self.imgURLs.count || self.images.count)
        {
            //最左边一张图其实是最后一张图，因此移动到第二张图，也就是imageURL的第一个URL的图。
            [self scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
            self.needRefresh = NO;
        }
    }
    
    [super layoutSubviews];
}

#pragma mark - 👀 Setter Method 👀 💤

- (void)setImgURLs:(NSArray *)imgURLs
{
    _imgURLs = imgURLs;
    
    if ([imgURLs count])
    {
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObject:[imgURLs lastObject]];
        [arr addObjectsFromArray:imgURLs];
        [arr addObject:[imgURLs firstObject]];
        _imgURLs = [NSArray arrayWithArray:arr];
    }
    
    [self reloadData];
    
    _needRefresh = YES;
}

- (void)setImages:(NSArray<UIImage *> *)images
{
    _images = images;
    
    if ([images count])
    {
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObject:[images lastObject]];
        [arr addObjectsFromArray:images];
        [arr addObject:[images firstObject]];
        _images = [NSArray arrayWithArray:arr];
    }
    
    [self reloadData];
    
    _needRefresh = YES;
}

#pragma mark - 📕 👀 UICollectionDataSource 👀

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = self.images.count ?: self.imgURLs.count;
    
    return MAX(count, 1);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XCBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    if (self.images.count > indexPath.row)
    {
        cell.imgView.image = self.images[indexPath.item];
                
    }
    else if (self.imgURLs.count > indexPath.row)
    {
        NSString *urlStr = self.imgURLs[indexPath.item];
        
        if (self.configureCellWebImage)
        {
            self.configureCellWebImage(cell.imgView, [NSURL URLWithString:urlStr]);
        }
    }
    else
    {
        // 当没有图片时, 显示占位图片
        cell.imgView.image = [UIImage imageNamed:self.placeholderImgName];
    }
    
    return cell;
}


#pragma mark - 💉 👀 UICollectionDelegate 👀

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger page = 0;
    NSUInteger lastIndex = (self.images.count) ? (self.images.count - 3) : (self.imgURLs.count - 3);
    
    if (indexPath.item == 0)
    {
        page = lastIndex;
    }
    else if (indexPath.item == lastIndex)
    {
        page = 0;
    }
    else
    {
        page = indexPath.item - 1;
    }

    XCBannerCell *cell = (XCBannerCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if (self.didClickBannerCellHandel)
    {
        self.didClickBannerCellHandel(cell, indexPath.row-1);
    }
}

#pragma mark - 💉 👀 UIScrollerViewDelegate 👀

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [self jumpWithContentOffset:scrollView.contentOffset];
    
    [self calculateIndex:scrollView];
}

//用户手动拖拽，暂停一下自动轮播
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeTimer];
}

//用户拖拽完成，恢复自动轮播（如果需要的话）并依据滑动方向来进行相对应的界面变化
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.isAutoMoving)
    {
        [self addTimer];
    }
    
    [self jumpWithContentOffset:scrollView.contentOffset];
}

#pragma mark - 🎬 👀 Action Method 👀

// 程序被暂停的时候，应该停止计时器
- (void)applicationWillResignActive
{
    [self stopMoving];
}

// 程序从暂停状态回归的时候，重新启动计时器
- (void)applicationDidBecomeActive
{
    if (self.isAutoMoving)
    {
        [self startMoving];
    }
}

#pragma mark - 🔒 👀 Privite Method 👀

- (void)registerNofitication
{
    [self registerClass:[XCBannerCell class] forCellWithReuseIdentifier:identifier];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

// 移动到 下一个 cell
- (void)moveToNextCell
{
    if (self.imgURLs.count || self.images.count)
    {
        NSIndexPath *currentIndexPath = [self indexPathForItemAtPoint:self.contentOffset];
        
        NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:currentIndexPath.item + 1
                                                         inSection:currentIndexPath.section];
        
        [self scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}



- (void)jumpToLastImage
{
    NSInteger count = self.images.count ? (self.images.count - 2) : (self.imgURLs.count - 2);
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:count inSection:0];
    [self scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

- (void)jumpToFirstImage
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:1 inSection:0];
    [self scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

- (void)jumpWithContentOffset:(CGPoint)contentOffset
{
    NSInteger count = self.images.count ? self.images.count : self.imgURLs.count;

    //向左滑动时切换imageView
    if (contentOffset.x <= 0)
    {
        [self jumpToLastImage];
    }
    //向右滑动时切换imageView
    if (contentOffset.x >= (count - 1) * SELF_WIDTH)
    {
        [self jumpToFirstImage];
    }
}


// 计算滚动的页码
- (void)calculateIndex:(UIScrollView *)scrollView
{
    NSInteger index = (NSInteger)scrollView.contentOffset.x / SELF_WIDTH - 1;
    XCBannerCell *cell = (XCBannerCell *)[self cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    
    if (self.didMoveToCell)
    {
        self.didMoveToCell(cell, index);
    }
}


// 添加 定时器
- (void)addTimer
{
    if (self.timer)
    {
        [self removeTimer];
    }
    
    NSTimeInterval speed = self.movingTimeInterval < MIN_MOVING_TIMEINTERVAL ? DEFAULT_MOVING_TIMEINTERVAL : self.movingTimeInterval;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:speed target:self selector:@selector(moveToNextCell) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}



// 移除 定时器
- (void)removeTimer
{
    [self.timer invalidate];
    
    self.timer = nil;
}


#pragma mark - 🔓 👀 Public Method 👀

- (void)startMoving
{
    [self addTimer];
}


- (void)stopMoving
{
    [self removeTimer];
}

@end




