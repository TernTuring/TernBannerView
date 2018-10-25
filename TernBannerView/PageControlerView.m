//
//  PageControlerView.m
//  BannerView
//
//  Created by TernTuring on 2018/10/17.
//  Copyright © 2018 TernTuring. All rights reserved.
//

#import "PageControlerView.h"

@interface PageControlerView ()

@property (strong, nonatomic) NSMutableArray *allItems;
@property (assign, nonatomic) NSInteger adviseWidth;

@end

@implementation PageControlerView

- (id)initWithCount:(NSInteger)counts {
    self = [super init];
    if (self) {
        
        _currentPage = 0;
        _allItems = [[NSMutableArray alloc] initWithCapacity:100];
        
        UIView *prevLine = nil;
        
        for (NSInteger j = 0; j < counts; j++) {
            
            NSArray *widthConstraints = nil;
            
            UIView *line = [[UIView alloc] init];
            [line setBackgroundColor:[UIColor whiteColor]];
            line.layer.cornerRadius = 2.0f;
            [line setTranslatesAutoresizingMaskIntoConstraints:NO];
            
            [self addSubview:line];
            
            NSDictionary *constraintsView = (nil == prevLine) ?
                        NSDictionaryOfVariableBindings(line):NSDictionaryOfVariableBindings(prevLine, line);
            
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[line]-0-|" options:0 metrics:nil views:constraintsView ]];
            widthConstraints = [[NSArray alloc] initWithObjects:[NSLayoutConstraint constraintWithItem:line
                                                                                             attribute:NSLayoutAttributeHeight
                                                                                             relatedBy:NSLayoutRelationEqual
                                                                                                toItem:nil
                                                                                             attribute:NSLayoutAttributeHeight
                                                                                            multiplier:1
                                                                                              constant:8],nil];
            [self addConstraints:widthConstraints];
            
            if (0 == j) {
                [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[line]" options:0 metrics:nil views:constraintsView ]];
                
            } else if (j == (counts - 1)){
                [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[prevLine]-4-[line(==prevLine)]-0-|" options:0 metrics:nil views:constraintsView ]];
                
            } else {
                [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[prevLine]-4-[line(==prevLine)]" options:0 metrics:nil views:constraintsView ]];
                
            }
            
            prevLine = line;
            
            [_allItems addObject:@[line,widthConstraints]];
        }
        
        _adviseWidth = 4*(counts+(counts-1));
    }
    
    return self;
}

- (void)setCurrentPage:(NSInteger)currentPage {

    [self updatePageIndex:_currentPage color:[UIColor whiteColor] height:8];
    
    _currentPage = currentPage;
    
    [self updatePageIndex:_currentPage color:[UIColor redColor] height:13];
}

- (void)updatePageIndex:(NSInteger)index color:(UIColor *)color height:(NSInteger)height {
    if (index >= 0 && [self.allItems count] > 0 && index < [self.allItems count] ) {
        NSArray *array = [self.allItems objectAtIndex:index];
        UIView *line = [array objectAtIndex:0];
        NSArray *widthConstraints = [array objectAtIndex:1];
        [line setBackgroundColor:color];
        
        [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            [self removeConstraints:widthConstraints];
            [self addConstraints:widthConstraints];
            for (NSLayoutConstraint *c in widthConstraints) {
                c.constant = height;
            }
            
            [self layoutIfNeeded];
            
        } completion:^(BOOL finished) {

        }];
        
    }
}

#pragma mark - Action

- (CGFloat)pageAdviseWidth {
    return _adviseWidth;
}

@end
