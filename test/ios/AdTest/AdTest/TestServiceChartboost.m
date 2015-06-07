//
//  TestServiceAdMob.h
//  AdTest
//
//  Created by Imanol Fernandez Gorostizag on 26/1/15.
//  Copyright (c) 2015 Ludei. All rights reserved.
//

#import "TestService.h"
#import "LDAdServiceChartboost.h"

@implementation TestService

+(LDAdService*) create
{
    LDAdServiceChartboost * chartboost = [[LDAdServiceChartboost alloc] init];
    [chartboost configureAppId:APP_ID appSignature:APP_SIGNATURE];
    return chartboost;
}

@end