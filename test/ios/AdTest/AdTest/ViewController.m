//
//  ViewController.m
//  AdTest
//
//  Created by Imanol Fernandez Gorostizag on 22/12/14.
//  Copyright (c) 2014 Ludei. All rights reserved.
//

#import "ViewController.h"
#import "LDAdService.h"
#import "TestService.h"

#define BUTTON_SIZE CGSizeMake(140, 40)

@interface ViewController () <LDAdBannerDelegate, LDAdInterstitialDelegate>

@property (nonatomic, strong) NSArray * interstitialButtons;
@property (nonatomic, strong) NSArray * bannerButtons;
@property (nonatomic, strong) UILabel * interstitialLabel;
@property (nonatomic, strong) UILabel * interstitialStatus;
@property (nonatomic, strong) UILabel * bannerLabel;
@property (nonatomic, strong) UILabel * bannerStatus;
@property (nonatomic, strong) UIView * splitView;

@property (nonatomic, strong) LDAdService * adService;
@property (nonatomic, strong) LDAdBanner * adBanner;
@property (nonatomic, strong) LDAdInterstitial * adInterstitial;

@end

@implementation ViewController
{
    BOOL showBannerOnTop;
}


-(void) createService
{
    _adService = [TestService create];
    _adBanner = [_adService createBanner];
    _adBanner.delegate = self;
    [_adBanner loadAd];
    _adInterstitial = [_adService createInterstitial:nil];
    _adInterstitial.delegate = self;
    [_adInterstitial loadAd];
}

-(void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    const CGFloat padding = 15;
    const CGSize buttonSize =  BUTTON_SIZE;
    const NSInteger maxButtons = MAX(_bannerButtons.count, _interstitialButtons.count);
    const CGFloat verticalHeight = maxButtons * (buttonSize.height + padding) + 40;
    const CGFloat y0 = self.view.bounds.size.height * 0.5 - verticalHeight * 0.5;

    CGFloat x1 = self.view.bounds.size.width * 0.25;
    CGFloat x2 = self.view.bounds.size.width * 0.75;
    
    _interstitialLabel.center = CGPointMake(x1, y0);
    _bannerLabel.center = CGPointMake(x2, y0);
    
    for (NSUInteger i = 0; i < _interstitialButtons.count; ++i) {
        UIButton * button = [_interstitialButtons objectAtIndex:i];
        button.center = CGPointMake(self.view.bounds.size.width * 0.25, y0 + 20 + i * buttonSize.height + (i+1) * padding);
    }
    
    for (NSUInteger i = 0; i < _bannerButtons.count; ++i) {
        UIButton * button = [_bannerButtons objectAtIndex:i];
        button.center = CGPointMake(self.view.bounds.size.width * 0.75, y0 + 20 + i * buttonSize.height + (i+1) * padding);
    }
    
    _interstitialStatus.frame = CGRectMake(0, 0, self.view.bounds.size.width * 0.45, 40);
    _bannerStatus.frame = _interstitialStatus.frame;
    _interstitialStatus.center = CGPointMake(x1, y0 + verticalHeight);
    _bannerStatus.center = CGPointMake(x2, y0 + verticalHeight);
    
    _splitView.frame = CGRectMake(self.view.bounds.size.width * 0.5, y0, 1, verticalHeight);
    
    [self layoutBanner];
}

-(UIButton *) createButton:(NSString * ) title selector:(SEL) selector
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    CGSize size = BUTTON_SIZE;
    button.frame = CGRectMake(0, 0, size.width, size.height);
    [[button layer] setBorderWidth:1.0f];
    [[button layer] setBorderColor:[UIColor blackColor].CGColor];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}

-(void) createInterstitialButtons {
    
    _interstitialButtons = @[
                             [self createButton:@"Show interstitial" selector:@selector(showInterstitial:)],
                             [self createButton:@"Cache interstitial" selector:@selector(cacheInterstitial:)],
                             ];
    for (UIButton * button in _interstitialButtons) {
        [self.view addSubview:button];
    }

}

-(void) createBannerButtons {
    
    _bannerButtons = @[
                             [self createButton:@"Show banner" selector:@selector(showBanner:)],
                             [self createButton:@"Hide banner" selector:@selector(hideBanner:)],
                             [self createButton:@"Change position" selector:@selector(changePosition:)],
                             [self createButton:@"Cache banner" selector:@selector(cacheBanner:)],
    ];
    for (UIButton * button in _bannerButtons) {
        [self.view addSubview:button];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createService];
    
    _interstitialLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _interstitialStatus = [[UILabel alloc] initWithFrame:CGRectZero];
    _bannerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _bannerStatus = [[UILabel alloc] initWithFrame:CGRectZero];
    _splitView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_interstitialLabel];
    [self.view addSubview:_interstitialStatus];
    [self.view addSubview:_bannerLabel];
    [self.view addSubview:_bannerStatus];
    [self.view addSubview:_splitView];
    
    _interstitialLabel.text = @"INTERSTITIAL";
    [_interstitialLabel sizeToFit];
    _bannerLabel.text = @"BANNER";
    [_bannerLabel sizeToFit];
    
    _bannerStatus.textColor = _interstitialStatus.textColor = [UIColor grayColor];
    _bannerStatus.textAlignment = _interstitialStatus.textAlignment = UITextAlignmentCenter;
    _splitView.backgroundColor = [UIColor blackColor];
    
    [self createInterstitialButtons];
    [self createBannerButtons];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) layoutBanner
{
    if (!_adBanner.view || !_adBanner.view.superview) {
        return;
    }
    CGSize size = _adBanner.adSize;
    CGFloat x = self.view.bounds.size.width * 0.5;
    if (showBannerOnTop) {
        _adBanner.view.center = CGPointMake(x, size.height * 0.5);
    }
    else {
        _adBanner.view.center = CGPointMake(x, self.view.bounds.size.height - size.height * 0.5);
    }
}


-(void) showInterstitial:(id) sender
{
    [_adInterstitial showFromViewController:self animated:YES];
}

-(void) cacheInterstitial:(id) sender
{
    [_adInterstitial loadAd];
}

-(void) showBanner:(id) sender
{
    _adBanner.view.hidden = NO;
    [self layoutBanner];
}

-(void) hideBanner:(id) sender
{
    _adBanner.view.hidden = YES;
}

-(void) changePosition:(id) sender
{
    showBannerOnTop = !showBannerOnTop;
    [self layoutBanner];
}

-(void) cacheBanner:(id) sender
{
    [_adBanner loadAd];
}


#pragma mark LDAdBannerDelegate

-(UIViewController *) viewControllerForPresentingModalView
{
    return self;
}

-(void) adBannerDidLoad:(LDAdBanner *) banner
{
    if (!banner.view.superview) {
        [self.view addSubview:banner.view];
    }
    [self layoutBanner];
    _bannerStatus.text = @"Did load";
}

-(void) adBannerDidFailLoad:(LDAdBanner *) banner withError:(NSError *) error
{
    _bannerStatus.text = @"Did fail";
}
- (void) adBannerWillPresentModal:(LDAdBanner *)banner
{
    _bannerStatus.text = @"Did present modal";
}
- (void) adBannerDidDismissModal:(LDAdBanner *)banner
{
    _bannerStatus.text = @"Did dimiss modal";
}

#pragma LDAdInterstitialDelegate

-(void) adInterstitialDidLoad:(LDAdInterstitial *) interstitial
{
    _interstitialStatus.text = @"Did load";
}

-(void) adInterstitialDidFailLoad:(LDAdInterstitial *) interstitial withError:(NSError *) error
{
    _interstitialStatus.text = @"Did fail";
}

- (void)adInterstitialWillAppear:(LDAdInterstitial *)interstitial
{
    _interstitialStatus.text = @"Did present";
}

- (void)adInterstitialWillDisappear:(LDAdInterstitial *)interstitial
{
    _interstitialStatus.text = @"Did dismiss";
}

@end
