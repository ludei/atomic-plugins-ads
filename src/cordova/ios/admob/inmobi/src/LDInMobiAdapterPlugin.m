#import "LDInMobiAdapterPlugin.h"
#import <InMobiAdapter/InMobiAdapter.h>

@implementation LDInMobiAdapterPlugin

    - (void)pluginInitialize {
        [super pluginInitialize];

        [[NSNotificationCenter defaultCenter] addObserverForName: @"AdMob_Consent"
                                                          object: nil
                                                           queue: [NSOperationQueue mainQueue]
                                                      usingBlock: ^(NSNotification *notification) {
                                                          NSLog(@"Setting InMobi user consent as: %@", notification.userInfo[@"consent"]);

                                                          NSMutableDictionary *consentObject = [[NSMutableDictionary alloc] init];
                                                          [consentObject setObject: [notification.userInfo[@"consent"] isEqual: @"YES"] ? @"1" : @"0" forKey: @"gdpr"];
                                                          [consentObject setObject: [notification.userInfo[@"consent"] isEqual: @"YES"] ? @"true" : @"false" forKey: IM_GDPR_CONSENT_AVAILABLE];

                                                          [GADMInMobiConsent updateGDPRConsent: consentObject];
                                                      }];

    }

@end
