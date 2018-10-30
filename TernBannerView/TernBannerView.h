//
//  TernBannerView.h
//  BannerView
//
//  Created by TernTuring on 2018/10/17.
//  Copyright © 2018 TernTuring. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TernBannerDataType) {
    TernBannerDataImage,         // UIImageView
    TernBannerDataView,          // Any View, maybe UILabel
    TernBannerDataURL,           // UIImageView with URL
    TernBannerDataPath,          // UIImageView with Local Path
    TernBannerDataName,          // Image Name
};

@protocol TernBannerViewDataSource, TernBannerViewDelegate;

@interface TernBannerView : UIView

@property (nonatomic, weak, nullable) id <TernBannerViewDataSource> dataSource;
@property (nonatomic, weak, nullable) id <TernBannerViewDelegate> delegate;

@property (nonatomic, readwrite) TernBannerDataType type;

@property (nonatomic, readwrite) NSInteger bannerHeight;

@property (nonatomic, readwrite) NSInteger currentIndex;

@property (nonatomic, readwrite) BOOL autoLoop;


@property (nonatomic, readwrite) BOOL showPageController;

- (instancetype)initWithFrame:(CGRect)frame type:(TernBannerDataType)type NS_DESIGNATED_INITIALIZER;

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder type:(TernBannerDataType)type NS_DESIGNATED_INITIALIZER;

- (instancetype)init:(TernBannerDataType)type NS_DESIGNATED_INITIALIZER;
- (nullable instancetype)init NS_UNAVAILABLE;

- (void)reloadData;

- (void)invalidAutoLoop;

@end

@protocol TernBannerViewDataSource<NSObject>

@required

- (NSInteger)numberItemsOfBanner:(TernBannerView *)bannerView;

- (UIImage *)bannerView:(TernBannerView *)bannerView cellForItemAtIndex:(NSInteger)index;

@end

@protocol TernBannerViewDelegate<NSObject>

@optional

- (void)bannerView:(TernBannerView *)bannerView didSelectItemAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
