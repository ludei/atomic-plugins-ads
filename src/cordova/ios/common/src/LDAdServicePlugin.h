//
//  LDInAppServicePlugin.h
//  HelloCordova
//
//  Created by Imanol Fernandez Gorostizag on 12/12/14.
//
//

#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>
#import "LDAdService.h"

@interface LDAdServicePlugin : CDVPlugin<LDAdBannerDelegate, LDAdInterstitialDelegate>
@property (nonatomic, strong) LDAdService * service;

-(void) configure:(CDVInvokedUrlCommand*) command;

@end


typedef NS_ENUM(NSInteger, LDAdBannerLayout) {
    LDBannerLayoutTopCenter = 0,
    LDBannerLayoutBottomCenter = 1,
    LDBannerLayoutCustom = 2,
};

@interface LDAdBannerData : NSObject
@property (nonatomic, strong) LDAdBanner * banner;
@property (nonatomic, assign) CGPoint customPosition;
@property (nonatomic, assign) LDAdBannerLayout layout;
@end