#pragma once
#include "AdService.h"
#include "safejni.h"
using namespace safejni;


namespace ludei { namespace ads {
    
    /*
     * Bridge between C++ API and atomic android implementation
     */
    
    class AdServiceAndroid: public AdService {

    public:
        AdServiceAndroid(SPJNIObject javaService);
        ~AdServiceAndroid();
        void configure(const AdServiceSettings & settings) override;
        AdBanner * createBanner(const char * adunit = 0, AdBannerSize size = AdBannerSize::SMART_SIZE) override;
        AdInterstitial * createInterstitial(const char * adunit = 0) override;

        SPJNIObject javaObject;
    };
    
    class AdBannerAndroid: public AdBanner {
    public:
        AdBannerAndroid(SPJNIObject javaService);
        ~AdBannerAndroid();
        void show() override;
        void hide() override;
        int32_t getWidth() const override;
        int32_t getHeight() const override;
        void load() override;
        void setListener(AdBannerListener * listener) override;
        void setLayout(AdBannerLayout layout) override;
        void setPosition(float x, float y) override;
        
        void layoutBanner();
        AdBannerListener * listener;
        SPJNIObject javaObject;
        int32_t width;
        int32_t height;
    };
    
    class AdInterstitialAndroid: public AdInterstitial {
    public:
        AdInterstitialAndroid(SPJNIObject javaService);
        ~AdInterstitialAndroid();
        void show() override;
        void load() override;
        void setListener(AdInterstitialListener * listener) override;

        AdInterstitialListener * listener;
        SPJNIObject javaObject;
    };

} }