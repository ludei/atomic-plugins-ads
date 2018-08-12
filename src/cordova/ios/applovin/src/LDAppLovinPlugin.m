#import "LDAppLovinPlugin.h"
#import <AppLovinSDK/AppLovinSDK.h>

@implementation LDAppLovinPlugin

    - (void)pluginInitialize {
        [super pluginInitialize];

        [ALSdk initializeSdk];
    }

@end
