//
//
// Copyright (c) 2016 Fyber. All rights reserved.
//
//

#import <Foundation/Foundation.h>

/**
 *  Type of error returned by the Virtual Currency servers
 */
typedef NS_ENUM(NSInteger, FYBVirtualCurrencyErrorType) {
    //TODO: Remove when wrapper is deprecated
    /**
     *  No error
     */
    FYBVirtualCurrencyErrorTypeNoError,

    /**
     *  Error due to the internet connection
     */
    FYBVirtualCurrencyErrorTypeNoConnection,

    /**
     *  Invalid response received from the server
     */
    FYBVirtualCurrencyErrorTypeInvalidResponse,

    /**
     *  Invalid response signature received from the server
     */
    FYBVirtualCurrencyErrorTypeInvalidResponseSignature,

    /**
     *  Server returned an error
     */
    FYBVirtualCurrencyErrorTypeServer,

    /**
     *  Other type of error
     */
    FYBVirtualCurrencyErrorTypeOther
};
