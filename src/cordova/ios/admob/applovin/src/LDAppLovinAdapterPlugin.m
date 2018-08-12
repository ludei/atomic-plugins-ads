#import "LDAppLovinAdapterPlugin.h"
#import <AppLovinSDK/AppLovinSDK.h>

@implementation LDAppLovinAdapterPlugin

    - (void)pluginInitialize {
        [super pluginInitialize];

        [[NSNotificationCenter defaultCenter] addObserverForName: @"AdMob_Consent"
                                                          object: nil
                                                           queue: [NSOperationQueue mainQueue]
                                                      usingBlock: ^(NSNotification *notification) {
                                                          NSLog(@"Setting AppLovin user consent as: %@", notification.userInfo[@"consent"]);

                                                          [ALPrivacySettings setHasUserConsent: [notification.userInfo[@"consent"] isEqual: @"YES"] ? YES : NO];
                                                      }];

    }

@end
