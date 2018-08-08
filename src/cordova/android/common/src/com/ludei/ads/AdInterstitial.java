package com.ludei.ads;

/**
 * Defines an interstitial ad.
 *
 * @author Imanol Fernández (@MortimerGoro)
 * @version 1.1
 */
public interface AdInterstitial {

    class Error {
        public long code;
        public String message;
    }

    /**
     * Sets a listener for an interstitial.
     *
     * @param listener An interstitial listener.
     */
    void setListener(InterstitialListener listener);

    /**
     * Loads an interstitial.
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
    interface InterstitialListener {

        /**
         * Sent when the interstitial has loaded an ad.
         *
         * @param interstitial An interstitial ad.
         */
        void onLoaded(AdInterstitial interstitial);

        /**
         * Sent when the interstitial has failed to retrieve an ad.
         *
         * @param interstitial An interstitial ad.
         * @param error        Error code and message.
         */
        void onFailed(AdInterstitial interstitial, Error error);

        /**
         * Sent when the user has tapped on the interstitial.
         *
         * @param interstitial An interstitial ad.
         */
        void onClicked(AdInterstitial interstitial);

        /**
         * Sent when the interstitial has just taken over the screen.
         */
        void onShown(AdInterstitial interstitial);

        /**
         * Sent when the interstitial is closed.
         *
         * @param interstitial An interstitial ad.
         */
        void onDismissed(AdInterstitial interstitial);
    }
}
