#import "LDMoPubPlugin.h"
#import "LDAdServiceMoPub.h"

@implementation LDMoPubPlugin

    - (void)pluginInitialize {
        [super pluginInitialize];

        LDAdServiceMoPub *mopub = [[LDAdServiceMoPub alloc] init];
        mopub.settings.banner = [self.commandDelegate.settings objectForKey: @"mopub_banner"];
        mopub.settings.bannerIpad = [self.commandDelegate.settings objectForKey: @"mopub_bannerIpad"] ? : mopub.settings.banner;
        mopub.settings.interstitial = [self.commandDelegate.settings objectForKey: @"mopub_interstitial"];
        mopub.settings.interstitialIpad = [self.commandDelegate.settings objectForKey: @"mopub_interstitialIpad"] ? : mopub.settings.interstitial;

        self.service = mopub;
    }

@end
