//
//
// Copyright (c) 2016 Fyber. All rights reserved.
//
//

#import <Foundation/Foundation.h>

/**
 *  An object used to configure products
 */
@interface FYBRequestParameters : NSObject

/**
 *  The placement ID of your creative
 */
@property (nonatomic, copy) NSString *placementId;

/**
 *  The ID of the currency
 *
 *  @discussion This property is used when requesting the user's virtual currencies either through the -[FYBVirtualCurrencyClient requestDeltaOfCoinsWithParameters:]
 *              or -[FYBRewardedVideoController presentRewardedVideoFromViewController:] when the virtualCurrencyClientDelegate property is set
 *
 *  @see FYBVirtualCurrencyClient
 *  @see FYBRewardedVideoController
 */
@property (nonatomic, copy) NSString *currencyId;

/**
 *  A dictionary of custom parameters are added to the request when requesting Interstitials or Rewardeed Video or when showing the Offer Wall
 *
 *  @discussion This property is readonly
 *              Use -[FYBRequestParameters addCustomParameterWithKey:value:] and -[FYBRequestParameters addCustomParameters:] to add custom parameters
 */
@property (nonatomic, strong, readonly) NSDictionary *customParameters;

/**
 *  Initializer
 *
 *  @param placementId A placement ID
 *  @param currencyId  A currency ID
 *
 *  @return An FYBRequestParameters object configured with a placement ID and a currency ID
 */
- (instancetype)initWithPlacementId:(NSString *)placementId currencyId:(NSString *)currencyId;

/**
 *  Class-level initializer
 *
 *  @param placementId A placement ID
 *  @param currencyId  A currency ID
 *
 *  @return An FYBRequestParameters object configured with a placement ID and a currency ID
 */
+ (instancetype)parametersWithPlacementId:(NSString *)placementId currencyId:(NSString *)currencyId;

/**
 *  Add a custom parameter to the request. Example: &parameter_key=parameter_value
 *
 *  @param key   The parameter's key
 *  @param value The parameter's value
 */
- (void)addCustomParameterWithKey:(NSString *)key value:(NSString *)value;

/**
 *  Add custom parameters to the request. Example: &parameter_key=parameter_value
 *
 *  @param customParameters A dictionary containing the parameters
 */
- (void)addCustomParameters:(NSDictionary *)customParameters;

/**
 *  Clear all the previously added custom parameters
 */
- (void)clearCustomParameters;

/**
 *  Remove a custom parameter based on its key
 *
 *  @param key The key of the parameter you want to remove
 */
- (void)removeCustomParameterWithKey:(NSString *)key;

@end
