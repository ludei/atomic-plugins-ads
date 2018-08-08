package com.ludei.ads;

import android.view.View;

/**
 * Defines a banner ad.
 *
 * @author Imanol Fernández (@MortimerGoro)
 * @version 1.1
 */
public interface AdBanner {

    class Error {
        public long code;
        public String message;
    }

    /**
     * Sets a listener for a banner ad.
     *
     * @param listener A banner listener.
     */
    void setListener(BannerListener listener);

    /**
     * Loads a banner.
     */
    void loadAd();

    /**
     * Returns the width of the banner ad.
     *
     * @return An int with the width of the banner.
     */
    int getWidth();

    /**
     * Returns the height of the banner ad.
     *
     * @return An int with the height of the banner.
     */
    int getHeight();

    /**
     * Returns a view.
     *
     * @return A view
     */
    View getView();

    /**
     * Destroys a banner.
     */
    void destroy();

    /**
     * Defines the size of a banner ad.
     */
    enum BannerSize {
        SMART_SIZE,
        BANNER_SIZE,
        MEDIUM_RECT_SIZE,
        LEADERBOARD_SIZE
    }

    /**
     * Allows to listen to banner ads events.
     */
    interface BannerListener {

        void onLoaded(AdBanner banner);

        /**
         * Sent when the banner has failed to retrieve an ad.
         *
         * @param banner A banner ad.
         * @param error  Error code and message
         */
        void onFailed(AdBanner banner, Error error);

        /**
         * Sent when the user has tapped on the banner.
         *
         * @param banner A banner ad.
         */
        void onClicked(AdBanner banner);

        /**
         * Sent when the banner has just taken over the screen.
         *
         * @param banner A banner ad.
         */
        void onExpanded(AdBanner banner);

        /**
         * Sent when an expanded banner has collapsed back to its original size.
         *
         * @param banner A banner ad.
         */
        void onCollapsed(AdBanner banner);
    }
}
