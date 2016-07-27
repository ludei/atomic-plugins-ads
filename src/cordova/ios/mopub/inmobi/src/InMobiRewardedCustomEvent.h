//
//  InMobiRewardedCustomEvent.h
//  InMobiMopubSampleApp
//
//  Created by Niranjan Agrawal on 28/10/15.
//
//

#ifndef InMobiRewardedCustomEvent_h
#define InMobiRewardedCustomEvent_h


#endif /* InMobiRewardedCustomEvent_h */

#import <MoPub/MPRewardedVideoCustomEvent.h>

#import <InMobi/IMInterstitial.h>
#import <InMobi/IMInterstitialDelegate.h>

@interface InMobiRewardedCustomEvent : MPRewardedVideoCustomEvent<IMInterstitialDelegate>
@property (nonatomic, retain) IMInterstitial *inMobiInterstitial;

@end