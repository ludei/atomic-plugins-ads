#import <Foundation/Foundation.h>

#import <GoogleMobileAds/GADMRewardBasedVideoAdNetworkAdapterProtocol.h>

@interface GADMAdapterAppLovinRewardBasedVideoAd : NSObject<GADMRewardBasedVideoAdNetworkAdapter>

@end

@interface GADMExtrasAppLovin : NSObject<GADAdNetworkExtras>
@property(nonatomic, assign) NSUInteger requestNumber;
@end
