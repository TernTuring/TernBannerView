//
//  PageControlerView.h
//  BannerView
//
//  Created by TernTuring on 2018/10/17.
//  Copyright © 2018 TernTuring. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PageControlerView : UIView

@property (assign, nonatomic) NSInteger currentPage;

- (id)initWithCount:(NSInteger)counts;

- (CGFloat)pageAdviseWidth;

@end

NS_ASSUME_NONNULL_END
