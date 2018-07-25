#import "LDAdBanner.h"
#import "LDAdInterstitial.h"
#import "LDAdRewardedVideo.h"

/**
 *  Ad Service Configuration (adUnits)
 */
@protocol LDAdServiceSettings<NSObject>

/**
 *  App adUnit
 */
@property (nonatomic, strong) NSString * appId;

/**
 *  Banner adUnit
 */
@property (nonatomic, strong) NSString * banner;

/**
 *  Banner adUnit for iPad (optional).
 *  If it is not specified, the banner adUnit will be used.
 */
@property (nonatomic, strong) NSString * bannerIpad;

/**
 *  Interstitial adUnit.
 */
@property (nonatomic, strong) NSString * interstitial;

/**
 *  Interstitial adUnit for iPad (optional).
 *  If it is not specified, the interstitial adUnit will be used.
 */
@property (nonatomic, strong) NSString * interstitialIpad;

/**
 *  Reward video adUnit.
 */
@property (nonatomic, strong) NSString * rewardedVideo;

/**
 *  Reward video adUnit for iPad (optional).
 *  If it is not specified, the reward video adUnit will be used.
 */
@property (nonatomic, strong) NSString * rewardedVideoIpad;

/**
 *  Value to store if the user has given consent for personalized ads.
 */
@property (nonatomic, assign) BOOL * personalizedAdsConsent;
@end

/**
 *  Ad Service Protocol
 */
@protocol LDAdServiceProtocol
@property (nonatomic, strong) NSObject<LDAdServiceSettings> * settings;

/**
 *  Create AdBanner with default size and adUnit (taken from settings).
 *
 *  @return The created banner.
 */
-(LDAdBanner *) createBanner;

/**
 *  Create AdBanner with custom adUnit and size
 *
 *  @param adUnit The adUnit.
 *  @param size   The size of the ad.
 *
 *  @return The custom ad.
 */
-(LDAdBanner *) createBanner: (NSString *) adUnit size:(LDAdBannerSize) size;

/**
 *  Create AdInterstitial with default adUnit.
 *
 *  @return The interstitial.
 */
-(LDAdInterstitial *) createInterstitial;

/**
 *  Create AdInterstitial with specific adUnit.
 *
 *  @param adUnit The adUnit.
 *
 *  @return The interstitial.
 */
-(LDAdInterstitial *) createInterstitial:(NSString *) adUnit;

/**
 *  Create a video only interstitial with specific adUnit.
 *  This method fallbacks to the default createInterstitial when the network doesn't support video only interstitial from client API.
 *
 *  @param adUnit The adUnit.
 *
 *  @return The interstitial.
 */
-(LDAdInterstitial *) createVideoInterstitial:(NSString *) adUnit;

/**
 *  Create a Rewarded video interstitial with default adUnit.
 *
 *  @return The interstitial.
 */
-(LDAdRewardedVideo *) createRewardedVideo;

/**
 *  Create a Rewarded video interstitial with specific adUnit.
 *
 *  @param adUnit The adUnit.
 *
 *  @return The interstitial.
 */
-(LDAdRewardedVideo *) createRewardedVideo:(NSString *) adUnit;

@end

typedef NSObject<LDAdServiceProtocol> LDAdService;


