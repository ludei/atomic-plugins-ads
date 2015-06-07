#import "LDAdServiceChartboost.h"


#pragma mark AdMob Interstitial implementation
@interface LDChartboostInterstitial : LDAdInterstitial

@property (nonatomic, weak) id<LDAdInterstitialDelegate> delegate;
@property (nonatomic, assign) BOOL isReward;
@property (nonatomic, strong) NSString * location;
@end

@implementation LDChartboostInterstitial

-(instancetype) initWithReward:(BOOL) reward location:(NSString *) location;
{
    if (self = [super init]) {
        _isReward = reward;
        _location = location ?: CBLocationLevelComplete;
    }
    return self;
}

- (void)loadAd
{
    if (_isReward) {
        [Chartboost cacheRewardedVideo:_location];
    }
    else {
        [Chartboost cacheInterstitial:_location];
    }
}

- (void)showFromViewController:(UIViewController *)controller animated:(BOOL) animated
{
    if (_isReward) {
        [Chartboost showRewardedVideo:_location];
    }
    else {
        [Chartboost showInterstitial:_location];
    }
}

- (void)dismissAnimated:(BOOL) animated
{
    //TODO
}

@end



#pragma mark Chartboost AdService implementation

@implementation LDChartboostSettings

@end

@implementation LDAdServiceChartboost
{
    LDChartboostSettings * _settings;
    LDChartboostInterstitial * _currentVideo;
    LDChartboostInterstitial * _currentReward;
}

-(instancetype) init
{
    if (self = [super init]) {
        _settings = [[LDChartboostSettings alloc] init];
    }
    return self;
}

-(void) configureAppId:(NSString*)appId appSignature:(NSString*)appSignature
{
    [Chartboost startWithAppId:appId appSignature:appSignature delegate:self];
    [Chartboost setAutoCacheAds:YES];
}


-(LDAdBanner *) createBanner {
    return nil;
}

-(LDAdBanner *) createBanner: (NSString *) banner size:(LDAdBannerSize) size
{
    return nil;
}


-(LDAdInterstitial *) createInterstitial {
    
    return [self createInterstitial:nil];
}

-(LDAdInterstitial *) createInterstitial:(NSString *) adunit
{
    LDChartboostInterstitial * result = [[LDChartboostInterstitial alloc] initWithReward:NO location:adunit];
    _currentVideo = result;
    return result;
}

-(LDAdInterstitial *) createRewardedVideo:(NSString *) adunit
{
    LDChartboostInterstitial * result = [[LDChartboostInterstitial alloc] initWithReward:YES location:adunit];
    _currentReward = result;
    return result;
}


#pragma mark ChartboostDelegate

- (void)didDisplayRewardedVideo:(CBLocation)location
{
    if (_currentReward && _currentReward.delegate && [_currentReward.delegate respondsToSelector:@selector(adInterstitialWillAppear:)]) {
        [_currentReward.delegate adInterstitialWillAppear:_currentReward];
    }
}

- (void)didCacheRewardedVideo:(CBLocation)location
{
    if (_currentReward && _currentReward.delegate && [_currentReward.delegate respondsToSelector:@selector(adInterstitialDidLoad:)]) {
        [_currentReward.delegate adInterstitialDidLoad:_currentReward];
    }
}

- (void)didFailToLoadRewardedVideo:(CBLocation)location withError:(CBLoadError)error
{
    if (_currentReward && _currentReward.delegate && [_currentReward.delegate respondsToSelector:@selector(adInterstitialDidFailLoad:withError:)]) {
        [_currentReward.delegate adInterstitialDidFailLoad:_currentReward withError:[[NSError alloc] initWithDomain:@"Chartboost" code:error userInfo:nil]];
    }
}

- (void)didDismissRewardedVideo:(CBLocation)location
{
    if (_currentReward && _currentReward.delegate && [_currentReward.delegate respondsToSelector:@selector(adInterstitialDidLoad:)]) {
        [_currentReward.delegate adInterstitialDidLoad:_currentReward];
    }
}

- (void)didCompleteRewardedVideo:(CBLocation)location withReward:(int)reward;
{
    if (_currentReward && _currentReward.delegate && [_currentReward.delegate respondsToSelector:@selector(adInterstitialDidCompleteRewardedVideo:withReward:)]) {
        [_currentReward.delegate adInterstitialDidCompleteRewardedVideo:_currentReward withReward:reward];
    }
}

- (void)didDisplayInterstitial:(CBLocation)location
{
    if (_currentVideo && _currentVideo.delegate && [_currentVideo.delegate respondsToSelector:@selector(adInterstitialWillAppear:)]) {
        [_currentVideo.delegate adInterstitialWillAppear:_currentVideo];
    }
}

- (void)didCacheInterstitial:(CBLocation)location
{
    if (_currentVideo && _currentVideo.delegate && [_currentVideo.delegate respondsToSelector:@selector(adInterstitialDidLoad:)]) {
        [_currentVideo.delegate adInterstitialDidLoad:_currentVideo];
    }
}

- (void)didFailToLoadInterstitial:(CBLocation)location withError:(CBLoadError)error
{
    if (_currentVideo && _currentVideo.delegate && [_currentVideo.delegate respondsToSelector:@selector(adInterstitialDidFailLoad:withError:)]) {
        [_currentVideo.delegate adInterstitialDidFailLoad:_currentVideo withError:[[NSError alloc] initWithDomain:@"Chartboost" code:error userInfo:nil]];
    }
}

- (void)didDismissInterstitial:(CBLocation)location
{
    if (_currentVideo && _currentVideo.delegate && [_currentVideo.delegate respondsToSelector:@selector(adInterstitialDidLoad:)]) {
        [_currentVideo.delegate adInterstitialDidLoad:_currentVideo];
    }
}


@end
