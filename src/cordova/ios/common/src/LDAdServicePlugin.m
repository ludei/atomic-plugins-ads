#import "LDAdServicePlugin.h"


@implementation LDAdBannerData
-(instancetype) initWithBanner:(LDAdBanner *) banner
{
    if (self = [super init]) {
        _banner = banner;
    }
    return self;
}
@end


static inline NSString * GET_ID(CDVInvokedUrlCommand * command)
{
    return ((NSNumber*)[command argumentAtIndex:0 withDefault:[NSNumber numberWithInteger:0] andClass:[NSNumber class]]).stringValue;
}

#pragma mark LDAdServicePlugin Implementation

@implementation LDAdServicePlugin
{
    NSMutableDictionary * _banners;
    NSMutableDictionary * _interstitials;
    NSMutableDictionary * _rewardedVideos;
    NSString * _bannerListenerId;
    NSString * _interstitialListenerId;
    NSString * _rewardedVideoListenerId;
}

- (void)pluginInitialize
{
    _banners = [NSMutableDictionary dictionary];
    _interstitials = [NSMutableDictionary dictionary];
    _rewardedVideos = [NSMutableDictionary dictionary];
}

- (BOOL)shouldAllowRequestForURL:(NSURL *)url
{
    return YES;
}

-(void) configure:(CDVInvokedUrlCommand*) command
{
    NSDictionary * data = [command argumentAtIndex:0 withDefault:@{} andClass:[NSDictionary class]];

    _service.settings.appId = [data objectForKey:@"appId"] ?: _service.settings.appId;
    _service.settings.banner = [data objectForKey:@"banner"] ?: _service.settings.banner;
    _service.settings.bannerIpad = [data objectForKey:@"bannerIpad"] ?: _service.settings.bannerIpad;
    _service.settings.interstitial = [data objectForKey:@"interstitial"] ?: _service.settings.interstitial;
    _service.settings.interstitialIpad = [data objectForKey:@"interstitialIpad"] ?: _service.settings.interstitialIpad;
    _service.settings.rewardedVideo = [data objectForKey:@"rewardedVideo"] ?: _service.settings.rewardedVideo;
    _service.settings.rewardedVideoIpad = [data objectForKey:@"rewardedVideoIpad"] ?: _service.settings.rewardedVideoIpad;
    _service.settings.personalizedAdsConsent = [[data objectForKey:@"personalizedAdsConsent"] boolValue] ?: _service.settings.personalizedAdsConsent;
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
}

-(void) setBannerListener:(CDVInvokedUrlCommand*) command
{
    _bannerListenerId = command.callbackId;
}

-(void) setInterstitialListener:(CDVInvokedUrlCommand*) command
{
    _interstitialListenerId = command.callbackId;
}

-(void) setRewardedVideoListener:(CDVInvokedUrlCommand*) command
{
    _rewardedVideoListenerId = command.callbackId;
}

-(void) createBanner: (CDVInvokedUrlCommand*)command
{
    NSString * bannerId = GET_ID(command);
    NSString * adUnit = [command argumentAtIndex:1 withDefault:nil andClass:[NSString class]];
    LDAdBannerSize size = LD_SMART_SIZE;
    NSString * strSize = [command argumentAtIndex:2 withDefault:nil andClass:[NSString class]];
    if (strSize) {
        if ([strSize isEqualToString:@"BANNER"]) {
            size = LD_BANNER_SIZE;
        }
        else if ([strSize isEqualToString:@"MEDIUM_RECT"]) {
            size = LD_MEDIUM_RECT_SIZE;
        }
        else if ([strSize isEqualToString:@"LEADERBOARD"]) {
            size = LD_LEADERBOARD_SIZE;
        }
    }

    LDAdBanner * banner = [_service createBanner:adUnit size:size];
    banner.delegate = self;
    LDAdBannerData * data = [[LDAdBannerData alloc] initWithBanner:banner];
    [_banners setObject:data forKey:bannerId];
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
}

-(void) createInterstitial: (CDVInvokedUrlCommand*)command
{
    NSString * interstitialId = GET_ID(command);
    NSString * adUnit = [command argumentAtIndex:1 withDefault:nil andClass:[NSString class]];
    LDAdInterstitial * interstitial = [_service createInterstitial:adUnit];
    interstitial.delegate = self;
    [_interstitials setObject:interstitial forKey:interstitialId];
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
}

-(void) createRewardedVideo: (CDVInvokedUrlCommand*)command
{
    NSString * rewardedVideoId = GET_ID(command);
    NSString * adUnit = [command argumentAtIndex:1 withDefault:nil andClass:[NSString class]];
    LDAdRewardedVideo * rewardedVideo = [_service createRewardedVideo:adUnit];
    rewardedVideo.delegate = self;
    [_rewardedVideos setObject:rewardedVideo forKey:rewardedVideoId];
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
}

-(void) releaseBanner: (CDVInvokedUrlCommand *) command
{
    NSString * bannerId = GET_ID(command);
    LDAdBannerData * data = [_banners objectForKey:bannerId];
    if (data) {
        data.banner.delegate = nil;
        [_banners removeObjectForKey:bannerId];
    }
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
}

-(void) releaseInterstitial: (CDVInvokedUrlCommand *) command
{
    NSString * interstitialId = GET_ID(command);
    LDAdBanner * interstitial = [_interstitials objectForKey:interstitialId];
    if (interstitial) {
        interstitial.delegate = nil;
        [_interstitials removeObjectForKey:interstitialId];
    }
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
}

-(void) releaseRewardedVideo: (CDVInvokedUrlCommand *) command
{
    NSString * rewardedVideoId = GET_ID(command);
    LDAdBanner * rewardedVideo = [_rewardedVideos objectForKey:rewardedVideoId];
    if (rewardedVideo) {
        rewardedVideo.delegate = nil;
        [_rewardedVideos removeObjectForKey:rewardedVideoId];
    }
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
}

-(void) showBanner: (CDVInvokedUrlCommand*)command
{
    LDAdBannerData * data = [_banners objectForKey:GET_ID(command)];
    if (!data.banner.view.superview) {
        [self.viewController.view addSubview:data.banner.view];
    }
    data.banner.view.hidden = NO;
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
    [self layoutBanner:data];
}

-(void) hideBanner: (CDVInvokedUrlCommand*)command
{
    LDAdBannerData * data = [_banners objectForKey:GET_ID(command)];
    data.banner.view.hidden = YES;
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
}

-(void) setBannerPosition: (CDVInvokedUrlCommand*)command
{
    LDAdBannerData * data = [_banners objectForKey:GET_ID(command)];
    NSNumber * x = [command argumentAtIndex:1 withDefault:[NSNumber numberWithFloat:0] andClass:NSNumber.class];
    NSNumber * y = [command argumentAtIndex:2 withDefault:[NSNumber numberWithFloat:0] andClass:NSNumber.class];
    data.customPosition = CGPointMake(x.floatValue, y.floatValue);
    [self layoutBanner:data];
}

-(void) setBannerLayout: (CDVInvokedUrlCommand *) command
{
    LDAdBannerData * data = [_banners objectForKey:GET_ID(command)];
    NSString * value = [command argumentAtIndex:1 withDefault:@"" andClass:NSString.class];
    if ([value isEqualToString:@"TOP_CENTER"]) {
        data.layout = LDBannerLayoutTopCenter;
    }
    else if ([value isEqualToString:@"BOTTOM_CENTER"]) {
        data.layout = LDBannerLayoutBottomCenter;
    }
    else {
        data.layout = LDBannerLayoutCustom;
    }
    [self layoutBanner:data];
}

-(void) loadBanner: (CDVInvokedUrlCommand*)command
{
    LDAdBannerData * data = [_banners objectForKey:GET_ID(command)];
    [data.banner loadAd];
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
}

-(void) showInterstitial: (CDVInvokedUrlCommand*) command
{
    LDAdInterstitial * interstitial = [_interstitials objectForKey:GET_ID(command)];
    [interstitial showFromViewController:self.viewController animated:YES];
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
}

-(void) loadInterstitial: (CDVInvokedUrlCommand*) command
{
    LDAdInterstitial * interstitial = [_interstitials objectForKey:GET_ID(command)];
    [interstitial loadAd];
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
}

-(void) showRewardedVideo: (CDVInvokedUrlCommand*) command
{
    LDAdRewardedVideo * rewardedVideo = [_rewardedVideos objectForKey:GET_ID(command)];
    [rewardedVideo showFromViewController:self.viewController animated:YES];
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
}

-(void) loadRewardedVideo: (CDVInvokedUrlCommand*) command
{
    LDAdRewardedVideo * rewardedVideo = [_rewardedVideos objectForKey:GET_ID(command)];
    [rewardedVideo loadAd];
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
}

#pragma mark LDAdBannerDelegate

-(UIViewController *) viewControllerForPresentingModalView
{
    return self.viewController;
}

-(void) adBannerDidLoad:(LDAdBanner *) banner
{
    NSString * bannerId = [self findBannerId:banner];
    LDAdBannerData * data = [_banners objectForKey: bannerId];
    [self layoutBanner:data];
    CGSize size = data.banner.adSize;
    [self callListener:@[@"load", bannerId, @(size.width), @(size.height)] callbackId:_bannerListenerId];
}

-(void) adBannerDidFailLoad:(LDAdBanner *) banner withError:(NSError *) error
{
    [self callListener:@[@"fail", [self findBannerId:banner], [self errorToDic:error]] callbackId:_bannerListenerId];
}

- (void) adBannerWillPresentModal:(LDAdBanner *)banner
{
    [self callListener:@[@"show", [self findBannerId:banner]] callbackId:_bannerListenerId];
}

- (void)adBannerDidDismissModal:(LDAdBanner *)banner
{
    [self callListener:@[@"dismiss", [self findBannerId:banner]] callbackId:_bannerListenerId];
}

#pragma mark LDAdInterstitialDelegate
-(void) adInterstitialDidLoad:(LDAdInterstitial *) interstitial
{
    [self callListener:@[@"load", [self findInterstitialId:interstitial]] callbackId:_interstitialListenerId];
}

-(void) adInterstitialDidFailLoad:(LDAdInterstitial *) interstitial withError:(NSError *) error
{
    [self callListener:@[@"fail", [self findInterstitialId:interstitial], [self errorToDic:error]] callbackId:_interstitialListenerId];
}

-(void)adInterstitialWillAppear:(LDAdInterstitial *)interstitial
{
    [self callListener:@[@"show", [self findInterstitialId:interstitial]] callbackId:_bannerListenerId];
}

-(void)adInterstitialWillDisappear:(LDAdInterstitial *)interstitial
{
    [self callListener:@[@"dismiss", [self findInterstitialId:interstitial]] callbackId:_bannerListenerId];
}

#pragma mark LDAdRewardedVideoDelegate
-(void) adRewardedVideoDidLoad:(LDAdRewardedVideo *) rewardedVideo
{
    [self callListener:@[@"load", [self findRewardedVideoId:rewardedVideo]] callbackId:_rewardedVideoListenerId];
}

-(void) adRewardedVideoDidFailLoad:(LDAdRewardedVideo *) rewardedVideo withError:(NSError *) error
{
    [self callListener:@[@"fail", [self findRewardedVideoId:rewardedVideo], [self errorToDic:error]] callbackId:_rewardedVideoListenerId];
}

-(void)adRewardedVideoWillAppear:(LDAdRewardedVideo *)rewardedVideo
{
    [self callListener:@[@"show", [self findRewardedVideoId:rewardedVideo]] callbackId:_bannerListenerId];
}

-(void)adRewardedVideoWillDisappear:(LDAdRewardedVideo *)rewardedVideo
{
    [self callListener:@[@"dismiss", [self findRewardedVideoId:rewardedVideo]] callbackId:_bannerListenerId];
}

- (void)adRewardedVideoDidCompleteRewardedVideo:(LDAdRewardedVideo *)rewardedVideo withReward:(LDRewardedVideoReward*) reward andError:(NSError *) error
{

    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:reward && reward.amount ? reward.amount : [NSNumber numberWithInteger:0] forKey:@"amount"];
    [dic setObject:reward && reward.currencyType ? reward.currencyType : @"" forKey:@"currencyType"];
    [dic setObject:reward && reward.itmKey ? reward.itmKey : @"" forKey:@"itmKey"];

    if (error) {
        [self callListener:@[@"reward", [self findRewardedVideoId:rewardedVideo], dic, [self errorToDic:error]] callbackId:_rewardedVideoListenerId];
    }
    else {
        [self callListener:@[@"reward", [self findRewardedVideoId:rewardedVideo], dic] callbackId:_rewardedVideoListenerId];
    }

}

#pragma mark Utils


-(void) callListener:(NSArray *) args callbackId:(NSString *) callbackId
{
    CDVPluginResult * result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:args];
    [result setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult: result callbackId:callbackId];
}

-(NSString *) findBannerId:(LDAdBanner *) banner {
    for (NSString * key in _banners.keyEnumerator) {
        LDAdBannerData * data = [_banners objectForKey:key];
        if (data.banner == banner) {
            return key;
        }
    }
    return @"";
}

-(NSString *) findInterstitialId:(LDAdInterstitial *) interstitial {
    for (NSString * key in _interstitials.keyEnumerator) {
        if ([_interstitials objectForKey:key] == interstitial) {
            return key;
        }
    }
    return @"";
}

-(NSString *) findRewardedVideoId:(LDAdRewardedVideo *) rewardedVideo {
    for (NSString * key in _rewardedVideos.keyEnumerator) {
        if ([_rewardedVideos objectForKey:key] == rewardedVideo) {
            return key;
        }
    }
    return @"";
}

-(NSDictionary *) errorToDic:(NSError * ) error
{
    return @{@"code":[NSNumber numberWithInteger:error.code], @"message":error.localizedDescription?:@"Unkown error"};
}

-(void) layoutBanner:(LDAdBannerData *) data
{
    if (!data.banner.view.superview) {
        return;
    }
    CGSize size = data.banner.adSize;
    CGSize container = self.viewController.view.bounds.size;

    switch (data.layout) {
        default:
        case LDBannerLayoutTopCenter: data.banner.view.center = CGPointMake(container.width * 0.5, size.height * 0.5);
            break;
        case LDBannerLayoutBottomCenter: data.banner.view.center = CGPointMake(container.width * 0.5, container.height - size.height * 0.5);
            break;
        case LDBannerLayoutCustom: data.banner.view.center = CGPointMake(data.customPosition.x + size.width * 0.5, data.customPosition.y + size.height * 0.5);
    }
}

@end
