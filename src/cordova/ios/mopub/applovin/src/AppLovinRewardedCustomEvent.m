//
//  AppLovinRewardedCustomEvent.m
//  MoPub Rewarded Adapter
//
//  Created on 10/14/15.
//  Copyright © 2015 AppLovin. All rights reserved.
//

#if !__has_feature(objc_arc)
#error This file must be compiled with ARC. Use the -fobjc-arc flag in the XCode build phases tab.
#endif

#import "AppLovinRewardedCustomEvent.h"
#import <AppLovin/ALIncentivizedInterstitialAd.h>
#import <MoPub/MPRewardedVideoReward.h>

static NSString *const kALMoPubMediationErrorDomain =
    @"com.applovin.sdk.mediation.mopub.errorDomain";
static BOOL loggingEnabled = YES;

@interface AppLovinRewardedCustomEvent ()
@property(nonatomic, strong) ALIncentivizedInterstitialAd *incent;
@property(atomic, assign) BOOL adReady;
@end

@implementation AppLovinRewardedCustomEvent

- (void)requestRewardedVideoWithCustomEventInfo:(NSDictionary *)info {
  NSLog(@"MoPub adapter requesting rewarded video.");

  self.incent =
      [[ALIncentivizedInterstitialAd alloc] initWithSdk:[ALSdk shared]];
  self.incent.adVideoPlaybackDelegate = self;
  self.incent.adDisplayDelegate = self;

  if (!self.adReady) {
    [self.incent preloadAndNotify:self];
  }
}

- (BOOL)hasAdAvailable {
  return self.adReady;
}

- (void)presentRewardedVideoFromViewController:
    (UIViewController *)viewController {
  [self ALLog:@"MoPub adapter showing rewarded video."];
  if (self.adReady) {
    [self.incent showAndNotify:self];
  } else {
    NSError *error =
        [NSError errorWithDomain:kALMoPubMediationErrorDomain
                            code:-1
                        userInfo:@{
                          NSLocalizedFailureReasonErrorKey :
                              @"Adaptor requested to display a rewarded video "
                              @"before one was loaded."
                        }];

    [self.delegate rewardedVideoDidFailToPlayForCustomEvent:self error:error];
  }
}

- (void)handleCustomEventInvalidated {
}

- (void) handleAdPlayedForCustomEventNetwork {
	//	This method has to be implemented as its part of the MPRewardedVideoCustomEvent interface
	//	Otherwise an exception is thrown and app crashes:
	//		-[AppLovinRewardedCustomEvent handleAdPlayedForCustomEventNetwork]: unrecognized selector sent to instance 0xxxxxxx
}

#pragma mark ALAdLoadDelegate methods

- (void)adService:(ALAdService *)adService didFailToLoadAdWithError:(int)code {
  [self ALLog:@"Rewarded video failed to load."];
  NSError *error = [NSError errorWithDomain:kALMoPubMediationErrorDomain
                                       code:code
                                   userInfo:nil];

  [self.delegate rewardedVideoDidFailToLoadAdForCustomEvent:self error:error];
}

- (void)adService:(ALAdService *)adService didLoadAd:(ALAd *)ad {
  [self ALLog:@"Rewarded video was loaded."];
  [self.delegate rewardedVideoDidLoadAdForCustomEvent:self];
  self.adReady = YES;
}

#pragma mark ALAdDisplayDelegate methods

- (void)ad:(ALAd *)ad wasClickedIn:(UIView *)view {
  [self ALLog:@"Rewarded video was clicked."];
  [self.delegate rewardedVideoDidReceiveTapEventForCustomEvent:self];
  [self.delegate rewardedVideoWillLeaveApplicationForCustomEvent:self];
}

- (void)ad:(ALAd *)ad wasDisplayedIn:(UIView *)view {
  [self ALLog:@"Rewarded video was displayed."];
  [self.delegate rewardedVideoWillAppearForCustomEvent:self];
  [self.delegate rewardedVideoDidAppearForCustomEvent:self];
}

- (void)ad:(ALAd *)ad wasHiddenIn:(UIView *)view {
  [self ALLog:@"Rewarded video was closed."];
  [self.delegate rewardedVideoWillDisappearForCustomEvent:self];
  [self.delegate rewardedVideoDidDisappearForCustomEvent:self];
}

#pragma mark - ALAdVideoPlaybackDelegate methods

- (void)videoPlaybackBeganInAd:(ALAd *)ad {
  [self ALLog:@"Rewarded video playback began"];
  self.adReady = NO;
}

- (void)videoPlaybackEndedInAd:(ALAd *)ad
             atPlaybackPercent:(NSNumber *)percentPlayed
                  fullyWatched:(BOOL)wasFullyWatched {
  [self ALLog:@"Rewarded video playback ended."];
}

#pragma mark - ALAdRewardDelegate methods

- (void)rewardValidationRequestForAd:(ALAd *)ad
          didExceedQuotaWithResponse:(NSDictionary *)response {
  [self ALLog:@"User exceeded quota."];
}

- (void)rewardValidationRequestForAd:(ALAd *)ad
                    didFailWithError:(NSInteger)responseCode {
  [self ALLog:@"User could not be validated or closed ad early."];
}

- (void)rewardValidationRequestForAd:(ALAd *)ad
              didSucceedWithResponse:(NSDictionary *)response {
  [self ALLog:@"Granting reward."];
  NSNumber *amount = [response objectForKey:@"amount"];
  NSString *currency = [response objectForKey:@"currency"];

  MPRewardedVideoReward *reward =
      [[MPRewardedVideoReward alloc] initWithCurrencyType:currency
                                                   amount:amount];
  [self.delegate rewardedVideoShouldRewardUserForCustomEvent:self
                                                      reward:reward];
}

- (void)rewardValidationRequestForAd:(ALAd *)ad
             wasRejectedWithResponse:(NSDictionary *)response {
  [self ALLog:@"User rejected by AppLovin servers."];
}

- (void)userDeclinedToViewAd:(ALAd *)ad {
  [self ALLog:@"User declined to view rewarded video."];
  self.adReady = YES;
}

- (void)ALLog:(NSString *)logMessage {
  if (loggingEnabled) {
    NSLog(@"AppLovinAdapter: %@", logMessage);
  }
}

@end
