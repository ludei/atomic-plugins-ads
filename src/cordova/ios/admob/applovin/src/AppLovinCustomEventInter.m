#if  ! __has_feature(objc_arc)
    #error This file must be compiled with ARC. Use the -fobjc-arc flag in the XCode build phases tab.
#endif

#import "AppLovinCustomEventInter.h"

@implementation AppLovinCustomEventInter;

// Will be set by the AdMob SDK.
@synthesize delegate;

// Used internally.
@synthesize appLovinAd;

#pragma mark -
#pragma mark GADCustomEventBanner

-(void) presentFromRootViewController:(UIViewController *)rootViewController
{
    [[ALInterstitialAd shared] setAdDisplayDelegate: self];
    [[ALInterstitialAd shared] showOver:rootViewController.view.window andRender:appLovinAd];
}

- (void)requestInterstitialAdWithParameter:(NSString *)serverParameter label:(NSString *)serverLabel request:(GADCustomEventRequest *)request
{
    [[[ALSdk shared] adService] loadNextAd:[ALAdSize sizeInterstitial] andNotify:self];
}

// This method would be called when a new ad was loaded
-(void)adService:(ALAdService *)adService didLoadAd:(ALAd *)ad {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        appLovinAd = ad;
        [self.delegate customEventInterstitialDidReceiveAd:self];
        
        /**
         *  For older versions of AdMob use instead:
         *  [self.delegate customEventInterstitial:self didReceiveAd:appLovinAd];
         **/
    }];
}

// This method would be called when an was requested but ad failed to load
-(void)adService:(ALAdService *)adService didFailToLoadAdWithError:(int)code {
    NSError *error = [[NSError alloc] init];
    [self.delegate customEventInterstitial:self didFailAd:error];
}

-(void) ad:(ALAd *) ad wasClickedIn: (UIView *)view {
    [self.delegate customEventInterstitialWillLeaveApplication:self];
}

-(void) ad:(ALAd *) ad wasHiddenIn:(UIView *)view {
    [self.delegate customEventInterstitialWillDismiss:self];
    [self.delegate customEventInterstitialDidDismiss:self];
}

-(void) ad:(ALAd *) ad wasDisplayedIn:(UIView *)view {
    [self.delegate customEventInterstitialWillPresent:self];
}

@end
