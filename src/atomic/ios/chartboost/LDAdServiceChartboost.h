#import "LDAdService.h"
#import <Chartboost/Chartboost.h>


@interface LDChartboostSettings : NSObject<LDAdServiceSettings>
//Not used settings, just to complete the protocol
@property (nonatomic, strong) NSString * banner;
@property (nonatomic, strong) NSString * bannerIpad;
@property (nonatomic, strong) NSString * interstitial;
@property (nonatomic, strong) NSString * interstitialIpad;

@end

@interface LDAdServiceChartboost : LDAdService<ChartboostDelegate>
@property (nonatomic, strong) LDChartboostSettings * settings;

-(instancetype) init;
-(void) configureAppId:(NSString*)appId appSignature:(NSString*)appSignature;

@end
