//
//  GADMAdapterInMobi.h
//
//  Copyright (c) 2015 InMobi. All rights reserved.
//

#import "GADMAdNetworkAdapterProtocol.h"
#import "GADMAdNetworkConnectorProtocol.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "GADMRewardBasedVideoAdNetworkConnectorProtocol.h"
#import "IMBanner.h"
#import "IMBannerDelegate.h"
#import "IMInterstitial.h"
#import "IMInterstitialDelegate.h"
#import "IMRequestStatus.h"
#import "sdaGADMRewardBasedVideoAdNetworkAdapterProtocol.h"

@interface GADMAdapterInMobi : NSObject <GADMAdNetworkAdapter,
GADMRewardBasedVideoAdNetworkAdapter, IMBannerDelegate, IMInterstitialDelegate> {
}

@property(nonatomic, retain) IMBanner *adView;
@property(nonatomic, retain) IMInterstitial *interstitial;
@property(nonatomic, retain) IMInterstitial *adRewarded;
@property(nonatomic, readonly) long long placementId;
@property(nonatomic, assign) id<GADMAdNetworkConnector> connector;
@property(nonatomic, assign) id<GADMRewardBasedVideoAdNetworkConnector> rewardedConnector;
@end
