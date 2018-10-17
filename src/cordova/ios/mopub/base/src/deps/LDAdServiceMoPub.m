#import "LDAdServiceMoPub.h"

@import MoPubSDKFramework;

static inline bool isIpad() {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}

@implementation LDMoPubSettings
@end

@implementation LDMoPubRewardedVideoReward
@end

#pragma mark MoPub Banner implementation

@interface LDMopubBanner : LDAdBanner <MPAdViewDelegate>

    @property(nonatomic, weak) id <LDAdBannerDelegate> delegate;
    @property(nonatomic, assign) BOOL autoRefresh;
    @property(nonatomic, strong) MPAdView *adView;

    - (instancetype)initWithAdUnit: (NSString *)adUnit size: (LDAdBannerSize)size;

@end

@implementation LDMopubBanner {
        bool _ready;
    }

    - (instancetype)initWithAdUnit: (NSString *)adUnit size: (LDAdBannerSize)size; {
        if (self = [super init]) {

            self.adView = [[MPAdView alloc] initWithAdUnitId: adUnit size: [self bannerSizeToCGSize: size]];
            _adView.delegate = self;
            _ready = NO;
        }
        return self;
    }

    - (void)dealloc {
        _adView.delegate = nil;
        if (_adView.superview) {
            [_adView removeFromSuperview];
        }
    }

    - (CGSize)bannerSizeToCGSize: (LDAdBannerSize)size {
        switch (size) {
            case LD_SMART_SIZE:
                return isIpad() ? MOPUB_LEADERBOARD_SIZE : MOPUB_BANNER_SIZE;
            case LD_LEADERBOARD_SIZE:
                return MOPUB_LEADERBOARD_SIZE;
            case LD_BANNER_SIZE:
                return MOPUB_BANNER_SIZE;
            case LD_MEDIUM_RECT_SIZE:
                return MOPUB_MEDIUM_RECT_SIZE;
        }
    }

    - (void)setAutoRefresh: (BOOL)autoRefresh {
        _autoRefresh = autoRefresh;
        if (_autoRefresh) {
            [_adView startAutomaticallyRefreshingContents];
        } else {
            [_adView stopAutomaticallyRefreshingContents];
        }
    }

    - (void)loadAd {
        [_adView loadAd];
    }

    - (bool)isReady {
        return _ready;
    }

    - (CGSize)adSize {
        return [_adView adContentViewSize];
    }

    - (UIView *)view {
        return _adView;
    }

#pragma mark MPAdViewDelegate

    - (UIViewController *)viewControllerForPresentingModalView {
        if (_delegate) {
            return [_delegate viewControllerForPresentingModalView];
        } else {
            UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
            return keyWindow.rootViewController;
        }
    }

    - (void)adViewDidLoadAd: (MPAdView *)view {
        _ready = YES;
        if (_delegate && [_delegate respondsToSelector: @selector(adBannerDidLoad:)]) {
            [_delegate adBannerDidLoad: self];
        }
    }

    - (void)adViewDidFailToLoadAd: (MPAdView *)view {
        if (_delegate && [_delegate respondsToSelector: @selector(adBannerDidFailLoad:withError:)]) {
            [_delegate adBannerDidFailLoad: self withError: nil];
        }
    }

    - (void)willPresentModalViewForAd: (MPAdView *)view {
        if (_delegate && [_delegate respondsToSelector: @selector(adBannerWillPresentModal:)]) {
            [_delegate adBannerWillPresentModal: self];
        }
    }

    - (void)didDismissModalViewForAd: (MPAdView *)view {
        if (_delegate && [_delegate respondsToSelector: @selector(adBannerDidDismissModal:)]) {
            [_delegate adBannerDidDismissModal: self];
        }
    }

@end

#pragma mark MoPub Interstitial implementation

@interface LDMopubInterstitial : LDAdInterstitial <MPInterstitialAdControllerDelegate>

    @property(nonatomic, weak) id <LDAdInterstitialDelegate> delegate;
    @property(nonatomic, strong) MPInterstitialAdController *adController;

    - (instancetype)initWithAdUnit: (NSString *)adUnit;

@end

@implementation LDMopubInterstitial

    - (instancetype)initWithAdUnit: (NSString *)adUnit {
        if (self = [super init]) {
            self.adController = [MPInterstitialAdController interstitialAdControllerForAdUnitId: adUnit];
            _adController.delegate = self;
        }
        return self;
    }

    - (void)dealloc {
        _adController.delegate = nil;
    }

    - (void)loadAd {
        [_adController loadAd];
    }

    - (bool)isReady {
        return _adController.ready;
    }

    - (void)showFromViewController: (UIViewController *)controller animated: (BOOL)animated {
        if (_adController.ready) {
            [_adController showFromViewController: controller];
        } else {
            [_adController loadAd];
        }
    }

    - (void)dismissAnimated: (BOOL)animated {
        //TODO
    }

#pragma mark MPInterstitialAdControllerDelegate

    - (void)interstitialDidLoadAd: (MPInterstitialAdController *)interstitial {
        if (_delegate && [_delegate respondsToSelector: @selector(adInterstitialDidLoad:)]) {
            [_delegate adInterstitialDidLoad: self];
        }
    }

    - (void)interstitialDidFailToLoadAd: (MPInterstitialAdController *)interstitial {
        if (_delegate && [_delegate respondsToSelector: @selector(adInterstitialDidFailLoad:withError:)]) {
            [_delegate adInterstitialDidFailLoad: self withError: nil];
        }
    }

    - (void)interstitialWillAppear: (MPInterstitialAdController *)interstitial {
        if (_delegate && [_delegate respondsToSelector: @selector(adInterstitialWillAppear:)]) {
            [_delegate adInterstitialWillAppear: self];
        }
    }

    - (void)interstitialDidDisappear: (MPInterstitialAdController *)interstitial {
        if (_delegate && [_delegate respondsToSelector: @selector(adInterstitialWillDisappear:)]) {
            [_delegate adInterstitialWillDisappear: self];
        }

    }

@end

#pragma mark MoPub RewardedVideo implementation

@interface LDMopubRewardedVideo : LDAdRewardedVideo <MPRewardedVideoDelegate>

    @property(nonatomic, weak) id <LDAdRewardedVideoDelegate> delegate;
    @property(nonatomic, strong) NSString *adUnit;

    - (instancetype)initWithAdUnit: (NSString *)adUnit;

@end

@implementation LDMopubRewardedVideo

    - (instancetype)initWithAdUnit: (NSString *)adUnit {
        if (self = [super init]) {
            _adUnit = adUnit;
        }
        return self;
    }

    - (void)loadAd {
        [MPRewardedVideo loadRewardedVideoAdWithAdUnitID: _adUnit withMediationSettings: nil];
    }

    - (BOOL)isReady {
        return [MPRewardedVideo hasAdAvailableForAdUnitID: _adUnit];
    }

    - (void)showFromViewController: (UIViewController *)controller animated: (BOOL)animated {
        if ([MPRewardedVideo hasAdAvailableForAdUnitID: _adUnit]) {
            [MPRewardedVideo presentRewardedVideoAdForAdUnitID: _adUnit fromViewController: controller withReward: nil];
        } else {
            [self loadAd];
            if (_delegate && [_delegate respondsToSelector: @selector(adRewardedVideoDidCompleteRewardedVideo:withReward:andError:)]) {
                NSError *error = [NSError errorWithDomain: @"mopub.com" code: 0 userInfo: @{NSLocalizedDescriptionKey: @"Rewarded Video not loaded yet"}];
                [_delegate adRewardedVideoDidCompleteRewardedVideo: self withReward: nil andError: error];
            }
        }
    }

    - (void)dismissAnimated: (BOOL)animated {
        //TODO
    }

#pragma mark RewardedVideoDelegate

    - (void)rewardedVideoAdDidLoadForAdUnitID: (NSString *)adUnitID {
        if (_delegate && [_delegate respondsToSelector: @selector(adRewardedVideoDidLoad:)]) {
            [_delegate adRewardedVideoDidLoad: self];
        }
    }

    - (void)rewardedVideoAdDidFailToLoadForAdUnitID: (NSString *)adUnitID error: (NSError *)error {
        if (_delegate && [_delegate respondsToSelector: @selector(adRewardedVideoDidFailLoad:withError:)]) {
            [_delegate adRewardedVideoDidFailLoad: self withError: nil];
        }
    }

    - (void)rewardedVideoAdDidExpireForAdUnitID: (NSString *)adUnitID {
        if (_delegate && [_delegate respondsToSelector: @selector(adRewardedVideoDidFailLoad:withError:)]) {
            [_delegate adRewardedVideoDidFailLoad: self withError: nil];
        }
    }

    - (void)rewardedVideoAdDidFailToPlayForAdUnitID: (NSString *)adUnitID error: (NSError *)error {
        if (_delegate && [_delegate respondsToSelector: @selector(adRewardedVideoDidCompleteRewardedVideo:withReward:andError:)]) {
            [_delegate adRewardedVideoDidCompleteRewardedVideo: self withReward: nil andError: error];
        }
    }

    - (void)rewardedVideoAdWillAppearForAdUnitID: (NSString *)adUnitID {
        if (_delegate && [_delegate respondsToSelector: @selector(adRewardedVideoWillAppear:)]) {
            [_delegate adRewardedVideoWillAppear: self];
        }
    }

    - (void)rewardedVideoAdDidDisappearForAdUnitID: (NSString *)adUnitID {
        if (_delegate && [_delegate respondsToSelector: @selector(adRewardedVideoWillDisappear:)]) {
            [_delegate adRewardedVideoWillDisappear: self];
        }
    }

    - (void)rewardedVideoAdShouldRewardForAdUnitID: (NSString *)adUnitID reward: (MPRewardedVideoReward *)reward {
        if (_delegate && [_delegate respondsToSelector: @selector(adRewardedVideoDidCompleteRewardedVideo:withReward:andError:)]) {
            LDMoPubRewardedVideoReward *mopubReward = [[LDMoPubRewardedVideoReward alloc] init];
            mopubReward.amount = [NSNumber numberWithInteger: fmax(reward.amount.integerValue, 1)];
            mopubReward.currencyType = reward.currencyType;
            mopubReward.itmKey = nil;
            [_delegate adRewardedVideoDidCompleteRewardedVideo: self withReward: mopubReward andError: nil];
        }
    }

@end

#pragma mark MoPub AdService implementation

@implementation LDAdServiceMoPub {
        LDMoPubSettings *_settings;
    }

    - (instancetype)init {
        if (self = [super init]) {
            _settings = [[LDMoPubSettings alloc] init];
        }
        return self;
    }

    - (LDAdBanner *)createBanner {
        return [self createBanner: nil size: LD_SMART_SIZE];
    }

    - (LDAdBanner *)createBanner: (NSString *)banner size: (LDAdBannerSize)size {
        NSString *adUnit = banner;
        if (!adUnit) {
            adUnit = isIpad() ? (_settings.bannerIpad ? : _settings.banner) : _settings.banner;
        }

        return [[LDMopubBanner alloc] initWithAdUnit: adUnit size: size];
    }

    - (LDAdInterstitial *)createInterstitial {

        return [self createInterstitial: nil];
    }

    - (LDAdInterstitial *)createInterstitial: (NSString *)interstitial {
        NSString *adUnit = interstitial;
        if (!adUnit) {
            adUnit = isIpad() ? (_settings.interstitialIpad ? : _settings.interstitial) : _settings.interstitial;
        }

        return [[LDMopubInterstitial alloc] initWithAdUnit: adUnit];
    }

    - (LDAdInterstitial *)createVideoInterstitial: (NSString *)adUnit {
        return [self createInterstitial: adUnit];
    }

    - (LDAdRewardedVideo *)createRewardedVideo: (NSString *)rewardedVideo {
        NSString *adUnit = rewardedVideo;
        if (!adUnit) {
            adUnit = isIpad() ? (_settings.rewardedVideoIpad ? : _settings.rewardedVideo) : _settings.rewardedVideo;
        }

        return [[LDMopubRewardedVideo alloc] initWithAdUnit: adUnit];
    }

@end
