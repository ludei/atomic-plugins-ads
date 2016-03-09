#import "LDAdMobPlugin.h"
#import "LDAdServiceHeyzap.h"

@implementation LDHeyzapPlugin

- (void)pluginInitialize
{
    [super pluginInitialize];
    
    LDAdServiceHeyzap * heyzap = [[LDAdServiceHeyzap alloc] init];
    self.service = heyzap;
}

@end
