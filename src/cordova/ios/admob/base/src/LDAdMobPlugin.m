#import "LDAdMobPlugin.h"
#import "LDAdServiceAdMob.h"
@import GoogleMobileAds;

@implementation LDAdMobPlugin

    - (void)pluginInitialize {
        [super pluginInitialize];

        LDAdServiceAdMob *adMob = [[LDAdServiceAdMob alloc] init];
        adMob.settings.appId = [self.commandDelegate.settings objectForKey: @"admob_appId"];
        adMob.settings.banner = [self.commandDelegate.settings objectForKey: @"admob_banner"];
        adMob.settings.bannerIpad = [self.commandDelegate.settings objectForKey: @"admob_bannerIpad"] ? : adMob.settings.banner;
        adMob.settings.interstitial = [self.commandDelegate.settings objectForKey: @"admob_interstitial"];
        adMob.settings.interstitialIpad = [self.commandDelegate.settings objectForKey: @"admob_interstitialIpad"] ? : adMob.settings.interstitial;
        adMob.settings.rewardedVideo = [self.commandDelegate.settings objectForKey: @"admob_rewardedVideo"];
        adMob.settings.rewardedVideoIpad = [self.commandDelegate.settings objectForKey: @"admob_rewardedVideoIpad"] ? : adMob.settings.rewardedVideo;
        adMob.settings.personalizedAdsConsent = [[self.commandDelegate.settings objectForKey: @"admob_personalizedAdsConsent"] boolValue];

        [GADMobileAds configureWithApplicationID: adMob.settings.appId];

        NSLog(@"Posting AdMob consent notification");

        [[NSNotificationCenter defaultCenter] postNotificationName: @"AdMob_Consent"
                                                            object: nil
                                                          userInfo: @{@"consent": adMob.settings.personalizedAdsConsent ? @"YES" : @"NO"}];

        self.service = adMob;
    }

@end
