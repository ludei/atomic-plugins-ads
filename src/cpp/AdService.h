#pragma once

#include "AdBanner.h"
#include "AdInterstitial.h"

namespace ludei { namespace ads {
    
    /**
     * The different ad providers available. 
     */
    enum class AdProvider {
        /*
         * Automatic. The provider is automatically selected depending on linked classes.
         */
        AUTO,
        /**
         * Mopub.
         */
        MOPUB,
        /**
         * Admob.
         */
        ADMOB
    };
    
    /**
     * Ad service configuration settings. 
     */
    struct AdServiceSettings {
        
        /**
         * Default adunit for banners.
         */
        std::string banner; 
        
        /**
         * Default adunit for interstitials.
         */
        std::string interstitial; 
        
        /**
         * Optional adunit. If empty, the 'banner' property is used on tablets.
         */
        std::string bannerTablet; 
        
        /**
         * Optional adunit. If empty, the 'interstitial' property is used on tablets.
         */
        std::string interstitialTablet;
    };
    
    /**
     * The ad service. 
     */
    class AdService {
    public:
        
        virtual ~AdService(){};

        /**
         *  Creates a new AdService
         *
         *  @param provider The Ad Provider that will be used or AUTO to automatically select the one linked within the binary
         *  @result The AdService with the selected provider or NULL if the provider is not available
         */
        static AdService * create(AdProvider provider = AdProvider::AUTO);

        /**
         *  Creates a new AdService
         *
         *  @param className The className of the provider
         *  @result The AdService with the selected provider or NULL if the provider is not available
         */
        static AdService * create(const char * className);
        
        /**
         * Stablishes the default configuration for the ad service. 
         * 
         * @param settings The default settings. 
         */
        virtual void configure(const AdServiceSettings & settings) = 0;
        
        /**
         * Creates a new banner. If no adunit is specified, the default one will be used. 
         * 
         * @param adunit
         */
        virtual AdBanner * createBanner(const char * adunit = 0, AdBannerSize size = AdBannerSize::SMART_SIZE) = 0;
        
        /**
         * Creates a new interstitial. If no adunit is specified, the default one will be used. 
         * 
         * @param adunit The interstitial adunit. 
         */
        virtual AdInterstitial * createInterstitial(const char * adunit = 0) = 0;
    };
    
} }