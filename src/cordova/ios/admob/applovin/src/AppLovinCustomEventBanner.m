#if  ! __has_feature(objc_arc)
    #error This file must be compiled with ARC. Use the -fobjc-arc flag in the XCode build phases tab.
#endif

#import "AppLovinCustomEventBanner.h"

@implementation AppLovinCustomEventBanner;

// Will be set by the AdMob SDK.
@synthesize delegate;

// Used internally.
@synthesize adView;

#pragma mark -
#pragma mark GADCustomEventBanner

- (void)requestBannerAd:(GADAdSize)adSize
              parameter:(NSString *)serverParameter
                  label:(NSString *)serverLabel
                request:(GADCustomEventRequest *)request  {
    
    if (!adView) {
        adView = [[ALAdView alloc] initWithSize:[ALAdSize sizeBanner]];
    }
    
    [adView setAdLoadDelegate:self];
    [adView setAdDisplayDelegate:self];
    [adView loadNextAd];
}

// This method would be called when a new ad was loaded
-(void)adService:(ALAdService *)adService didLoadAd:(ALAd *)ad {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.delegate customEventBanner:self didReceiveAd: adView];
    }];
}

// This method would be called when an was requested but ad failed to load
-(void)adService:(ALAdService *)adService didFailToLoadAdWithError:(int)code {
    NSError *error = [[NSError alloc] init];
    [self.delegate customEventBanner:self didFailAd:error];
}

-(void) ad:(ALAd *) ad wasClickedIn: (UIView *)view {
    [self.delegate customEventBannerWillLeaveApplication:self];
}

-(void) ad:(ALAd *) ad wasHiddenIn:(UIView *)view {
    // No callback to Google as we don't use modal dialogs
}

-(void) ad:(ALAd *) ad wasDisplayedIn:(UIView *)view {
    // No callback to Google as we don't use modal dialogs
}

@end