//
//  ViewController.m
//  TernBannerViewDemo
//
//  Created by NSString on 2018/10/26.
//  Copyright © 2018 waterelle. All rights reserved.
//

#import "ViewController.h"
#import "TernBannerView.h"

@interface ViewController ()<TernBannerViewDelegate,TernBannerViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    TernBannerView *banner = [[TernBannerView alloc] init:0];
    banner.delegate = self;
    banner.dataSource = self;
    banner.showPageController = YES;
    banner.bannerHeight = 160;
    [banner setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:banner];
    
    NSDictionary *constraintsView = NSDictionaryOfVariableBindings(banner);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-50-[banner(160)]" options:0 metrics:nil views:constraintsView ]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[banner]-0-|" options:0 metrics:nil views:constraintsView ]];
}

- (void)bannerView:(TernBannerView *)bannerView didSelectItemAtIndex:(NSInteger)index {
    
}

- (NSInteger)numberItemsOfBanner:(TernBannerView *)bannerView {
    return 4;
}

- (UIView *)bannerView:(TernBannerView *)bannerView cellForItemAtIndex:(NSInteger)index {
    UIImageView *img = [[UIImageView alloc] init];
    img.image = [UIImage imageNamed:(0 == index%2)?@"banner.png":@"temp.png"];
    return img;
}


@end
