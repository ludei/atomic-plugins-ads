//
//  InMobiRewardedCustomEvent.m
//  InMobiMopubSampleApp
//
//  Created by Niranjan Agrawal on 28/10/15.
//
//

#import <Foundation/Foundation.h>
#import "InMobiRewardedCustomEvent.h"
#import <MoPub/MPLogging.h>
#import <MoPub/MPRewardedVideoReward.h>
#import <MoPub/MPRewardedVideoError.h>
#import <MoPub/MPInstanceProvider.h>
#import <InMobi/IMSdk.h>



@interface MPInstanceProvider (InMobiInterstitials)

- (IMInterstitial *)buildIMInterstitialWithDelegate:(id)delegate placementId:(long long)placementId;

@end

@implementation MPInstanceProvider (InMobiInterstitials)

- (IMInterstitial *)buildIMInterstitialWithDelegate:(id)delegate placementId:(long long)placementId {
    IMInterstitial *inMobiInterstitial = [[IMInterstitial alloc] initWithPlacementId:placementId];
    inMobiInterstitial.delegate = delegate;
    return inMobiInterstitial;
}

@end


@implementation InMobiRewardedCustomEvent
@synthesize inMobiInterstitial = _inMobiInterstitial;

- (void)requestRewardedVideoWithCustomEventInfo:(NSDictionary *)info
{
    [IMSdk initWithAccountID:[info valueForKey:@"accountid"]];
    self.inMobiInterstitial = [[MPInstanceProvider sharedProvider] buildIMInterstitialWithDelegate:self placementId:[[info valueForKey:@"placementid"] longLongValue]];
    NSMutableDictionary *paramsDict = [[NSMutableDictionary alloc] init];
    [paramsDict setObject:@"c_mopub" forKey:@"tp"];
    [paramsDict setObject:MP_SDK_VERSION forKey:@"tp-ver"];
    self.inMobiInterstitial.extras = paramsDict; // For supply source identification
    [self.inMobiInterstitial load];
}

- (BOOL)hasAdAvailable
{
    if (self.inMobiInterstitial!=NULL && [self.inMobiInterstitial isReady]) {
        return true;
    }
    return false;
}

- (void)presentRewardedVideoFromViewController:(UIViewController *)viewController
{
    if([self hasAdAvailable]){
    [self.inMobiInterstitial showFromViewController:viewController withAnimation:kIMInterstitialAnimationTypeCoverVertical];
    }
    else{
         NSError *error = [NSError errorWithDomain:MoPubRewardedVideoAdsSDKDomain code:MPRewardedVideoAdErrorNoAdsAvailable userInfo:nil];
         [self.delegate rewardedVideoDidFailToPlayForCustomEvent:self error:error];
    }
}

- (BOOL)enableAutomaticImpressionAndClickTracking{
    return YES;
}

-(void)interstitialDidFinishLoading:(IMInterstitial*)interstitial {
    MPLogInfo(@"InMobi interstitial did load");
    [self.delegate rewardedVideoDidLoadAdForCustomEvent:self];
    //[self.delegate interstitialCustomEvent:self didLoadAd:interstitial];
}


- (void)handleCustomEventInvalidated
{
    //Do nothing
}

-(void)interstitial:(IMInterstitial*)interstitial didFailToLoadWithError:(IMRequestStatus*)error {
    MPLogInfo(@"InMobi interstitial did fail with error: %@", error);
    [self.delegate rewardedVideoDidFailToLoadAdForCustomEvent:self error:(NSError*)error];
    //[self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:(NSError *)error];
}

-(void)interstitialWillPresent:(IMInterstitial*)interstitial {
    MPLogInfo(@"InMobi interstitial will present");
    [self.delegate rewardedVideoWillAppearForCustomEvent:self];\
}

-(void)interstitialDidPresent:(IMInterstitial *)interstitial {
    MPLogInfo(@"InMobi interstitial did present");
    [self.delegate rewardedVideoDidAppearForCustomEvent:self];
}

-(void)interstitial:(IMInterstitial*)interstitial didFailToPresentWithError:(IMRequestStatus*)error {
    MPLogInfo(@"InMobi interstitial failed to present with error: %@", error);
    [self.delegate rewardedVideoDidFailToPlayForCustomEvent:self error:(NSError *)error];
}

-(void)interstitialWillDismiss:(IMInterstitial*)interstitial {
    MPLogInfo(@"InMobi interstitial will dismiss");
    [self.delegate rewardedVideoWillDisappearForCustomEvent:self];
}

-(void)interstitialDidDismiss:(IMInterstitial*)interstitial {
    MPLogInfo(@"InMobi interstitial did dismiss");
    [self.delegate rewardedVideoDidDisappearForCustomEvent:self];
}

-(void)interstitial:(IMInterstitial*)interstitial didInteractWithParams:(NSDictionary*)params {
    MPLogInfo(@"InMobi interstitial was tapped");
    [self.delegate rewardedVideoDidReceiveTapEventForCustomEvent:self];
}

-(void)interstitial:(IMInterstitial*)interstitial rewardActionCompletedWithRewards:(NSDictionary*)rewards {
    NSLog(@"InMobi interstitial reward action completed with rewards: %@", [rewards description]);
    MPRewardedVideoReward *reward = [[MPRewardedVideoReward alloc]initWithCurrencyType:kMPRewardedVideoRewardCurrencyTypeUnspecified amount:[rewards allValues][0]];
    [self.delegate rewardedVideoShouldRewardUserForCustomEvent:self reward:(MPRewardedVideoReward*)reward];
}

-(void)userWillLeaveApplicationFromInterstitial:(IMInterstitial*)interstitial {
    MPLogInfo(@"InMobi interstitial will leave application");
    [self.delegate rewardedVideoWillLeaveApplicationForCustomEvent:self];
}


@end