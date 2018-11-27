//
//  TernBannerView.m
//  BannerView
//
//  Created by TernTuring on 2018/10/17.
//  Copyright © 2018 TernTuring. All rights reserved.
//

#import "TernBannerView.h"
#import "PageControlerView.h"
#import "BannerItemViewCell.h"

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)

static const NSInteger kTernLoopMax = 100;
static const NSInteger kTernCellHeight = 100;

@interface TernBannerView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *bannersView;

@property (nonatomic, strong) NSMutableArray *bannersIndex;
@property (nonatomic, strong) NSMutableArray *bannersItem;

@property (nonatomic, strong) PageControlerView *pageControllerView;
@property (nonatomic, strong) NSTimer *bannersTimer;

@end

@implementation TernBannerView

#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame type:TernBannerDataImage];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    return [self initWithCoder:aDecoder type:TernBannerDataImage];
}

- (instancetype)initWithFrame:(CGRect)frame type:(TernBannerDataType)type {
    self = [super initWithFrame:frame];
    if (self) {
        
        _currentIndex = 0;
        _type = type;
        _bannersIndex = [[NSMutableArray alloc]initWithCapacity:100];
        _bannersItem = [[NSMutableArray alloc]initWithCapacity:100];
    }
    
    return self;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-designated-initializers"
- (instancetype)init:(TernBannerDataType)type {
    self = [super init];
    if (self) {
        
        _currentIndex = 0;
        _type = type;
        _bannersIndex = [[NSMutableArray alloc]initWithCapacity:100];
        _bannersItem = [[NSMutableArray alloc]initWithCapacity:100];
    }
    
    return self;
}
#pragma clang diagnostic pop

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder type:(TernBannerDataType)type{
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        _currentIndex = 0;
        _bannersIndex = [[NSMutableArray alloc]initWithCapacity:100];
        _bannersItem = [[NSMutableArray alloc]initWithCapacity:100];
        
    }
    
    return self;
    
}

- (void)layoutSubviews {
    static dispatch_once_t once = 0;
    dispatch_once(&once, ^{
        [self initBannerView];
        if (self.showPageController) {
            [self initPageControlerView];
        }
        
        //[self setNeedsLayout];
        [self reloadData];
    });
}

#pragma mark - InitView
- (void)initBannerView {
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0,0,0) collectionViewLayout:flowLayout];
    [collectionView registerClass:[BannerItemViewCell class]
       forCellWithReuseIdentifier:@"BannerItemViewCell"];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.userInteractionEnabled = YES;
    collectionView.scrollEnabled = YES;
    collectionView.pagingEnabled = YES;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    [collectionView setTranslatesAutoresizingMaskIntoConstraints:NO];
    _bannersView = collectionView;
    [self addSubview: collectionView];
    
    NSDictionary *constraintsView = NSDictionaryOfVariableBindings(collectionView);
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[collectionView]-0-|" options:0 metrics:nil views:constraintsView ]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[collectionView]-0-|" options:0 metrics:nil views:constraintsView ]];
}

- (void)initPageControlerView {
    
    PageControlerView *pageControl = [[PageControlerView alloc] initWithCount:[self getBannerNums]];
    [pageControl setTranslatesAutoresizingMaskIntoConstraints:NO];
    _pageControllerView = pageControl;
    [self addSubview: pageControl];
    
    NSDictionary *constraintsView = NSDictionaryOfVariableBindings(pageControl);
    
    NSString *vflStr = [NSString stringWithFormat:@"H:[pageControl(%f)]",[pageControl pageAdviseWidth]>0?[pageControl pageAdviseWidth]:50];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[pageControl(20)]-30-|" options:0 metrics:nil views:constraintsView ]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vflStr options:0 metrics:nil views:constraintsView ]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:pageControl attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    pageControl.currentPage = 0;
}


#pragma mark - Collection View Data Source And Delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.bannersIndex count];
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *bannerCellIdentifier = @"BannerItemViewCell";
    
    UICollectionViewCell *myCell = nil;
    NSInteger row = [indexPath row];
    
    myCell = [collectionView dequeueReusableCellWithReuseIdentifier:bannerCellIdentifier
                                                       forIndexPath:indexPath];
    
    BannerItemViewCell *cell = (BannerItemViewCell *)myCell;
    
    if (row < [self.bannersIndex count]) {
        NSNumber *index = [self.bannersIndex objectAtIndex:row];
        if (nil != index) {
            NSInteger indexValue = [index integerValue]%kTernLoopMax;
            if (indexValue < [self.bannersItem count]) {
                UIImage *img = [self.bannersItem objectAtIndex:indexValue];
                if ([img isKindOfClass:[UIImage class]]) {
                    [cell initCellValue:img];
                }
            }
        }
    }
    
    return myCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_WIDTH, 0 != _bannerHeight ? _bannerHeight : kTernCellHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - Page Scrool delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSInteger page = scrollView.contentOffset.x/SCREEN_WIDTH;
    page = page%[self getBannerNums];

    if (nil != self.pageControllerView && page !=  self.pageControllerView.currentPage && page < [self getBannerNums]) {
        _pageControllerView.currentPage = page;
    }
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([self.bannersIndex count] > 1) {
        if (nil == self.bannersTimer) {
            [self startTimer];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger page = scrollView.contentOffset.x/SCREEN_WIDTH;
    page = page%[self getBannerNums];
    
    if (nil != _pageControllerView && page !=  _pageControllerView.currentPage && page < [self getBannerNums]) {
        _pageControllerView.currentPage = page;
    }
    
    [_bannersView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:kTernLoopMax/2*[self getBannerNums]+page inSection:0]  atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:false];
}

#pragma mark - Set Action
- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    if (currentIndex < [self getBannerNums]) {
        _pageControllerView.currentPage = currentIndex;
    }
}

- (void)setAutoLoop:(BOOL)autoLoop {
    _autoLoop = autoLoop;
    if (autoLoop) {
        [self startTimer];
    } else {
        [self stopTimer];
    }
}

#pragma mark - Public Action
- (void)reloadData {
    
    [_bannersIndex removeAllObjects];
    NSInteger nums = [self getBannerNums];
    for (NSInteger i = 0; i < kTernLoopMax; i++) {
        for (NSInteger j = 0; j < nums; j++) {
            [_bannersIndex addObject:@(j)];
        }
    }
    
    [_bannersItem removeAllObjects];
    for (NSInteger j = 0; j < nums; j++) {
        NSObject *obj =[self getCellView:j];
        [_bannersItem addObject:(nil != obj) ? obj : [[NSObject alloc] init]];
    }
    
    if (nil != _pageControllerView) {
        [self bringSubviewToFront:_pageControllerView];
    }
    
    _bannersView.delegate = self;
    _bannersView.dataSource = self;
    [_bannersView reloadData];
    
    NSInteger page = _bannersView.contentOffset.x/SCREEN_WIDTH;
    page = page%[self getBannerNums];
    
    if (nil != _pageControllerView && page !=  _pageControllerView.currentPage && page < [self getBannerNums]) {
        _pageControllerView.currentPage = page;
    }
    
    if (nums > 0) {
        [_bannersView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:(kTernLoopMax/2*nums+page) inSection:0]  atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:false];
    }
}

- (void)invalidAutoLoop {
    [self stopTimer];
}

#pragma mark - Private Action
- (void)startTimer {
    self.bannersTimer = [NSTimer scheduledTimerWithTimeInterval:2.0f
                                                         target:self
                                                       selector:@selector(autoScroll:)
                                                       userInfo:nil
                                                        repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:self.bannersTimer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer {
    if (self.bannersTimer != nil )
    {
        [self.bannersTimer invalidate];
        self.bannersTimer = nil;
    }
}

- (void)autoScroll:(NSTimer*)tm
{
    NSInteger page = _bannersView.contentOffset.x/SCREEN_WIDTH;
    page = page%[self getBannerNums];
    
    if (nil != _pageControllerView && page !=  _pageControllerView.currentPage && page < [self getBannerNums]) {
        _pageControllerView.currentPage = page;
    }
    
    [_bannersView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:kTernLoopMax/2*[self getBannerNums]+page inSection:0]  atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    
    [_bannersView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:kTernLoopMax/2*[self getBannerNums]+page+1 inSection:0]  atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}


#pragma mark - Get Cell Action

- (UIImage *)getCellView:(NSInteger)row {
    if ([self.dataSource respondsToSelector:@selector(bannerView:cellForItemAtIndex:)]) {
        return [self.dataSource bannerView:self cellForItemAtIndex:row];
    } else {
        return nil;
    }
}

- (NSInteger) getBannerNums {
    NSInteger nums = 0;
    
    if ([self.dataSource respondsToSelector:@selector(numberItemsOfBanner:)]) {
        nums = [self.dataSource numberItemsOfBanner:self];
    }
    return nums;
}

@end
