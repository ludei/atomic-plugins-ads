//
//  AppLovinCustomEventInterstitialEvent.h
//
//
//  Created by Thomas So on 5/20/17.
//
//

@import GoogleMobileAds;

// Please note: We have renamed this class from "AppLovinCustomEventInter" to "AppLovinCustomEventInterstitial", please make sure you have the appropriate class name in your GADs account
@interface AppLovinCustomEventInterstitial : NSObject <GADCustomEventInterstitial>

@end

// AppLovinCustomEventInter is deprecated but kept here for backwards-compatibility purposes.
@interface AppLovinCustomEventInter : AppLovinCustomEventInterstitial
@end
