//
//  TestService.m
//  AdTest
//
//  Created by Imanol Fernandez Gorostizag on 2/1/15.
//  Copyright (c) 2015 Ludei. All rights reserved.
//

#import "TestService.h"
#import "LDAdServiceMoPub.h"

@implementation TestService

+(LDAdService*) create
{
    LDAdServiceMoPub * mopub = [[LDAdServiceMoPub alloc] init];
    
    LDMoPubSettings * settings = mopub.settings;
    settings.banner = @"agltb3B1Yi1pbmNyDQsSBFNpdGUY5dDoEww";
    settings.bannerIpad = @"agltb3B1Yi1pbmNyDQsSBFNpdGUYk8vlEww";
    settings.interstitial = @"agltb3B1Yi1pbmNyDQsSBFNpdGUYjf30Eww";
    settings.interstitialIpad = @"0ddb0da860b64afca710c881fb91fde0";
    return mopub;
}

@end
