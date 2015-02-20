#import "LDAdMobPlugin.h"
#import "LDAdServiceAdMob.h"

@implementation LDAdMobPlugin

- (void)pluginInitialize
{
    [super pluginInitialize];
    
    LDAdServiceAdMob * admob = [[LDAdServiceAdMob alloc] init];
    admob.settings.banner = [self.commandDelegate.settings objectForKey:@"admob_banner"];
    admob.settings.bannerIpad = [self.commandDelegate.settings objectForKey:@"mopub_bannerIpad"] ?: admob.settings.banner;
    admob.settings.interstitial = [self.commandDelegate.settings objectForKey:@"admob_interstitial"];
    admob.settings.interstitialIpad = [self.commandDelegate.settings objectForKey:@"admob_interstitialIpad"] ?: admob.settings.interstitial;

    self.service = admob;
}

@end
