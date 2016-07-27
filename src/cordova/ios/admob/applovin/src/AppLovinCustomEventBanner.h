//
//  AppLovinCustomEventBanner.h
//  AppLovin AdMob Mediation
//
//  Created by David Anderson on 11/29/12.
//  Updated by Matt Szaro on 7/10/13.
//  Copyright (c) 2013 AppLovin. All rights reserved.
//

#import <GoogleMobileAds/GoogleMobileAds.h>

#import <UIKit/UIKit.h>
#import <AppLovin/ALAdService.h>
#import <AppLovin/ALAdView.h>

@interface AppLovinCustomEventBanner : NSObject <GADCustomEventBanner, ALAdLoadDelegate, ALAdDisplayDelegate>
@property (strong, atomic) ALAdView* adView;
@end