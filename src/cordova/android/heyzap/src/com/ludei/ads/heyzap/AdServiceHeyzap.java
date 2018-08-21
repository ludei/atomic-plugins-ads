package com.ludei.ads.heyzap;

import android.app.Activity;
import android.content.Context;
import com.heyzap.sdk.ads.HeyzapAds;
import com.ludei.ads.AdBanner;
import com.ludei.ads.AdInterstitial;
import com.ludei.ads.AdService;

public class AdServiceHeyzap implements AdService {

    private String _publisherId;
    private String _bannerTag = "default";
    private String _interstitialTag = "default";
    private String _rewardedTag = "default";
    private Activity _activity;

    public void init(Activity activity, String publisherId) {
        this._activity = activity;
        this._publisherId = publisherId;

        HeyzapAds.start(_publisherId, activity);
    }

    public void showDebug() {
        HeyzapAds.startTestActivity(this._activity);
    }

    @Override
    public void configure(String bannerAdUnit, String interstitialAdUnit) {
        //Nothing to do
    }

    @Override
    public AdBanner createBanner(Context ctx) {
        return createBanner(ctx, null, AdBanner.BannerSize.SMART_SIZE);
    }

    @Override
    public AdBanner createBanner(Context ctx, String tag, AdBanner.BannerSize size) {
        if (tag != null)
            this._bannerTag = tag;

        return new AdBannerHeyzap(this._activity, _bannerTag);
    }


    @Override
    public AdInterstitial createInterstitial(Context ctx) {
        return createInterstitial(ctx, null);
    }

    @Override
    public AdInterstitial createInterstitial(Context ctx, String tag) {
        if (tag != null)
            this._interstitialTag = tag;

        return new AdInterstitialHeyzap(this._activity, this._interstitialTag);
    }

    @Override
    public AdInterstitial createRewardedVideo(Context ctx, String tag) {
        if (tag != null)
            this._rewardedTag = tag;

        return new AdRewardedHeyzap(this._activity, this._rewardedTag);
    }


}
