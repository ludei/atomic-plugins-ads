//  Created by Imanol Fernandez Gorostizag on 9/3/16.
//  Copyright © 2016 Ludei. All rights reserved.
//

#import "TestService.h"
#import "LDAdServiceHeyzap.h"

@implementation TestService

+(LDAdService*) create
{
    LDAdServiceHeyzap * heyzap = [[LDAdServiceHeyzap alloc] init];
    [heyzap configurePublisherId:@"719d975e5c491118535b3413a8b20d52"];
    return heyzap;
}

@end