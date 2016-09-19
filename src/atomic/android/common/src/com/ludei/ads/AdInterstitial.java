package com.ludei.ads;

/**
 * Defines an interstitial ad.
 *
 * @author Imanol Fernández
 * @version 1.0
 */
public interface AdInterstitial {


    class Reward {
        public long amount;
        public String currency;
        public String itmKey;
    }

    class Error {
        public long code;
        public String message;
    }

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
         * @param error Error code and message
         */
        public void onFailed(AdInterstitial interstitial, Error error);
        
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
        public void onRewardCompleted(AdInterstitial interstitial, Reward reward, Error error);
    }
}
