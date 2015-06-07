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
    [chartboost configureAppId:@"5572fa0743150f512736e7fe" appSignature:@"2b0beae9fd748833191c1080a2897f1877d9705c"];
    return chartboost;
}

@end