//
//
// Copyright (c) 2016 Fyber. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import "FYBVirtualCurrencyResponse.h"

@class FYBVirtualCurrencyClient;

/**
 *  Defines selectors that a delegate of FYBVirtualCurrencyClient can implement for notification of answers to requests and triggered errors
 */
@protocol FYBVirtualCurrencyClientDelegate<NSObject>

@optional

/**
 *  The Virtual Currency client received a delta of coins
 *
 *  @param client    The Virtual Currency client that received the delta of coins
 *  @param response  An instance of FYBVirtualCurrencyResponse
 *
 *  @see FYBVirtualCurrencyResponse
 */
- (void)virtualCurrencyClient:(FYBVirtualCurrencyClient *)client didReceiveResponse:(FYBVirtualCurrencyResponse *)response;

/**
 *  The Virtual Currency client failed to receive the delta of coins
 *
 *  @param client The Virtual Currency client that failed to receive the delta of coins
 *  @param error  The error that occurred during the request of the delta of coins
 */
- (void)virtualCurrencyClient:(FYBVirtualCurrencyClient *)client didFailWithError:(NSError *)error;

@end
