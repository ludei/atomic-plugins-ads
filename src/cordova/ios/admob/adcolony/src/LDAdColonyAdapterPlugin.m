#import "LDAdColonyAdapterPlugin.h"
#import <AdColonyAdapter/AdColonyAdapter.h>

@implementation LDAdColonyAdapterPlugin

    - (void)pluginInitialize {
        [super pluginInitialize];

        NSLog(@"Setting AdColony listener for the AdMob consent");

        [[NSNotificationCenter defaultCenter] addObserverForName: @"AdMob_Consent"
                                                          object: nil
                                                           queue: [NSOperationQueue mainQueue]
                                                      usingBlock: ^(NSNotification *notification) {
                                                          NSLog(@"Setting AdColony user consent as: %@", notification.userInfo[@"consent"]);

                                                          GADRequest *request = [GADRequest request];
                                                          GADMAdapterAdColonyExtras *extras = [[GADMAdapterAdColonyExtras alloc] init];
                                                          extras.gdprRequired = [notification.userInfo[@"consent"] isEqual: @"YES"] ? YES : NO;
                                                          extras.gdprConsentString = [notification.userInfo[@"consent"] isEqual: @"YES"] ? @"1" : @"0";
                                                          [request registerAdNetworkExtras: extras];
                                                      }];

    }

@end
