#import "LDAdServiceHeyzap.h"
#import <HeyzapAds/HeyzapAds.h>

@implementation LDHeyzapSettings
@end

@implementation LDHeyzapRewardedVideoReward
@end



#pragma mark Heyzap Banner implementation
@interface LDHeyzapBanner : LDAdBanner<HZBannerAdDelegate>

@property (nonatomic, weak) id<LDAdBannerDelegate> delegate;
@property (nonatomic, assign) BOOL autoRefresh;
@property (nonatomic, strong) UIView * adView;

-(instancetype) initWithTag:(NSString *) adUnit size:(LDAdBannerSize) size;

@end

@implementation LDHeyzapBanner
{
    HZBannerAdOptions * _options;
    BOOL loadingAd;
}

-(instancetype) initWithTag:(NSString *) tag size:(LDAdBannerSize) size;
{
    if (self = [super init]) {
        [[HZBannerAdController sharedInstance] setDelegate:self];

        _options = [[HZBannerAdOptions alloc] init];
        _options.tag = tag;
        if (size == LD_BANNER_SIZE) {
            _options.admobBannerSize = HZAdMobBannerSizeBanner;
            _options.facebookBannerSize = HZFacebookBannerSizeFlexibleWidthHeight50;
        }
        else if (size == LD_LEADERBOARD_SIZE) {
            _options.admobBannerSize = HZAdMobBannerSizeLeaderboard;
            _options.facebookBannerSize = HZFacebookBannerSizeFlexibleWidthHeight90;
        }
        else if (size == LD_MEDIUM_RECT_SIZE) {
            _options.admobBannerSize = HZAdMobBannerSizeLargeBanner;
        }
    }
    return self;
}

-(void) dealloc
{
    [[HZBannerAdController sharedInstance] destroyBanner];
}


-(void) setAutoRefresh:(BOOL)autoRefresh
{
    _autoRefresh = autoRefresh;
}
- (void)loadAd
{
    if (!_adView && !loadingAd) {
        loadingAd = YES;
        [[HZBannerAdController sharedInstance] requestBannerWithOptions:_options success:^(UIView *banner) {
            loadingAd = NO;
            self.adView = banner;

        } failure:^(NSError *error) {
            loadingAd = NO;
            [self bannerDidFailToReceiveAd:nil error:error];
        }];
    }
}

-(bool) isReady
{
    return _adView != nil;
}

- (CGSize)adSize
{
    return _adView ? _adView.bounds.size : CGSizeZero;
}

-(UIView *) view
{
    return _adView;
}


//Banner delegate

/**
 *  Called when the banner ad is loaded.
 */
- (void)bannerDidReceiveAd:(HZBannerAdController *)controller
{
    if (_delegate && [_delegate respondsToSelector:@selector(adBannerDidLoad:)]) {
        [_delegate adBannerDidLoad:self];
    }
}

/**
 *  Called when the banner ad fails to load.
 *
 *  @param error An error describing the failure.
 *
 *  If the underlying ad network provided an `NSError` object, it will be accessible in the `userInfo` dictionary
 *  with the `NSUnderlyingErrorKey`.
 */
- (void)bannerDidFailToReceiveAd:(HZBannerAdController *)banner error:(NSError *)error
{
    if (_delegate && [_delegate respondsToSelector:@selector(adBannerDidFailLoad:withError:)]) {
        [_delegate adBannerDidFailLoad:self withError:error];
    }
}

/// @name Click-time Notifications
#pragma mark - Click-time Notifications

/**
 *  Called when the user clicks the banner ad.
 */
- (void)bannerWasClicked:(HZBannerAdController *)banner
{

}

/**
 *  Called when the banner ad will present a modal view controller, after the user clicks the ad.
 */
- (void)bannerWillPresentModalView:(HZBannerAdController *)banner
{
    if (_delegate && [_delegate respondsToSelector:@selector(adBannerWillPresentModal:)]) {
        [_delegate adBannerWillPresentModal:self];
    }
}

/**
 *  Called when a presented modal view controller is dismissed by the user.
 */
- (void)bannerDidDismissModalView:(HZBannerAdController *)banner
{
    if (_delegate && [_delegate respondsToSelector:@selector(adBannerDidDismissModal:)]) {
        [_delegate adBannerDidDismissModal:self];
    }
}

/**
 *  Called when a user clicks a banner ad that causes them to leave the application.
 */
- (void)bannerWillLeaveApplication:(HZBannerAdController *)banner
{

}


@end


#pragma mark Heyzap Interstitial implementation
@interface LDHeyzapInterstitial: LDAdInterstitial

-(instancetype) initWithTag:(NSString*) tag;

@property (nonatomic, weak) id<LDAdInterstitialDelegate> delegate;
@property (nonatomic, strong) NSString * tag;

@end

@implementation LDHeyzapInterstitial


-(instancetype) initWithTag:(NSString*) tag
{
    if (self = [super init]) {
        self.tag = tag;
    }
    return self;
}

- (void)loadAd
{
    [HZInterstitialAd fetchForTag:self.tag];
}


-(bool) isReady
{
    return [HZInterstitialAd isAvailableForTag:self.tag];
}

- (void)showFromViewController:(UIViewController *)controller animated:(BOOL) animated
{
    if ([HZInterstitialAd isAvailableForTag:self.tag]) {
        HZShowOptions * options = [[HZShowOptions alloc] init];
        options.viewController = controller;
        options.tag = self.tag;
        [HZInterstitialAd showWithOptions:options];
    }
    else {
        [HZInterstitialAd fetchForTag:self.tag];
    }
}

- (void)dismissAnimated:(BOOL) animated
{
    //TODO
}

@end


#pragma mark Heyzap Rewarded Video implementation
@interface LDHeyzapRewardedVideo: LDAdInterstitial

-(instancetype) initWithTag:(NSString*) tag;

@property (nonatomic, weak) id<LDAdInterstitialDelegate> delegate;
@property (nonatomic, strong) NSString * tag;

@end

@implementation LDHeyzapRewardedVideo


-(instancetype) initWithTag:(NSString*) tag
{
    if (self = [super init]) {
        self.tag = tag;
    }
    return self;
}

- (void)loadAd
{
    [HZIncentivizedAd fetchForTag:self.tag];
}


-(bool) isReady
{
    return [HZIncentivizedAd isAvailableForTag:self.tag];
}

- (void)showFromViewController:(UIViewController *)controller animated:(BOOL) animated
{
    if ([HZIncentivizedAd isAvailableForTag:self.tag]) {
        HZShowOptions * options = [[HZShowOptions alloc] init];
        options.viewController = controller;
        options.tag = self.tag;
        [HZIncentivizedAd showWithOptions:options];
    }
    else {
        [HZIncentivizedAd fetchForTag:self.tag];
    }
}

- (void)dismissAnimated:(BOOL) animated
{
    //TODO
}

@end


#pragma mark Heyzap AdService implementation

@interface LDAdServiceHeyzap () <HZIncentivizedAdDelegate,HZAdsDelegate>

@end

@implementation LDAdServiceHeyzap
{
    NSMapTable<NSString*, LDAdInterstitial*> *interstitials;
}

-(instancetype) init
{
    if (self = [super init]) {
        _settings = [[LDHeyzapSettings alloc] init];
        interstitials = [[NSMapTable alloc] init];
        [HZInterstitialAd setDelegate:self];
        [HZIncentivizedAd setDelegate:self];
    }

    return self;
}

-(void) configurePublisherId:(NSString*)publisherId
{
    [HeyzapAds startWithPublisherID: publisherId];
}

-(LDAdBanner *) createBanner {
    return [self createBanner:nil size:LD_SMART_SIZE];
}

-(LDAdBanner *) createBanner: (NSString *) adunit size:(LDAdBannerSize) size
{
    if (!adunit || adunit.length == 0) {
        adunit = @"default";
    }
    return [[LDHeyzapBanner alloc] initWithTag:adunit size:size];
}


-(LDAdInterstitial *) createInterstitial {

    return [self createInterstitial:nil];
}

-(LDAdInterstitial *) createInterstitial:(NSString *) adunit
{
    if (!adunit || adunit.length == 0) {
        adunit = @"default";
    }
    LDHeyzapInterstitial * ad = [[LDHeyzapInterstitial alloc] initWithTag:adunit];
    [interstitials setObject:ad forKey:adunit];
    return ad;
}

-(LDAdInterstitial *) createVideoInterstitial:(NSString *) adunit
{
    if (!adunit || adunit.length == 0) {
        adunit = @"default";
    }

    return [self createInterstitial:adunit];
}

-(LDAdInterstitial *) createRewardedVideo:(NSString *)adunit {
    if (!adunit || adunit.length == 0) {
        adunit = @"default";
    }
    LDHeyzapRewardedVideo * ad = [[LDHeyzapRewardedVideo alloc] initWithTag:adunit];
    [interstitials setObject:ad forKey:adunit];
    return ad;
}

-(void) showDebug
{
    [HeyzapAds presentMediationDebugViewController];
}

/**
 *  Called when we succesfully show an ad.
 *
 *  @param tag The identifier for the ad.
 */
- (void)didShowAdWithTag: (NSString *) tag
{
    LDAdInterstitial * ad = [interstitials objectForKey:tag == NULL ? @"default" : tag];
    if (ad && ad.delegate && [ad.delegate respondsToSelector:@selector(adInterstitialWillAppear:)]) {
        [ad.delegate adInterstitialWillAppear:ad];
    }
}

/**
 *  Called when an ad fails to show
 *
 *  @param tag   The identifier for the ad.
 *  @param error An NSError describing the error
 */
- (void)didFailToShowAdWithTag: (NSString *) tag andError: (NSError *)error
{
    LDAdInterstitial * ad = [interstitials objectForKey:tag == NULL ? @"default" : tag];
    if (ad && ad.delegate && [ad.delegate respondsToSelector:@selector(adInterstitialDidFailLoad:withError:)]) {
        [ad.delegate adInterstitialDidFailLoad:ad withError:nil];
    }
}

/**
 *  Called when a valid ad is received
 *
 *  @param tag The identifier for the ad.
 */
- (void)didReceiveAdWithTag: (NSString *) tag
{
    LDAdInterstitial * ad = [interstitials objectForKey:tag == NULL ? @"default" : tag];
    if (ad && ad.delegate && [ad.delegate respondsToSelector:@selector(adInterstitialDidLoad:)]) {
        [ad.delegate adInterstitialDidLoad:ad];
    }
}

/**
 *  Called when our server fails to send a valid ad, like when there is a 500 error.
 *
 *  @param tag The identifier for the ad.
 */
- (void)didFailToReceiveAdWithTag: (NSString *) tag
{
    LDAdInterstitial * ad = [interstitials objectForKey:tag == NULL ? @"default" : tag];
    if (ad && ad.delegate && [ad.delegate respondsToSelector:@selector(adInterstitialDidFailLoad:withError:)]) {
        [ad.delegate adInterstitialDidFailLoad:ad withError:nil];
    }
}

/**
 *  Called when the ad is dismissed.
 *
 *  @param tag An identifier for the ad.
 */
- (void)didHideAdWithTag: (NSString *) tag
{
    LDAdInterstitial * ad = [interstitials objectForKey:tag == NULL ? @"default" : tag];
    if (ad && ad.delegate && [ad.delegate respondsToSelector:@selector(adInterstitialWillDisappear:)]) {
        [ad.delegate adInterstitialWillDisappear:ad];
    }
}


/** Called when a user successfully completes viewing an ad */
- (void)didCompleteAdWithTag: (NSString *) tag
{
    LDAdInterstitial * ad = [interstitials objectForKey:tag == NULL ? @"default" : tag];
    if (ad && ad.delegate && [ad.delegate respondsToSelector:@selector(adInterstitialDidCompleteRewardedVideo:withReward:andError:)]) {
        LDHeyzapRewardedVideoReward * reward = [[LDHeyzapRewardedVideoReward alloc] init];
        reward.amount = [NSNumber numberWithInteger:1];
        reward.itmKey = tag;
        [ad.delegate adInterstitialDidCompleteRewardedVideo:ad withReward:reward andError:nil];
    }
}

/** Called when a user does not complete the viewing of an ad */
- (void)didFailToCompleteAdWithTag: (NSString *) tag
{
    LDAdInterstitial * ad = [interstitials objectForKey:tag == NULL ? @"default" : tag];
    if (ad && ad.delegate && [ad.delegate respondsToSelector:@selector(adInterstitialDidCompleteRewardedVideo:withReward:andError:)]) {
        [ad.delegate adInterstitialDidCompleteRewardedVideo:ad withReward:nil andError:[NSError errorWithDomain:@"Heyzap" code:400 userInfo:@{@"Error reason": @"The user did not complete the rewarded video"}]];
    }
}


@end