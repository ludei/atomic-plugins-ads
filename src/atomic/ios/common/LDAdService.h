#import "LDAdBanner.h"
#import "LDAdInterstitial.h"

/**
 *  Ad Service Configuration (adunits)
 */
@protocol LDAdServiceSettings<NSObject>

/**
 *  Banner adunit
 */
@property (nonatomic, strong) NSString * banner;

/**
 *  Banner adunit for iPad (optional).
 *  If it is not specified, the banner adunit will be used.
 */
@property (nonatomic, strong) NSString * bannerIpad;

/**
 *  Interstitial adunit.
 */
@property (nonatomic, strong) NSString * interstitial;

/**
 *  Interstitial adunit for iPad (optional).
 *  If it is not specified, the interstitial adunit will be used.
 */
@property (nonatomic, strong) NSString * interstitialIpad;
@end

/**
 *  Ad Service Protocol
 */
@protocol LDAdServiceProtocol
@property (nonatomic, strong) NSObject<LDAdServiceSettings> * settings;

/**
 *  Create AdBanner with default size and adunit (taken from settings).
 *
 *  @return The created banner.
 */
-(LDAdBanner *) createBanner;

/**
 *
 * @param adUnit Optional banner adunit, taken from settingsw if not specified
 */

/**
 *  Create AdBanner with custom adunit and size
 *
 *  @param adunit The adunit.
 *  @param size   The size of te ad.
 *
 *  @return The custom ad.
 */
-(LDAdBanner *) createBanner: (NSString *) adunit size:(LDAdBannerSize) size;

/**
 *  Create AdInterstitial with default adunit.
 *
 *  @return The interstitial.
 */
-(LDAdInterstitial *) createInterstitial;

/**
 *  Create AdInterstitial with specific adunit.
 *
 *  @param adunit The adunit.
 *
 *  @return The interstitial.
 */
-(LDAdInterstitial *) createInterstitial:(NSString *) adunit;

/**
 *  Create a Rewarded video interstitial with specific adunit.
 *
 *  @param adunit The adunit.
 *
 *  @return The interstitial.
 */
-(LDAdInterstitial *) createRewardedVideo:(NSString *) adunit;


@end

typedef NSObject<LDAdServiceProtocol> LDAdService;


