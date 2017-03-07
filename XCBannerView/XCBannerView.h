//
//  HeaderBannerView.h
//  DaJiaWang
//
//  Created by 樊小聪 on 16/6/3.
//  Copyright © 2016年 樊小聪. All rights reserved.
//

#import <UIKit/UIKit.h>

/* 🐖 ***************************** 🐖 HeaderBannerCell 🐖 *****************************  🐖 */

@interface XCBannerCell : UICollectionViewCell

/** 👀 图片 👀 */
@property (weak, nonatomic, readonly) UIImageView *imgView;

@end


/* 🐖 ***************************** 🐖 HeaderBannerView 🐖 *****************************  🐖 */

@interface XCBannerView : UICollectionView

/** 👀 点击了 banner 视图中某一个 cell 👀 */
@property (copy, nonatomic) void(^didClickBannerCellHandel)(XCBannerCell *cell, NSInteger index);

/** 👀 移动到某一个 cell(会调用多次) 👀 */
@property (copy, nonatomic) void(^didMoveToCell)(XCBannerCell *cell, NSInteger index);

/** 👀 占位图片名 👀 */
@property (copy, nonatomic) NSString *placeholderImgName;

/** 👀 滚动速率 默认为3.0 即3秒翻页一次 👀 */
@property (assign, nonatomic) NSTimeInterval movingTimeInterval;

/** 👀 是否自动轮播,默认为YES 👀 */
@property (assign, nonatomic, getter=isAutoMoving) BOOL autoMoving;

/** 👀 图片的 URL 数组 👀 */
@property (strong, nonatomic) NSArray<NSString *> *imgURLs;

/** 👀 图片的名称数组 👀 */
@property (strong, nonatomic) NSArray<NSString *> *imgNames;



/**
 *  开始移动
 */
- (void)startMoving;

/**
 *  停止移动
 */
- (void)stopMoving;

@end

















