
#import "AdServiceIOS.h"
#include <map>

using namespace ludei::ads;


namespace {
    UIViewController * getViewController()
    {
        UIWindow * window = [UIApplication sharedApplication].keyWindow;
        UIViewController * mortimer = window.rootViewController;
        return mortimer;
    }
}


#pragma mark Listeners bridge

@interface LDAdBannerDelegateBridge : NSObject<LDAdBannerDelegate>
@property (nonatomic, assign) AdBannerIOS * banner;
@end

@implementation LDAdBannerDelegateBridge

-(UIViewController *) viewControllerForPresentingModalView
{
    return getViewController();
}

-(void) adBannerDidLoad:(LDAdBanner *) banner
{
    _banner->layoutBanner();
    if (_banner->listener) {
        _banner->listener->onLoaded(_banner);
    }
}

-(void) adBannerDidFailLoad:(LDAdBanner *) banner withError:(NSError *) error
{
    if (_banner->listener) {
        _banner->listener->onFailed(_banner, (int32_t)error.code, error ? error.localizedDescription.UTF8String : "");
    }
}

- (void) adBannerWillPresentModal:(LDAdBanner *)banner
{
    if (_banner->listener) {
        _banner->listener->onExpanded(_banner);
    }
}

- (void)adBannerDidDismissModal:(LDAdBanner *)banner
{
    if (_banner->listener) {
        _banner->listener->onCollapsed(_banner);
    }
}

@end

@interface LDAdInterstitialDelegateBridge : NSObject<LDAdInterstitialDelegate>
@property (nonatomic, assign) AdInterstitialIOS * interstitial;
@end

@implementation LDAdInterstitialDelegateBridge

-(void) adInterstitialDidLoad:(LDAdInterstitial *) interstitial
{
    if (_interstitial->listener) {
        _interstitial->listener->onLoaded(_interstitial);
    }
    
}
-(void) adInterstitialDidFailLoad:(LDAdInterstitial *) interstitial withError:(NSError *) error
{
    if (_interstitial->listener) {
        _interstitial->listener->onFailed(_interstitial, (int32_t)error.code, error ? error.localizedDescription.UTF8String : "");
    }
}
-(void)adInterstitialWillAppear:(LDAdInterstitial *)interstitial
{
    if (_interstitial->listener) {
        _interstitial->listener->onShown(_interstitial);
    }
}
-(void)adInterstitialWillDisappear:(LDAdInterstitial *)interstitial
{
    if (_interstitial->listener) {
        _interstitial->listener->onHidden(_interstitial);
    }
}

@end


#pragma mark Ad Banner Bridge

AdBannerIOS::AdBannerIOS(LDAdBanner * iosBanner): listener(0), banner(iosBanner), bridgeDelegate(0), layout(AdBannerLayout::TOP_CENTER), x(0), y(0)
{
}

void AdBannerIOS::show()
{
    if (!banner.view.superview) {
        [getViewController().view addSubview:banner.view];
    }
    banner.view.hidden = NO;
    this->layoutBanner();
}

void AdBannerIOS::hide()
{
    banner.view.hidden = YES;
}

int32_t AdBannerIOS::getWidth() const
{
    return banner.view.bounds.size.width;
}

int32_t AdBannerIOS::getHeight() const
{
    return banner.view.bounds.size.height;
}

void AdBannerIOS::load()
{
    [banner loadAd];
}

void AdBannerIOS::setListener(AdBannerListener * listener)
{
    this->listener = listener;
    bridgeDelegate = [[LDAdBannerDelegateBridge alloc] init];
    bridgeDelegate.banner = this;
    banner.delegate = bridgeDelegate;
}

void AdBannerIOS::setLayout(AdBannerLayout layout)
{
    this->layout = layout;
    layoutBanner();
}

void AdBannerIOS::setPosition(float x, float y)
{
    this->x = x;
    this->y = y;
    layoutBanner();
}

void AdBannerIOS::layoutBanner()
{
    if (!banner.view.superview) {
        return;
    }
    CGSize size = banner.adSize;
    CGSize container = getViewController().view.bounds.size;
    
    switch (layout) {
        default:
        case AdBannerLayout::TOP_CENTER : banner.view.frame = CGRectMake(container.width * 0.5 - size.width * 0.5, 0, size.width, size.height);
            break;
        case AdBannerLayout::BOTTOM_CENTER : banner.view.frame = CGRectMake(container.width * 0.5 - size.width * 0.5, container.height - size.height, size.width, size.height);
            break;
        case AdBannerLayout::CUSTOM: banner.view.frame = CGRectMake(x, y, size.width, size.height);
            break;
    }
}

#pragma mark Ad Interstitial Bridge

AdInterstitialIOS::AdInterstitialIOS(LDAdInterstitial * iosInterstitial): listener(0), interstitial(iosInterstitial), bridgeDelegate(0)
{
}

void AdInterstitialIOS::show()
{
    [interstitial showFromViewController:getViewController() animated:YES];
}


void AdInterstitialIOS::load()
{
    [interstitial loadAd];
}

void AdInterstitialIOS::setListener(AdInterstitialListener * listener)
{
    this->listener = listener;
    bridgeDelegate = [[LDAdInterstitialDelegateBridge alloc] init];
    bridgeDelegate.interstitial = this;
    interstitial.delegate = bridgeDelegate;
}

#pragma mark Ad Service Bridge

AdServiceIOS::AdServiceIOS(LDAdService * iosService): service(iosService)
{
}

void AdServiceIOS::configure(const AdServiceSettings & settings)
{
    service.settings.banner = settings.banner.empty() ? nil : [NSString stringWithUTF8String:settings.banner.c_str()];
    service.settings.interstitial = settings.interstitial.empty() ? nil : [NSString stringWithUTF8String:settings.interstitial.c_str()];
    
}

AdBanner * AdServiceIOS::createBanner(const char * adunit, AdBannerSize size)
{
    NSString * ad = adunit ? [NSString stringWithUTF8String:adunit] : nil;
    LDAdBannerSize adSize;
    switch (size) {
        case AdBannerSize::BANNER_SIZE: adSize = LD_BANNER_SIZE; break;
        case AdBannerSize::MEDIUM_RECT_SIZE: adSize = LD_MEDIUM_RECT_SIZE; break;
        case AdBannerSize::LEADERBOARD_SIZE: adSize = LD_LEADERBOARD_SIZE; break;
        case AdBannerSize::SMART_SIZE:
        default: adSize = LD_SMART_SIZE; break;
    }
    LDAdBanner * banner = [service createBanner:ad size: adSize];
    return new AdBannerIOS(banner);
}


AdInterstitial * AdServiceIOS::createInterstitial(const char * adunit)
{
    NSString * ad = adunit ? [NSString stringWithUTF8String:adunit] : nil;
    LDAdInterstitial * interstitial = [service createInterstitial:ad];
    return new AdInterstitialIOS(interstitial);
}


AdService * AdService::create(const char *className)
{
    Class c = NSClassFromString([NSString stringWithUTF8String:className]);
    if (c) {
        LDAdService * service = [[c alloc] init];
        return new AdServiceIOS(service);
    }
    return nullptr;
}

AdService * AdService::create(AdProvider provider)
{
    std::map<AdProvider, const char *> providers = {
        {AdProvider::MOPUB, "LDAdServiceMoPub"},
        {AdProvider::ADMOB, "LDAdServiceAdMob"}
    };
    
    if (provider == AdProvider::AUTO) {
        
        for (auto & it : providers) {
            AdService * service = AdService::create(it.second);
            if (service) {
                return service;
            }
        }
        return nullptr;
    }
    else {
        auto it = providers.find(provider);
        return it != providers.end() ? AdService::create(it->second)  : nullptr;
    }
}
