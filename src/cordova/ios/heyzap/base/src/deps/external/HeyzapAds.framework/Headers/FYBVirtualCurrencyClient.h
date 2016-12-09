//
//
// Copyright (c) 2016 Fyber. All rights reserved.
//
//

#import <Foundation/Foundation.h>

#import "FYBVirtualCurrencyClientDelegate.h"
#import "FYBRequestParameters.h"

@class FYBVirtualCurrencyClient;

/**
 *  Provides methods to request the user's Virtual Currency balance
 */
@interface FYBVirtualCurrencyClient : NSObject

/** @name Obtaining the last transaction ID */

/**
 *  Latest transaction ID for your user and app ID, as reported by the server. It is used to keep track of new transactions between invocations to requestDeltaOfCoins
 */
@property (nonatomic, copy, readonly) NSString *latestTransactionId;

/**
 *  The object that acts as the delegate of the virtual currency client
 *
 *  @discussion The delegate must adopt the FYBVirtualCurrencyClientDelegate protocol. The delegate is not retained
 */
@property (weak) id<FYBVirtualCurrencyClientDelegate> delegate;

/**
 *  Requests the amount of coins earned since the last time this method was invoked for the default currency
 */
- (void)requestDeltaOfCoins;

/**
 *  Same as requestDeltaOfCoins but accepts a FYBRequestParameters object as parameter. Through this object you can specify the currencyId that you want to request
 *
 *  @param parameters An FYBRequestParameters object
 *
 *  @see FYBRequestParameters
 */
- (void)requestDeltaOfCoinsWithParameters:(FYBRequestParameters *)parameters;

@end
