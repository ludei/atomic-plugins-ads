#import "LDMoPubPlugin.h"
#import "LDAdServiceMoPub.h"

@implementation LDMoPubPlugin

    - (void)pluginInitialize {
        [super pluginInitialize];

        LDAdServiceMoPub *moPub = [[LDAdServiceMoPub alloc] init];
        moPub.settings.appId = [self.commandDelegate.settings objectForKey: @"mopub_appId"];
        moPub.settings.banner = [self.commandDelegate.settings objectForKey: @"mopub_banner"];
        moPub.settings.bannerIpad = [self.commandDelegate.settings objectForKey: @"mopub_bannerIpad"] ? : mopub.settings.banner;
        moPub.settings.interstitial = [self.commandDelegate.settings objectForKey: @"mopub_interstitial"];
        moPub.settings.interstitialIpad = [self.commandDelegate.settings objectForKey: @"mopub_interstitialIpad"] ? : mopub.settings.interstitial;
        moPub.settings.rewardedVideo = [self.commandDelegate.settings objectForKey: @"mopub_rewardedVideo"];
        moPub.settings.rewardedVideoIpad = [self.commandDelegate.settings objectForKey: @"mopub_rewardedVideoIpad"] ? : mopub.settings.rewardedVideo;
        moPub.settings.personalizedAdsConsent = [[self.commandDelegate.settings objectForKey: @"mopub_personalizedAdsConsent"] boolValue];

        MPMoPubConfiguration *sdkConfig = [[MPMoPubConfiguration alloc] initWithAdUnitIdForAppInitialization: moPub.settings.appId];

        [[MoPub sharedInstance] initializeSdkWithConfiguration:sdkConfig completion:nil]

        self.service = moPub;
    }

@end
