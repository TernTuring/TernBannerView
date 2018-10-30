//
//  BannerItemViewCell.m
//  BannerView
//
//  Created by TernTuring on 2018/10/17.
//  Copyright © 2018 TernTuring. All rights reserved.
//

#import "BannerItemViewCell.h"

@interface BannerItemViewCell ()

@property (nonatomic, strong) UIImageView *display;

@end

@implementation BannerItemViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIImageView *img = [[UIImageView alloc] init];
        //[img setContentMode:UIViewContentModeScaleAspectFit];
        [img setTranslatesAutoresizingMaskIntoConstraints:NO];
        _display = img;
        [self.contentView addSubview:img];
        
        NSDictionary *constraintsView = NSDictionaryOfVariableBindings(img);
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[img]-0-|" options:0 metrics:nil views:constraintsView ]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[img]-0-|" options:0 metrics:nil views:constraintsView ]];
        
    }
    return self;
}

- (void)initCellValue:(UIImage *)display
{
    if (nil != display) {
        _display.image = display;
    }
}

@end
