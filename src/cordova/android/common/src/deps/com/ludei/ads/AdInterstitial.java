package com.ludei.ads;

/**
 * Defines an interstitial ad.
 *
 * @author Imanol Fernández
 * @version 1.0
 */
public interface AdInterstitial {

	/**
	 * Sets a listener for an interstitial.
     *
	 * @param listener An interstital listener.
	 */
    void setListener(InterstitialListener listener);
    
    /**
     * Loads an interstital.
     */
    void loadAd();
    
    /**
     * Shows the interstitial.
     */
    void show();
    
    /**
     * Destroys the interstitial.
     */
    void destroy();

    /**
     * Allows to listen to interstitial ads events.
     */
    public interface InterstitialListener {
    	
    	/**
    	 * Sent when the interstitial has loaded an ad.
         *
    	 * @param interstitial An interstitial ad.
    	 */
        public void onLoaded(AdInterstitial interstitial);
        
        /**
         * Sent when the interstitial has failed to retrieve an ad.
         *
    	 * @param interstitial An interstitial ad.
         * @param errorCode An int with the error code.
         * @param errorMessage A string that describes the error.
         */
        public void onFailed(AdInterstitial interstitial, int errorCode, String errorMessage);
        
        /**
         * Sent when the user has tapped on the interstitial.
         *
    	 * @param interstitial An interstitial ad.
         */    
        public void onClicked(AdInterstitial interstitial);
        
        /**
         * Sent when the interstitial has just taken over the screen.
         */
        public void onShown(AdInterstitial interstitial);
        
        /**
         * Sent when the interstitial is closed.
         *
     	 * @param interstitial An interstitial ad
         */    
        public void onDismissed(AdInterstitial interstitial);
        /**
         * Sent when the interstitial is closed.
         *
         * @param interstitial An interstitial ad
         */
        public void onRewardCompleted(AdInterstitial interstitial, int quantity);
    }
}
