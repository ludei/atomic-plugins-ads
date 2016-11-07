#import "LDAdServiceAdMob.h"
#import <GoogleMobileAds/GADBannerView.h>
#import <GoogleMobileAds/GADAdSize.h>
#import <GoogleMobileAds/GADInterstitial.h>

static inline bool isIpad()
{
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}

@implementation LDAdMobSettings
@end

@implementation LDAdmobRewardedVideoReward
@end

#pragma mark AdMob Banner implementation
@interface LDAdMobBanner : LDAdBanner<GADBannerViewDelegate>

@property (nonatomic, weak) id<LDAdBannerDelegate> delegate;
@property (nonatomic, assign) BOOL autoRefresh;
@property (nonatomic, strong) GADBannerView * adView;

-(instancetype) initWithAdUnit:(NSString *) adUnit size:(LDAdBannerSize) size;

@end

@implementation LDAdMobBanner
{
    BOOL _ready;
}

-(instancetype) initWithAdUnit:(NSString *) adUnit size:(LDAdBannerSize) size;
{
    if (self = [super init]) {
        
        self.adView = [[GADBannerView alloc] initWithAdSize:[self bannerSizeToGAAdSize:size]];
        _adView.adUnitID = adUnit;
        _adView.delegate = self;
    }
    return self;
}

-(void) dealloc
{
    _adView.delegate = nil;
    if (_adView.superview) {
        [_adView removeFromSuperview];
    }
}

-(GADAdSize) bannerSizeToGAAdSize: (LDAdBannerSize) size {
    
    if (size == LD_SMART_SIZE) {
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            return kGADAdSizeSmartBannerLandscape;
        }
        else {
            return kGADAdSizeSmartBannerPortrait;
        }
        
    }
    
    switch (size) {
        default:
        case LD_BANNER_SIZE: return kGADAdSizeBanner;
        case LD_LEADERBOARD_SIZE: return kGADAdSizeLeaderboard;
        case LD_MEDIUM_RECT_SIZE: return kGADAdSizeMediumRectangle;
    }
}

-(void) setAutoRefresh:(BOOL)autoRefresh
{
    _autoRefresh = autoRefresh;
}

-(BOOL) isReady
{
    return _ready;
}

- (void)loadAd
{
    if (!_adView.rootViewController) {
        if (_delegate) {
            _adView.rootViewController = [_delegate viewControllerForPresentingModalView];
        }
        else {
            UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
            _adView.rootViewController = keyWindow.rootViewController;
        }
    }
    [_adView loadRequest:[GADRequest request]];
}

- (CGSize)adSize
{
    return _adView.bounds.size;
}

-(UIView *) view
{
    return _adView;
}


#pragma mark GADBannerViewDelegate

- (void)adViewDidReceiveAd:(GADBannerView *)view
{
    if (_delegate && [_delegate respondsToSelector:@selector(adBannerDidLoad:)]) {
        [_delegate adBannerDidLoad:self];
    }
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error
{
    if (_delegate && [_delegate respondsToSelector:@selector(adBannerDidFailLoad:withError:)]) {
        [_delegate adBannerDidFailLoad:self withError:error];
    }
}

- (void)adViewWillPresentScreen:(GADBannerView *)adView
{
    if (_delegate && [_delegate respondsToSelector:@selector(adBannerWillPresentModal:)]) {
        [_delegate adBannerWillPresentModal:self];
    }
}

- (void)adViewDidDismissScreen:(GADBannerView *)adView
{
    if (_delegate && [_delegate respondsToSelector:@selector(adBannerDidDismissModal:)]) {
        [_delegate adBannerDidDismissModal:self];
    }
}
- (void)adViewWillLeaveApplication:(GADBannerView *)adView
{

    
}


@end

#pragma mark AdMob Interstitial implementation
@interface LDAdMobInterstitial : LDAdInterstitial<GADInterstitialDelegate>

@property (nonatomic, weak) id<LDAdInterstitialDelegate> delegate;
@property (nonatomic, strong) GADInterstitial * interstitial;
@property (nonatomic, strong) NSString * cachedAdUnit;

-(instancetype) initWithAdUnit:(NSString *) adUnit;

@end

@implementation LDAdMobInterstitial

-(instancetype) initWithAdUnit:(NSString *) adUnit
{
    if (self = [super init]) {
        self.cachedAdUnit = adUnit;
        self.interstitial = [[GADInterstitial alloc] initWithAdUnitID:adUnit];
        _interstitial.delegate = self;
    }
    return self;
}

-(void) dealloc
{
    _interstitial.delegate = nil;
}

- (void)loadAd
{
    if (_interstitial.hasBeenUsed) {
        //AdMob interstitials can only be used when, recreate if it has already been used
        self.interstitial = [[GADInterstitial alloc] initWithAdUnitID:_cachedAdUnit];
        _interstitial.delegate = self;
    }
    [_interstitial loadRequest:[GADRequest request]];
}

-(BOOL) isReady
{
    return !_interstitial.hasBeenUsed && _interstitial.isReady;
}

- (void)showFromViewController:(UIViewController *)controller animated:(BOOL) animated
{
    if (!_interstitial.hasBeenUsed && _interstitial.isReady) {
        [_interstitial presentFromRootViewController:controller];
    }
    else {
        [self loadAd];
    }
}

- (void)dismissAnimated:(BOOL) animated
{
    //TODO
}

#pragma mark GADInterstitialDelegate


- (void)interstitialDidReceiveAd:(GADInterstitial *)ad
{
    if (_delegate && [_delegate respondsToSelector:@selector(adInterstitialDidLoad:)]) {
        [_delegate adInterstitialDidLoad:self];
    }
}

- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error
{
    if (_delegate && [_delegate respondsToSelector:@selector(adInterstitialDidFailLoad:withError:)]) {
        [_delegate adInterstitialDidFailLoad:self withError:error];
    }
}

- (void)interstitialWillPresentScreen:(GADInterstitial *)ad
{
    if (_delegate && [_delegate respondsToSelector:@selector(adInterstitialWillAppear:)]) {
        [_delegate adInterstitialWillAppear:self];
    }
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)ad
{
    if (_delegate && [_delegate respondsToSelector:@selector(adInterstitialWillDisappear:)]) {
        [_delegate adInterstitialWillDisappear:self];
    }
}


- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad
{
    
}


@end


#pragma mark AdMob Rewarded Video implementation

@interface LDAdmobRewardedVideo : LDAdInterstitial<GADRewardBasedVideoAdDelegate>

@property (nonatomic, weak) id<LDAdInterstitialDelegate> delegate;
@property (nonatomic, strong) GADRewardBasedVideoAd * interstitial;
@property (nonatomic, strong) NSString * cachedAdUnit;

-(instancetype) initWithAdUnit:(NSString *) adUnit;

@end

@implementation LDAdmobRewardedVideo
{
    BOOL _rewardCompleted;
}

-(instancetype) initWithAdUnit:(NSString *) adUnit
{
    if (self = [super init]) {
        self.cachedAdUnit = adUnit;
        _rewardCompleted = NO;
        self.interstitial = [GADRewardBasedVideoAd sharedInstance];
        _interstitial.delegate = self;
    }
    return self;
}

-(void) dealloc
{
    _interstitial.delegate = nil;
}

- (void)loadAd
{
    if (!_interstitial.isReady) {
        [_interstitial loadRequest:[GADRequest request] withAdUnitID:_cachedAdUnit];
    }
}

-(BOOL) isReady
{
    return _interstitial && _interstitial.isReady;
}

- (void)showFromViewController:(UIViewController *)controller animated:(BOOL) animated
{
    if (_interstitial.isReady) {
        _rewardCompleted = NO;
        [_interstitial presentFromRootViewController:controller];
    }
    else {
        [self loadAd];
    }
}

- (void)dismissAnimated:(BOOL) animated
{
    //TODO
}

#pragma mark GADInterstitialDelegate


/// Tells the delegate that the reward based video ad has rewarded the user.
- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd didRewardUserWithReward:(GADAdReward *)reward
{
    _rewardCompleted = YES;
    if (_delegate && [_delegate respondsToSelector:@selector(adInterstitialDidCompleteRewardedVideo:withReward:andError:)]) {
        LDAdmobRewardedVideoReward * value = [[LDAdmobRewardedVideoReward alloc] init];
        value.amount = reward.amount ?: [NSNumber numberWithInteger:1];
        value.itmKey = reward.type ?: @"";
        [_delegate adInterstitialDidCompleteRewardedVideo:self withReward:value andError:nil];
    }
}

/// Tells the delegate that the reward based video ad failed to load.
- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd didFailToLoadWithError:(GAD_NULLABLE NSError *)error
{
    if (_delegate && [_delegate respondsToSelector:@selector(adInterstitialDidFailLoad:withError:)]) {
        [_delegate adInterstitialDidFailLoad:self withError:error];
    }
}

/// Tells the delegate that a reward based video ad was received.
- (void)rewardBasedVideoAdDidReceiveAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
{
    if (_delegate && [_delegate respondsToSelector:@selector(adInterstitialDidLoad:)]) {
        [_delegate adInterstitialDidLoad:self];
    }
}

/// Tells the delegate that the reward based video ad opened.
- (void)rewardBasedVideoAdDidOpen:(GADRewardBasedVideoAd *)rewardBasedVideoAd
{
    if (_delegate && [_delegate respondsToSelector:@selector(adInterstitialWillAppear:)]) {
        [_delegate adInterstitialWillAppear:self];
    }
}

/// Tells the delegate that the reward based video ad started playing.
- (void)rewardBasedVideoAdDidStartPlaying:(GADRewardBasedVideoAd *)rewardBasedVideoAd
{

}

/// Tells the delegate that the reward based video ad closed.
- (void)rewardBasedVideoAdDidClose:(GADRewardBasedVideoAd *)rewardBasedVideoAd
{
    if (_delegate && [_delegate respondsToSelector:@selector(adInterstitialWillDisappear:)]) {
        [_delegate adInterstitialWillDisappear:self];
    }
    
    if (!_rewardCompleted && _delegate && [_delegate respondsToSelector:@selector(adInterstitialDidCompleteRewardedVideo:withReward:andError:)]) {
        NSError * error = [NSError errorWithDomain:@"AdMob" code:400 userInfo:@{@"Error reason": @"The user did not complete the rewarded video"}];
        [_delegate adInterstitialDidCompleteRewardedVideo:self withReward:nil andError:error];
    }
}

/// Tells the delegate that the reward based video ad will leave the application.
- (void)rewardBasedVideoAdWillLeaveApplication:(GADRewardBasedVideoAd *)rewardBasedVideoAd
{
    
}

@end



#pragma mark AdMob AdService implementation

@implementation LDAdServiceAdMob
{
    LDAdMobSettings * _settings;
}

-(instancetype) init
{
    if (self = [super init]) {
        _settings = [[LDAdMobSettings alloc] init];
    }
    return self;
}


-(LDAdBanner *) createBanner {
    return [self createBanner:nil size:LD_SMART_SIZE];
}

-(LDAdBanner *) createBanner: (NSString *) banner size:(LDAdBannerSize) size
{
    NSString * adunit = banner;
    if (!adunit) {
        adunit = isIpad()  ? (_settings.bannerIpad ?: _settings.banner) : _settings.banner;
    }
    
    return [[LDAdMobBanner alloc] initWithAdUnit:adunit size: size];
}


-(LDAdInterstitial *) createInterstitial {
    
    return [self createInterstitial:nil];
}

-(LDAdInterstitial *) createInterstitial:(NSString *) interstitial
{
    NSString * adunit = interstitial;
    if (!adunit) {
        adunit = isIpad() ? (_settings.interstitialIpad ?: _settings.interstitial) : _settings.interstitial;
    }
    
    return [[LDAdMobInterstitial alloc] initWithAdUnit:adunit];
}

-(LDAdInterstitial *) createVideoInterstitial:(NSString *) adunit
{
    return [self createInterstitial:adunit];
}

-(LDAdInterstitial *) createRewardedVideo:(NSString *)adunit {
    return [[LDAdmobRewardedVideo alloc] initWithAdUnit:adunit];
}


@end
