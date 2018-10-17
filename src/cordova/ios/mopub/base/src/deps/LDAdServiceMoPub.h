#import "LDAdService.h"

@interface LDMoPubSettings : NSObject <LDAdServiceSettings>
/**AdUnits**/
    @property(nonatomic, strong) NSString *appId;
    @property(nonatomic, strong) NSString *banner;
    @property(nonatomic, strong) NSString *bannerIpad;
    @property(nonatomic, strong) NSString *interstitial;
    @property(nonatomic, strong) NSString *interstitialIpad;
    @property(nonatomic, strong) NSString *rewardedVideo;
    @property(nonatomic, strong) NSString *rewardedVideoIpad;
    @property(nonatomic, assign) BOOL *personalizedAdsConsent;

@end

@interface LDAdServiceMoPub : LDAdService
    @property(nonatomic, strong) LDMoPubSettings *settings;

    - (instancetype)init;

@end

@interface LDMoPubRewardedVideoReward : NSObject <LDRewardedVideoRewardProtocol>
    @property(nonatomic, strong) NSString *currencyType;
    @property(nonatomic, strong) NSNumber *amount;
    @property(nonatomic, strong) NSString *itmKey;
@end
