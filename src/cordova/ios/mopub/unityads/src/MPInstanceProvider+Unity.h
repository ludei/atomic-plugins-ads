//
//  MPInstanceProvider+Unity.h
//  MoPubSDK
//
//  Copyright (c) 2015 MoPub. All rights reserved.
//

#import <MoPub/MPInstanceProvider.h>

@class MPUnityRouter;

@interface MPInstanceProvider (Unity)

    - (MPUnityRouter *)sharedMPUnityRouter;

@end
