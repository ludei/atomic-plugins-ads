#import "LDUnityAdsAdapterPlugin.h"
#import "UnityAds/UnityAds.h"

@implementation LDUnityAdsAdapterPlugin

    - (void)pluginInitialize {
        [super pluginInitialize];

        [[NSNotificationCenter defaultCenter] addObserverForName: @"AdMob_Consent"
                                                          object: nil
                                                           queue: [NSOperationQueue mainQueue]
                                                      usingBlock: ^(NSNotification *notification) {
                                                          NSLog(@"Setting UnityAds user consent as: %@", notification.userInfo[@"consent"]);

                                                          UADSMetaData *gdprConsentMetaData = [[UADSMetaData alloc] init];
                                                          [gdprConsentMetaData set: @"gdpr.consent" value: [notification.userInfo[@"consent"] isEqual: @"YES"] ? @YES : @NO];
                                                          [gdprConsentMetaData commit];
                                                      }];

    }

@end
