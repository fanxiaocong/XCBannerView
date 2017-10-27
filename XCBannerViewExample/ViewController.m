//
//  ViewController.m
//  XCBannerViewExample
//
//  Created by 樊小聪 on 2017/3/7.
//  Copyright © 2017年 樊小聪. All rights reserved.
//

#import "ViewController.h"

#import "XCBannerView.h"


#define IMAGENAMED(imageName)   [UIImage imageNamed:imageName]


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
    
    XCBannerView *banner = [[XCBannerView alloc] initWithFrame:CGRectMake(0, 200, self.view.bounds.size.width, 200)];
    
    banner.images = @[IMAGENAMED(@"1.jpg"), IMAGENAMED(@"2.jpg"), IMAGENAMED(@"3.jpg"), IMAGENAMED(@"4.jpg"), IMAGENAMED(@"5.jpg")];
    
    banner.didClickBannerCellHandel = ^(XCBannerCell *cell, NSInteger index){
        
        NSLog(@"点击到了第 %zi 页", index);
    };
    
    [banner startMoving];
    
    [self.view addSubview:banner];
}

@end
