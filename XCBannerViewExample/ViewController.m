//
//  ViewController.m
//  XCBannerViewExample
//
//  Created by 樊小聪 on 2017/3/7.
//  Copyright © 2017年 樊小聪. All rights reserved.
//

#import "ViewController.h"

#import "XCBannerView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 设置 UI
    [self setupUI];
}

- (void)setupUI
{
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    XCBannerView *banner = [[XCBannerView alloc] initWithFrame:CGRectMake(0, 200, 300, 200)];
    
    banner.imgNames = @[@"1.jpg", @"2.jpg", @"3.jpg", @"4.jpg", @"5.jpg"];
    
    banner.didClickBannerCellHandel = ^(XCBannerCell *cell, NSInteger index){
        
        NSLog(@"点击到了第 %zi 页", index);
    };
    
    [banner startMoving];
    
    [self.view addSubview:banner];
}

@end
