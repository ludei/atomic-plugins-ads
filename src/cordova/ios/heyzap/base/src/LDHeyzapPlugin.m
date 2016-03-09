#import "LDHeyzapPlugin.h"
#import "LDAdServiceHeyzap.h"

@implementation LDHeyzapPlugin
{
    LDAdServiceHeyzap * heyzap;
}

- (void)pluginInitialize
{
    [super pluginInitialize];
    
    heyzap = [[LDAdServiceHeyzap alloc] init];
    self.service = heyzap;
}

-(void) configure:(CDVInvokedUrlCommand*) command
{
    NSDictionary * data = [command argumentAtIndex:0 withDefault:@{} andClass:[NSDictionary class]];
    NSString * publisherId = [data objectForKey:@"publisherId"] ?: @"";
    [heyzap configurePublisherId:publisherId];
    
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
}

-(void) showDebug:(CDVInvokedUrlCommand*) command
{
    [heyzap showDebug];
}

@end
