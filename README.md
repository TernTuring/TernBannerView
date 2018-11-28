# TernBannerView

## Requirements

- iOS 9.0+
- Xcode 10.0+

## Installation

Use [CocoaPods](https://cocoapods.org) with Podfile:

```
pod 'TernBannerView'
```

Then import the module in your code:

## Usage

1) Init View:

``` objective-c
TernBannerView *banner = [[TernBannerView alloc] init:TernBannerDataImage];
banner.delegate = self;
banner.dataSource = self;
banner.showPageController = YES;
banner.bannerHeight = 160;
banner.autoLoop = YES;
[banner setTranslatesAutoresizingMaskIntoConstraints:NO];
[self.view addSubview:banner];

NSDictionary *constraintsView = NSDictionaryOfVariableBindings(banner);

[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-50-[banner(160)]" options:0 metrics:nil views:constraintsView ]];
[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[banner]-0-|" options:0 metrics:nil views:constraintsView ]];
```

2) Implement   `TernBannerViewDelegate`  delegate in your class: 

``` objective-c
- (void)bannerView:(TernBannerView *)bannerView didSelectItemAtIndex:(NSInteger)index {

}
```

3) Implement `TernBannerViewDataSource`  datasource in your class: 

``` objective-c
- (NSInteger)numberItemsOfBanner:(TernBannerView *)bannerView {
    return 4;
}

- (UIImage *)bannerView:(TernBannerView *)bannerView cellForItemAtIndex:(NSInteger)index {
    return [UIImage imageNamed:@"banner.png"];
}
```

## Licence

CardSlider is released under the MIT license.
See [LICENSE](./LICENSE) for details.

