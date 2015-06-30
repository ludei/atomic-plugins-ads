package com.ludei.ads;


import android.content.Context;

/**
 * Defines the ad service.
 *
 * @author Imanol Fernández
 * @version 1.0
 */
public interface AdService
{
    /**
     * Configures default adunits for banners and interstitials.
     *
     * @param bannerAdUnit The banner AdUnit.
     * @param interstitialAdUnit The intesttitial AdUnit.
     */
    void configure(String bannerAdUnit, String interstitialAdUnit);

    /**
     * Creates AdBanner with default size and adunit (taken from settings).
     *
     * @param ctx The activity context.
     * @return A banner ad.
     */
    AdBanner createBanner(Context ctx);

    /**
     * Creates AdBanner with custom adunit and size.
     *
     * @param adunit Optional banner adunit, taken from settings if not specified.
     * @param size The size of the banner.
     * @return A banner ad.
     */
    AdBanner createBanner(Context ctx, String adunit, AdBanner.BannerSize size );

    /**
     * Creates AdInterstitial with default adunit (taken from settings).
     *
     * @param ctx The activity context.
     * @return An interstitial ad.
     */
    AdInterstitial createInterstitial(Context ctx);

    /**
     * Creates AdInterstitial with specific adunit.
     *
     * @param adunit Optional interstitial adunit, taken from settings if not specified.
     * @param ctx The activity context.
     * @return An interstitial ad.
     */
    AdInterstitial createInterstitial(Context ctx, String adunit);

    /**
     * Creates Rewarded Video with specific adunit.
     * If the networks doesn't support rewarded video it fallbacks to a interstitial
     *
     * @param adunit Optional interstitial adunit, taken from settings if not specified.
     * @param ctx The activity context.
     * @return An interstitial ad.
     */
    AdInterstitial createRewardedVideo(Context ctx, String adunit);
}