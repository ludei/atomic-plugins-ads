#import "LDChartboostPlugin.h"
#import "LDAdServiceChartboost.h"

@implementation LDChartboostPlugin

- (void)pluginInitialize
{
    [super pluginInitialize];
    
    LDAdServiceChartboost * charboost = [[LDAdServiceChartboost alloc] init];
    self.service = charboost;
}

-(void) configure:(CDVInvokedUrlCommand*) command
{
    NSDictionary * data = [command argumentAtIndex:0 withDefault:@{} andClass:[NSDictionary class]];
    
    LDAdServiceChartboost * chartboost = (LDAdServiceChartboost *) self.service;
    NSString * appId = [data objectForKey:@"appId"] ?: @"";
    NSString * appSignature = [data objectForKey:@"appSignature"] ?: @"";
    [chartboost configureAppId:appId appSignature:appSignature];
    
    if (!appId || !appSignature) {
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
    }
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
}

@end
