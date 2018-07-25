#import "LDAdServiceAdMob.h"
@import GoogleMobileAds;

static inline bool isIpad()
{
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}

@implementation LDAdMobSettings
@end

@implementation LDAdMobRewardedVideoReward
@end

#pragma mark AdMob Banner implementation
@interface LDAdMobBanner : LDAdBanner<GADBannerViewDelegate>

@property (nonatomic, weak) id<LDAdBannerDelegate> delegate;
@property (nonatomic, assign) BOOL autoRefresh;
@property (nonatomic, assign) BOOL * personalizedAdsConsent;
@property (nonatomic, strong) GADBannerView * adView;

-(instancetype) initWithAdUnit:(NSString *) adUnit size:(LDAdBannerSize) size personalizedAdsConsent:(BOOL *) personalizedAdsConsent;

@end

@implementation LDAdMobBanner
{
    BOOL _ready;
}

-(instancetype) initWithAdUnit:(NSString *) adUnit size:(LDAdBannerSize) size personalizedAdsConsent:(BOOL *) personalizedAdsConsent;
{
    if (self = [super init]) {
        self.adView = [[GADBannerView alloc] initWithAdSize:[self bannerSizeToGAAdSize:size]];
        _adView.adUnitID = adUnit;
        _personalizedAdsConsent = personalizedAdsConsent;
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
    GADRequest *request = [GADRequest request];
    if (!_personalizedAdsConsent) {
        GADExtras *extras = [[GADExtras alloc] init];
        extras.additionalParameters = @{@"npa": @"1"};
        [request registerAdNetworkExtras:extras];
    }

    [_adView loadRequest:request];
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
@property (nonatomic, assign) BOOL * personalizedAdsConsent;
@property (nonatomic, strong) NSString * cachedAdUnit;

-(instancetype) initWithAdUnit:(NSString *) adUnit personalizedAdsConsent:(BOOL *) personalizedAdsConsent;

@end

@implementation LDAdMobInterstitial

-(instancetype) initWithAdUnit:(NSString *) adUnit personalizedAdsConsent:(BOOL *) personalizedAdsConsent
{
    if (self = [super init]) {
        self.cachedAdUnit = adUnit;
        self.interstitial = [[GADInterstitial alloc] initWithAdUnitID:adUnit];
        _personalizedAdsConsent = personalizedAdsConsent;
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
    GADRequest *request = [GADRequest request];
    if (!_personalizedAdsConsent) {
        GADExtras *extras = [[GADExtras alloc] init];
        extras.additionalParameters = @{@"npa": @"1"};
        [request registerAdNetworkExtras:extras];
    }

    [_interstitial loadRequest:request];
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
@interface LDAdMobRewardedVideo : LDAdRewardedVideo<GADRewardBasedVideoAdDelegate>

@property (nonatomic, weak) id<LDAdRewardedVideoDelegate> delegate;
@property (nonatomic, strong) GADRewardBasedVideoAd * rewardedVideo;
@property (nonatomic, assign) BOOL * personalizedAdsConsent;
@property (nonatomic, strong) NSString * cachedAdUnit;

-(instancetype) initWithAdUnit:(NSString *) adUnit personalizedAdsConsent:(BOOL *) personalizedAdsConsent;

@end


@implementation LDAdMobRewardedVideo
{
    BOOL _rewardCompleted;
}

-(instancetype) initWithAdUnit:(NSString *) adUnit personalizedAdsConsent:(BOOL *) personalizedAdsConsent
{
    if (self = [super init]) {
        self.cachedAdUnit = adUnit;
        _rewardCompleted = NO;
        _personalizedAdsConsent = personalizedAdsConsent;
        self.rewardedVideo = [GADRewardBasedVideoAd sharedInstance];
        _rewardedVideo.delegate = self;
    }
    return self;
}

-(void) dealloc
{
    _rewardedVideo.delegate = nil;
}

- (void)loadAd
{
    if (!_rewardedVideo.isReady) {
        GADRequest *request = [GADRequest request];
        if (!_personalizedAdsConsent) {
            GADExtras *extras = [[GADExtras alloc] init];
            extras.additionalParameters = @{@"npa": @"1"};
            [request registerAdNetworkExtras:extras];
        }

        [_rewardedVideo loadRequest:request withAdUnitID:_cachedAdUnit];
    }
}

-(BOOL) isReady
{
    return _rewardedVideo && _rewardedVideo.isReady;
}

- (void)showFromViewController:(UIViewController *)controller animated:(BOOL) animated
{
    if (_rewardedVideo.isReady) {
        _rewardCompleted = NO;
        [_rewardedVideo presentFromRootViewController:controller];
    }
    else {
        [self loadAd];
    }
}

- (void)dismissAnimated:(BOOL) animated
{
    //TODO
}

#pragma mark GADRewardedVideoDelegate


/// Tells the delegate that the reward based video ad has rewarded the user.
- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd didRewardUserWithReward:(GADAdReward *)reward
{
    _rewardCompleted = YES;
    if (_delegate && [_delegate respondsToSelector:@selector(adRewardedVideoDidCompleteRewardedVideo:withReward:andError:)]) {
        LDAdMobRewardedVideoReward * value = [[LDAdMobRewardedVideoReward alloc] init];
        value.amount = reward.amount ?: [NSNumber numberWithInteger:1];
        value.itmKey = reward.type ?: @"";
        [_delegate adRewardedVideoDidCompleteRewardedVideo:self withReward:value andError:nil];
    }
}

/// Tells the delegate that the reward based video ad failed to load.
- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd didFailToLoadWithError:(nonnull NSError *)error
{
    if (_delegate && [_delegate respondsToSelector:@selector(adRewardedVideoDidFailLoad:withError:)]) {
        [_delegate adRewardedVideoDidFailLoad:self withError:error];
    }
}

/// Tells the delegate that a reward based video ad was received.
- (void)rewardBasedVideoAdDidReceiveAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
{
    if (_delegate && [_delegate respondsToSelector:@selector(adRewardedVideoDidLoad:)]) {
        [_delegate adRewardedVideoDidLoad:self];
    }
}

/// Tells the delegate that the reward based video ad opened.
- (void)rewardBasedVideoAdDidOpen:(GADRewardBasedVideoAd *)rewardBasedVideoAd
{
    if (_delegate && [_delegate respondsToSelector:@selector(adRewardedVideoWillAppear:)]) {
        [_delegate adRewardedVideoWillAppear:self];
    }
}

/// Tells the delegate that the reward based video ad started playing.
- (void)rewardBasedVideoAdDidStartPlaying:(GADRewardBasedVideoAd *)rewardBasedVideoAd
{

}

/// Tells the delegate that the reward based video ad closed.
- (void)rewardBasedVideoAdDidClose:(GADRewardBasedVideoAd *)rewardBasedVideoAd
{
    if (_delegate && [_delegate respondsToSelector:@selector(adRewardedVideoWillDisappear:)]) {
        [_delegate adRewardedVideoWillDisappear:self];
    }

    if (!_rewardCompleted && _delegate && [_delegate respondsToSelector:@selector(adRewardedVideoDidCompleteRewardedVideo:withReward:andError:)]) {
        NSError * error = [NSError errorWithDomain:@"AdMob" code:400 userInfo:@{@"Error reason": @"The user did not complete the rewarded video"}];
        [_delegate adRewardedVideoDidCompleteRewardedVideo:self withReward:nil andError:error];
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
    NSString * adUnit = banner;
    if (!adUnit) {
        adUnit = isIpad()  ? (_settings.bannerIpad ?: _settings.banner) : _settings.banner;
    }

    return [[LDAdMobBanner alloc] initWithAdUnit:adUnit size: size personalizedAdsConsent: _settings.personalizedAdsConsent];
}


-(LDAdInterstitial *) createInterstitial {

    return [self createInterstitial:nil];
}

-(LDAdInterstitial *) createInterstitial:(NSString *) interstitial
{
    NSString * adUnit = interstitial;
    if (!adUnit) {
        adUnit = isIpad() ? (_settings.interstitialIpad ?: _settings.interstitial) : _settings.interstitial;
    }

    return [[LDAdMobInterstitial alloc] initWithAdUnit:adUnit personalizedAdsConsent: _settings.personalizedAdsConsent];
}

-(LDAdInterstitial *) createVideoInterstitial:(NSString *) adUnit
{
    return [self createInterstitial:adUnit];
}

-(LDAdRewardedVideo *) createRewardedVideo {
    return [self createRewardedVideo:nil];
}

-(LDAdRewardedVideo *) createRewardedVideo:(NSString *) rewardedVideo {
    NSString * adUnit = rewardedVideo;
    if (!adUnit) {
        adUnit = isIpad() ? (_settings.rewardedVideoIpad ?: _settings.rewardedVideo) : _settings.rewardedVideo;
    }

    return [[LDAdMobRewardedVideo alloc] initWithAdUnit:adUnit personalizedAdsConsent: _settings.personalizedAdsConsent];
}

@end
