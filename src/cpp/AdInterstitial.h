#pragma once

#include <string>

namespace ludei { namespace ads {

    class AdInterstitialListener;
    
    /**
     * Defines an interstitial ad. 
     */
    class AdInterstitial {
    public:
    	
        virtual ~AdInterstitial(){};
        
        /**
         * Shows the interstitial. 
         */
        virtual void show() = 0;
        
        /**
         * Hides the interstitial. 
         */
        virtual void load() = 0;
        
        /**
         * Sets a new listener for the interstitial. 
         * 
         * @param listener The listener to be set. 
         */
        virtual void setListener(AdInterstitialListener * listener) = 0;
    };
    
	/**
	 * Allows to listen to events regarding interstitials. 
	 */
    class AdInterstitialListener {
    public:
    	
        virtual ~AdInterstitialListener(){}
        
        /**
         * Triggered when the interstitial has loaded a new ad. 
         * 
         * @param interstitial The interstitial. 
         */
        virtual void onLoaded(AdInterstitial * interstitial) = 0;
        
        /**
         * Triggered when the interstitial has failed on loading a new ad.  
         * 
         * @param interstitial The interstitial. 
         * @param code The code of the error. 
         * @param message The error message. 
         */
        virtual void onFailed(AdInterstitial * interstitial, int32_t code, const std::string & message) = 0;
        
        /**
         * Triggered when the interstitial has been clicked. 
         * 
         * @param interstitial The interstitial. 
         */
        virtual void onClicked(AdInterstitial * interstitial) = 0;
        
        /**
         * Triggered when the interstitial shows its modal content. 
         * 
         * @param interstitial The interstitial. 
         */
        virtual void onShown(AdInterstitial * interstitial) = 0;
        
        /**
         * Triggered when the interstitial is hidden. 
         * 
         * @param interstitial The interstitial. 
         */
        virtual void onHidden(AdInterstitial * interstitial) = 0;
    };
    
} }