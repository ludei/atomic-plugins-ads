#import "GADMAdapterAppLovinRewardBasedVideoAd.h"

#import <AppLovin/ALSdk.h>
#import <AppLovin/ALIncentivizedInterstitialAd.h>
#import <GoogleMobileAds/MEdiation/GADMRewardBasedVideoAdNetworkConnectorProtocol.h>

@interface GADMAdapterAppLovinRewardBasedVideoAd () <ALAdLoadDelegate, ALAdRewardDelegate, ALAdDisplayDelegate, ALAdVideoPlaybackDelegate>

@property (nonatomic, assign, getter=isFullyWatched) BOOL fullyWatched;
@property (nonatomic, strong) GADAdReward *reward;
@property (nonatomic,   weak) id<GADMRewardBasedVideoAdNetworkConnector> connector;

@end

@implementation GADMExtrasAppLovin
@end

@implementation GADMAdapterAppLovinRewardBasedVideoAd

static const BOOL loggingEnabled = NO;
static NSString *const kGADMAdapterAppLovinRewardBasedVideoAdKeyErrorDomain = @"com.google.GADMAdapterAppLovinRewardBasedVideoAd";

+ (NSString *)adapterVersion {
    return @"1.0.0";
}

+ (Class<GADAdNetworkExtras>)networkExtrasClass {
    return [GADMExtrasAppLovin class];
}
- (instancetype)initWithRewardBasedVideoAdNetworkConnector:(id<GADMRewardBasedVideoAdNetworkConnector>)connector {
    self = [super init];
    if (self) {
        self.connector = connector;
    }
    
    return self;
}

- (void)setUp {
    [[ALSdk shared] initializeSdk];
    [self ALLog:@"Initializing adapter."];
    [self.connector adapterDidSetUpRewardBasedVideoAd:self];
}

- (void)requestRewardBasedVideoAd {
    self.reward = nil;
    self.fullyWatched = NO;
    GADMExtrasAppLovin *extras = [self.connector networkExtras];
    [self ALLog:[NSString stringWithFormat:@"Rewarded video request number %ld", (long)extras.requestNumber]];
    [ALIncentivizedInterstitialAd preloadAndNotify:self];
}

- (void)presentRewardBasedVideoAdWithRootViewController:(UIViewController *)viewController {
    [self setSharedDelegates];
    [ALIncentivizedInterstitialAd showAndNotify: self];
}

- (void)setSharedDelegates {
    [ALIncentivizedInterstitialAd shared].adDisplayDelegate = self;
    [ALIncentivizedInterstitialAd shared].adVideoPlaybackDelegate = self;
}

- (void)unsetSharedDelegates {
    [ALIncentivizedInterstitialAd shared].adDisplayDelegate = nil;
    [ALIncentivizedInterstitialAd shared].adVideoPlaybackDelegate = nil;
}

- (void)stopBeingDelegate {
    [self unsetSharedDelegates];
    self.connector = nil;
}

#pragma mark - ALAdLoadDelegate

- (void)adService:(ALAdService *)adService didLoadAd:(ALAd *)ad {
    [self ALLog:@"Rewarded video loaded."];
    [self.connector adapterDidReceiveRewardBasedVideoAd:self];
}

- (void)adService:(ALAdService *)adService didFailToLoadAdWithError:(int)code {
    [self ALLog:@"Rewarded video failed to load."];
    NSDictionary *errorInfo = @{ NSLocalizedDescriptionKey : @"No ad to show." };
    NSError *error = [NSError errorWithDomain: kGADMAdapterAppLovinRewardBasedVideoAdKeyErrorDomain
                                         code: (code == kALErrorCodeNoFill) ? kGADErrorMediationNoFill : kGADErrorNetworkError
                                     userInfo: errorInfo];
    [self.connector adapter: self didFailToLoadRewardBasedVideoAdwithError: error];
}

#pragma mark - ALAdRewardDelegate

- (void)rewardValidationRequestForAd:(ALAd *)ad didSucceedWithResponse:(NSDictionary *)response {
    [self ALLog:@"Reward validation successful."];
    self.reward = [[GADAdReward alloc]
                   initWithRewardType: response[@"currency"]
                   rewardAmount: [NSDecimalNumber decimalNumberWithString:response[@"amount"]]];
    

}

- (void)rewardValidationRequestForAd:(ALAd *)ad
          didExceedQuotaWithResponse:(NSDictionary *)response {
    [self ALLog:@"User exceeded quota."];
}

- (void)rewardValidationRequestForAd:(ALAd *)ad wasRejectedWithResponse:(NSDictionary *)response {
    [self ALLog:@"User reward rejected by AppLovin servers."];
}

- (void)rewardValidationRequestForAd:(ALAd *)ad didFailWithError:(NSInteger)responseCode {
    [self ALLog:@"User could not be validated due to network issue or closed ad early."];
}

#pragma mark - ALAdDisplayDelegate

- (void)ad:(ALAd *)ad wasClickedIn:(UIView *)view {
    [self ALLog:@"Rewarded video was clicked."];
    [self.connector adapterDidGetAdClick:self];
    [self.connector adapterWillLeaveApplication: self];
}

- (void)ad:(ALAd *)ad wasDisplayedIn:(UIView *)view {
    [self ALLog:@"Rewarded video was displayed."];
    [self.connector adapterDidOpenRewardBasedVideoAd: self];
}

- (void)ad:(ALAd *)ad wasHiddenIn:(UIView *)view {
    [self ALLog:@"Rewarded video was closed."];
    
    if (self.fullyWatched && self.reward) {
        [self.connector adapter: self didRewardUserWithReward: self.reward];
        [self ALLog:@"Granting reward for user."];
    }
    
    [self.connector adapterDidCloseRewardBasedVideoAd:self];
    [self unsetSharedDelegates];
}

#pragma mark - ALAdVideoPlaybackDelegate

- (void)videoPlaybackBeganInAd:(ALAd *)ad {
    [self ALLog:@"Rewarded video playback began."];
    [self.connector adapterDidStartPlayingRewardBasedVideoAd:self];
}

- (void)videoPlaybackEndedInAd:(ALAd *)ad
             atPlaybackPercent:(NSNumber *)percentPlayed
                  fullyWatched:(BOOL)wasFullyWatched {
    [self ALLog:@"Rewarded video playback ended."];
    
    self.fullyWatched = wasFullyWatched;
}

- (void)ALLog:(NSString *)logMessage {
    if (loggingEnabled) {
        NSLog(@"AppLovinAdapter: %@", logMessage);
    }
}

@end
