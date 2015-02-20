#import "LDAdService.h"


@interface LDAdMobSettings : NSObject<LDAdServiceSettings>
/**AdUnits**/
@property (nonatomic, strong) NSString * banner;
@property (nonatomic, strong) NSString * bannerIpad;
@property (nonatomic, strong) NSString * interstitial;
@property (nonatomic, strong) NSString * interstitialIpad;

@end

@interface LDAdServiceAdMob : LDAdService
@property (nonatomic, strong) LDAdMobSettings * settings;

-(instancetype) init;

@end
