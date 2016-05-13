//
//  InMobiBannerCustomEvent.m
//  InMobi
//

#import "InMobiBannerCustomEvent.h"
#import <MoPub/MPInstanceProvider.h>
#import <MoPub/MPConstants.h>
#import <MoPub/MPLogging.h>
#import <InMobi/IMSdk.h>

@interface MPInstanceProvider (InMobiBanners)

- (IMBanner *)buildIMBannerWithFrame:(CGRect)frame placementId:(long long)placementId;

@end

@implementation MPInstanceProvider (InMobiBanners)

- (IMBanner *)buildIMBannerWithFrame:(CGRect)frame placementId:(long long)placementId
{
    return [[IMBanner alloc] initWithFrame:frame placementId:placementId];
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface InMobiBannerCustomEvent () <CLLocationManagerDelegate>

@property (nonatomic, retain) IMBanner *inMobiBanner;
@property (nonatomic,strong) CLLocationManager *locationManager;

@end

@implementation InMobiBannerCustomEvent

#pragma mark - MPBannerCustomEvent Subclass Methods

- (void)requestAdWithSize:(CGSize)size customEventInfo:(NSDictionary *)info
{
    MPLogInfo(@"Requesting InMobi banner");
    [IMSdk initWithAccountID:[info valueForKey:@"accountid"]];
    self.inMobiBanner = [[MPInstanceProvider sharedProvider] buildIMBannerWithFrame:CGRectMake(0, 0, size.width, size.height) placementId:[[info valueForKey:@"placementid"] longLongValue]];
    self.inMobiBanner.delegate = self;
    [self.inMobiBanner shouldAutoRefresh:NO];
    NSMutableDictionary *paramsDict = [[NSMutableDictionary alloc] init];
    [paramsDict setObject:@"c_mopub" forKey:@"tp"];
	[paramsDict setObject:MP_SDK_VERSION forKey:@"tp-ver"];
    self.inMobiBanner.extras = paramsDict; // For supply source identification
    [self.inMobiBanner load];
}

- (BOOL)enableAutomaticImpressionAndClickTracking
{
    // Override this method to return NO to perform impression and click tracking manually.
    return NO;
}

#pragma mark - IMBannerDelegate


-(void)bannerDidFinishLoading:(IMBanner*)banner {
    MPLogInfo(@"InMobi banner did load");
    [self.delegate trackImpression];
    [self.delegate bannerCustomEvent:self didLoadAd:banner];
}

-(void)banner:(IMBanner*)banner didFailToLoadWithError:(IMRequestStatus*)error {
    MPLogInfo(@"InMobi banner did fail with error: %@", error);
    [self.delegate bannerCustomEvent:self didFailToLoadAdWithError:(NSError *)error];
}

-(void)banner:(IMBanner*)banner didInteractWithParams:(NSDictionary*)params {
    MPLogInfo(@"InMobi banner was clicked");
    [self.delegate trackClick];
}

-(void)userWillLeaveApplicationFromBanner:(IMBanner*)banner {
    MPLogInfo(@"InMobi banner will leave application");
    [self.delegate bannerCustomEventWillLeaveApplication:self];
}

-(void)bannerWillPresentScreen:(IMBanner*)banner {
    MPLogInfo(@"InMobi banner will present screen");
    [self.delegate bannerCustomEventWillBeginAction:self];
}

-(void)bannerDidPresentScreen:(IMBanner*)banner {
    NSLog(@"InMobi banner did present screen");
}

-(void)bannerWillDismissScreen:(IMBanner*)banner {
    NSLog(@"InMobi banner will dismiss screen");
}

-(void)bannerDidDismissScreen:(IMBanner*)banner {
    NSLog(@"InMobi banner did dismiss screen");
    [self.delegate bannerCustomEventDidFinishAction:self];
}

-(void)banner:(IMBanner*)banner rewardActionCompletedWithRewards:(NSDictionary*)rewards {
    NSLog(@"InMobi banner reward action completed with rewards: %@", [rewards description]);
}

@end
