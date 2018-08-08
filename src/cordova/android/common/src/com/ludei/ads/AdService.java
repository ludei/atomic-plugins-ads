package com.ludei.ads;

import android.app.Activity;
import android.content.Context;
import org.json.JSONObject;

/**
 * Defines the ad service.
 *
 * @author Imanol Fernández (@MortimerGoro)
 * @version 1.1
 */
public interface AdService {

    /**
     * Configures the default AdUnits for banners and interstitials.
     *
     * @param activity The activity that will be used to initialize the ads.
     * @param settings The necessary settings for the Ads service.
     */
    void configure(Activity activity, JSONObject settings);

    /**
     * Creates AdBanner with default size and AdUnit (taken from settings).
     *
     * @param ctx The activity context.
     * @return A banner ad.
     */
    AdBanner createBanner(Context ctx);

    /**
     * Creates AdBanner with custom AdUnit and size.
     *
     * @param adUnit Optional banner AdUnit, taken from settings if not specified.
     * @param size   The size of the banner.
     * @return A banner ad.
     */
    AdBanner createBanner(Context ctx, String adUnit, AdBanner.BannerSize size);

    /**
     * Creates AdInterstitial with default AdUnit (taken from settings).
     *
     * @param ctx The activity context.
     * @return An interstitial ad.
     */
    AdInterstitial createInterstitial(Context ctx);

    /**
     * Creates AdInterstitial with specific AdUnit.
     *
     * @param adUnit Optional interstitial AdUnit, taken from settings if not specified.
     * @param ctx    The activity context.
     * @return An interstitial ad.
     */
    AdInterstitial createInterstitial(Context ctx, String adUnit);

    /**
     * Creates Rewarded Video with default AdUnit (taken from settings).
     * If the networks doesn't support rewarded video it fallbacks to a interstitial.
     *
     * @param ctx The activity context.
     * @return An interstitial ad.
     */
    AdRewardedVideo createRewardedVideo(Context ctx);

    /**
     * Creates Rewarded Video with specific AdUnit.
     * If the networks doesn't support rewarded video it fallbacks to a interstitial.
     *
     * @param adUnit Optional interstitial AdUnit, taken from settings if not specified.
     * @param ctx    The activity context.
     * @return An interstitial ad.
     */
    AdRewardedVideo createRewardedVideo(Context ctx, String adUnit);
}
