
#include "AdServiceAndroid.h"
#include <map>

#define BRIDGE_CLASS_NAME "com/ludei/ads/cpp/AdServiceBridge"

using namespace ludei::ads;


#pragma mark Listeners bridge


#pragma mark Ad Banner Bridge

AdBannerAndroid::AdBannerAndroid(SPJNIObject javaService):
javaObject(javaService), listener(0), width(0), height(0)
{

}

AdBannerAndroid::~AdBannerAndroid()
{
    javaObject->call("releaseBanner", this);
}

void AdBannerAndroid::show()
{
    javaObject->call("showBanner", this);
}

void AdBannerAndroid::hide()
{
    javaObject->call("hideBanner", this);
}

int32_t AdBannerAndroid::getWidth() const
{
    return width;
}

int32_t AdBannerAndroid::getHeight() const
{
    return height;
}

void AdBannerAndroid::load()
{
    javaObject->call("loadBanner", this);
}

void AdBannerAndroid::setListener(AdBannerListener * listener)
{
    this->listener = listener;
}

void AdBannerAndroid::setLayout(AdBannerLayout layout)
{
    const char * strLayout;
    switch (layout) {
        case AdBannerLayout::TOP_CENTER: strLayout = "TOP_CENTER"; break;
        case AdBannerLayout::BOTTOM_CENTER: strLayout = "BOTTOM_CENTER"; break;
        case AdBannerLayout::CUSTOM: strLayout = "CUSTOM"; break;
    }
    javaObject->call("setBannerLayout", this, strLayout);
}

void AdBannerAndroid::setPosition(float x, float y)
{
    javaObject->call("setBannerPosition",this, x, y);
}

#pragma mark Ad Interstitial Bridge

AdInterstitialAndroid::AdInterstitialAndroid(SPJNIObject javaService):
javaObject(javaService), listener(0)
{
}

AdInterstitialAndroid::~AdInterstitialAndroid()
{
    javaObject->call("releaseInterstitial", this);
}

void AdInterstitialAndroid::show()
{
    javaObject->call("showInterstitial", this);
}


void AdInterstitialAndroid::load()
{
    javaObject->call("loadInterstitial", this);
}

void AdInterstitialAndroid::setListener(AdInterstitialListener * listener)
{
    this->listener = listener;
}

#pragma mark Ad Service Bridge

AdServiceAndroid::AdServiceAndroid(SPJNIObject androidService)
{
    javaObject = androidService;
}

AdServiceAndroid::~AdServiceAndroid()
{
    javaObject->call("nativeDestructor");
}

void AdServiceAndroid::configure(const AdServiceSettings & settings)
{
    javaObject->call("configure", settings.banner, settings.interstitial);
}

AdBanner * AdServiceAndroid::createBanner(const char * adunit, AdBannerSize size)
{
    AdBannerAndroid * banner = new AdBannerAndroid(javaObject);
    const char * strSize;
    switch (size) {
        case AdBannerSize::SMART_SIZE: strSize = "SMART_SIZE"; break;
        case AdBannerSize::BANNER_SIZE: strSize = "BANNER_SIZE"; break;
        case AdBannerSize::LEADERBOARD_SIZE: strSize = "LEADERBOARD_SIZE"; break;
        case AdBannerSize::MEDIUM_RECT_SIZE: strSize = "MEDIUM_RECT_SIZE"; break;
    }
    javaObject->call("createBanner", banner, adunit, strSize);
    return banner;
}


AdInterstitial * AdServiceAndroid::createInterstitial(const char * adunit)
{
   AdInterstitialAndroid * interstitial = new AdInterstitialAndroid(javaObject);
   javaObject->call("createInterstitial", interstitial, adunit);
   return interstitial;
}


AdService * AdService::create(const char *className)
{
    SPJNIObject service = JNIObject::create(BRIDGE_CLASS_NAME);
    bool initialized = service->call<bool>("init", className);
    if (initialized) {
        return new AdServiceAndroid(service);
    }
    return nullptr;
}

AdService * AdService::create(AdProvider provider)
{
        std::map<AdProvider, const char *> providers = {
            {AdProvider::MOPUB, "com.ludei.ads.mopub.AdServiceMoPub"},
            {AdProvider::ADMOB, "com.ludei.ads.admob.AdServiceAdMob"}
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

extern "C"
{
    void Java_com_ludei_ads_cpp_AdServiceBridge_nativeBannerOnLoaded(JNIEnv * env, jlong pointer, jint width, jint height)
    {
        AdBannerAndroid * banner = reinterpret_cast<AdBannerAndroid*>(pointer);
        banner->width = width;
        banner->height = height;
        if (banner->listener) {
            banner->listener->onLoaded(banner);
        }
    }

    void Java_com_ludei_ads_cpp_AdServiceBridge_nativeBannerOnFailed(JNIEnv * env, jlong pointer, jint code, jstring message)
    {
        AdBannerAndroid * banner = reinterpret_cast<AdBannerAndroid*>(pointer);
        if (banner->listener) {
            banner->listener->onFailed(banner, code, Utils::toString(message));
        }
    }

    void Java_com_ludei_ads_cpp_AdServiceBridge_nativeBannerOnClicked(JNIEnv * env, jlong pointer)
    {
        AdBannerAndroid * banner = reinterpret_cast<AdBannerAndroid*>(pointer);
        if (banner->listener) {
            banner->listener->onClicked(banner);
        }
    }

    void Java_com_ludei_ads_cpp_AdServiceBridge_nativeBannerOnExpanded(JNIEnv * env, jlong pointer)
    {
        AdBannerAndroid * banner = reinterpret_cast<AdBannerAndroid*>(pointer);
        if (banner->listener) {
            banner->listener->onExpanded(banner);
        }
    }

    void Java_com_ludei_ads_cpp_AdServiceBridge_nativeBannerOnCollapsed(JNIEnv * env, jlong pointer)
    {
        AdBannerAndroid * banner = reinterpret_cast<AdBannerAndroid*>(pointer);
        if (banner->listener) {
            banner->listener->onCollapsed(banner);
        }
    }

    void Java_com_ludei_ads_cpp_AdServiceBridge_nativeInterstitialOnLoaded(JNIEnv * env, jlong pointer)
    {
        AdInterstitialAndroid * interstitial = reinterpret_cast<AdInterstitialAndroid*>(pointer);
        if (interstitial->listener) {
            interstitial->listener->onLoaded(interstitial);
        }
    }

    void Java_com_ludei_ads_cpp_AdServiceBridge_nativeInterstitialOnFailed(JNIEnv * env, jlong pointer, jint code, jstring message)
    {
        AdInterstitialAndroid * interstitial = reinterpret_cast<AdInterstitialAndroid*>(pointer);
        if (interstitial->listener) {
            interstitial->listener->onFailed(interstitial, code, Utils::toString(message));
        }
    }

    void Java_com_ludei_ads_cpp_AdServiceBridge_nativeInterstitialOnClicked(JNIEnv * env, jlong pointer)
    {
        AdInterstitialAndroid * interstitial = reinterpret_cast<AdInterstitialAndroid*>(pointer);
        if (interstitial->listener) {
            interstitial->listener->onClicked(interstitial);
        }
    }

    void Java_com_ludei_ads_cpp_AdServiceBridge_nativeInterstitialOnShown(JNIEnv * env, jlong pointer)
    {
        AdInterstitialAndroid * interstitial = reinterpret_cast<AdInterstitialAndroid*>(pointer);
        if (interstitial->listener) {
            interstitial->listener->onShown(interstitial);
        }
    }

    void Java_com_ludei_ads_cpp_AdServiceBridge_nativeInterstitialOnDismissed(JNIEnv * env, jlong pointer)
    {
        AdInterstitialAndroid * interstitial = reinterpret_cast<AdInterstitialAndroid*>(pointer);
        if (interstitial->listener) {
            interstitial->listener->onHidden(interstitial);
        }
    }
}
