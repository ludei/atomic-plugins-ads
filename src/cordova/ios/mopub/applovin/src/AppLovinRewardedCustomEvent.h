//
//  AppLovinRewardedCustomEvent.h
//  MoPub Rewarded Adapter
//
//  Created on 10/14/15.
//  Copyright © 2015 AppLovin. All rights reserved.
//

#import <MoPub/MPRewardedVideoCustomEvent.h>
#import <AppLovin/ALAdLoadDelegate.h>
#import <AppLovin/ALAdDisplayDelegate.h>
#import <AppLovin/ALAdRewardDelegate.h>
#import <AppLovin/ALAdVideoPlaybackDelegate.h>

@interface AppLovinRewardedCustomEvent
    : MPRewardedVideoCustomEvent <ALAdLoadDelegate, ALAdDisplayDelegate,
                                  ALAdRewardDelegate, ALAdVideoPlaybackDelegate>

@end
