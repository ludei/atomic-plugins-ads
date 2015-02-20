#pragma once

#include "AdBanner.h"
#include "AdInterstitial.h"

namespace ludei { namespace ads {
	
	/**
	 * The different ad providers available. 
	 */
    enum class AdProvider {
    	/*
    	 * Automatic. 
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
         * Optional adunit. If empty 'banner' property is used on tablets.
         */
        std::string bannerTablet; 
        
        /**
         * Optional adunit. If empty 'interstitial' property is used on tablets.
         */
        std::string interstitialTablet;
    };
    
    /**
     * The ad service. 
     */
    class AdService {
    public:
    	
        virtual ~AdService(){};

        static AdService * create(AdProvider provider = AdProvider::AUTO);

        static AdService * create(const char * className);
        
        /**
         * Stablishes the default configuration for the ad service. 
         * 
         * @param settings The default settings. 
         */
        virtual void configure(const AdServiceSettings & settings) = 0;
        
        /**
         * Creates a new banner. If no adunit is specified, it will be used the default one. 
         * 
         * @param adunit
         */
        virtual AdBanner * createBanner(const char * adunit = 0, AdBannerSize size = AdBannerSize::SMART_SIZE) = 0;
        
        /**
         * Creates a new interstitial. If no adunit is specified, it will be used the default one. 
         * 
         * @param adunit The interstitial adunit. 
         */
        virtual AdInterstitial * createInterstitial(const char * adunit = 0) = 0;
    };
    
} }