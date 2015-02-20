#pragma once
#import "LDAdService.h"
#import "AdService.h"

@class LDAdBannerDelegateBridge;
@class LDAdInterstitialDelegateBridge;

namespace ludei { namespace ads {
    
    /*
     * Bridge between C++ API and atomic ios implementation
     */
    
    class AdServiceIOS: public AdService {
    protected:
        LDAdService * service;
    public:
        AdServiceIOS(LDAdService * service);
        void configure(const AdServiceSettings & settings) override;
        AdBanner * createBanner(const char * adunit = 0, AdBannerSize size = AdBannerSize::SMART_SIZE) override;
        AdInterstitial * createInterstitial(const char * adunit = 0) override;
        
    };
    
    class AdBannerIOS: public AdBanner {
    public:
        AdBannerIOS(LDAdBanner * banner);
        void show() override;
        void hide() override;
        int32_t getWidth() const override;
        int32_t getHeight() const override;
        void load() override;
        void setListener(AdBannerListener * listener) override;
        void setLayout(AdBannerLayout layout) override;
        void setPosition(float x, float y) override;
        
        void layoutBanner();
        LDAdBanner * banner;
        AdBannerListener * listener;
        LDAdBannerDelegateBridge * bridgeDelegate;
        AdBannerLayout layout;
        float x, y;
    };
    
    class AdInterstitialIOS: public AdInterstitial {
    public:
        AdInterstitialIOS(LDAdInterstitial * interstitial);
        void show() override;
        void load() override;
        void setListener(AdInterstitialListener * listener) override;

        LDAdInterstitial * interstitial;
        AdInterstitialListener * listener;
        LDAdInterstitialDelegateBridge * bridgeDelegate;
    };

} }