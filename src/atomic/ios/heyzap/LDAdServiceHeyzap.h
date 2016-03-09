#import "LDAdService.h"


@interface LDHeyzapSettings : NSObject<LDAdServiceSettings>
//Not used settings, just to complete the protocol
@property (nonatomic, strong) NSString * banner;
@property (nonatomic, strong) NSString * bannerIpad;
@property (nonatomic, strong) NSString * interstitial;
@property (nonatomic, strong) NSString * interstitialIpad;

@end

@interface LDAdServiceHeyzap : LDAdService
@property (nonatomic, strong) LDHeyzapSettings * settings;

-(instancetype) init;
-(void) configurePublisherId:(NSString*)publisherId;
-(void) showDebug;

@end

@interface LDHeyzapRewardedVideoReward: NSObject<LDRewardedVideoRewardProtocol>
@property (nonatomic, strong) NSString *currencyType;
@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, strong) NSString *itemKey;
@end
