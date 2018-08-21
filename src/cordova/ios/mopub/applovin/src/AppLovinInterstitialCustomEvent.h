//
// AppLovin <--> MoPub Network Adaptors
//

#import <MoPub/MPInterstitialCustomEvent.h>

#import <AppLovin/ALInterstitialAd.h>
#import <AppLovin/ALAdService.h>

@interface AppLovinInterstitialCustomEvent : MPInterstitialCustomEvent <ALAdLoadDelegate, ALAdDisplayDelegate>

    @property(strong, nonatomic) ALInterstitialAd *interstitialAd;
    @property(strong, nonatomic) ALAd *loadedAd;

@end
