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
    settings.banner = @"ca-app-pub-2059040695281139/6478020007";
    settings.interstitial = @"ca-app-pub-2059040695281139/4442883605";
    return admob;
}

@end