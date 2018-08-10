#import <Foundation/Foundation.h>

#import <GoogleMobileAds/Mediation/GADMRewardBasedVideoAdNetworkAdapterProtocol.h>

@interface GADMAdapterAppLovinRewardBasedVideoAd : NSObject <GADMRewardBasedVideoAdNetworkAdapter>

@end

@interface GADMExtrasAppLovin : NSObject <GADAdNetworkExtras>
    @property(nonatomic, assign) NSUInteger requestNumber;
@end
