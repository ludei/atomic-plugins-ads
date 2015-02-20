//
//  TestServiceAdMob.h
//  AdTest
//
//  Created by Imanol Fernandez Gorostizag on 26/1/15.
//  Copyright (c) 2015 Ludei. All rights reserved.
//

#import "TestService.h"
#import "LDAdServiceAdMob.h"

@implementation TestService

+(LDAdService*) create
{
    LDAdServiceAdMob * admob = [[LDAdServiceAdMob alloc] init];
    
    LDAdMobSettings * settings = admob.settings;
    settings.banner = @"ca-app-pub-7686972479101507/8873903476";
    settings.interstitial = @"ca-app-pub-7686972479101507/8873903476";
    return admob;
}

@end