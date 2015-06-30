package com.ludei.ads.admob;

import android.content.Context;

import com.ludei.ads.AdBanner;
import com.ludei.ads.AdInterstitial;
import com.ludei.ads.AdService;

public class AdServiceAdMob implements AdService {

    private String _bannerAdUnit;
    private String _interstitialAdUnit;

    @Override
    public void configure(String bannerAdUnit, String interstitialAdUnit)
    {
        _bannerAdUnit = bannerAdUnit;
        _interstitialAdUnit = interstitialAdUnit;
    }

    @Override
    public AdBanner createBanner(Context ctx) {
        return createBanner(ctx, null, AdBanner.BannerSize.SMART_SIZE);
    }

    @Override
    public AdBanner createBanner(Context ctx, String adunit, AdBanner.BannerSize size) {
        if (adunit == null || adunit.length() == 0) {
            adunit = _bannerAdUnit;
        }
        if (adunit == null || adunit.length() == 0) {
            throw new RuntimeException("Empty AdUnit");
        }
        return new AdBannerAdMob(ctx, adunit, size);
    }


    @Override
    public AdInterstitial createInterstitial(Context ctx) {
        return createInterstitial(ctx, null);
    }

    @Override
    public AdInterstitial createInterstitial(Context ctx, String adunit) {

        if (adunit == null || adunit.length() == 0) {
            adunit = _interstitialAdUnit;
        }
        if (adunit == null || adunit.length() == 0) {
            throw new RuntimeException("Empty AdUnit");
        }
        return new AdInterstitialAdMob(ctx, adunit);
    }

    @Override
    public AdInterstitial createRewardedVideo(Context ctx, String adunit) {
        return this.createInterstitial(ctx, adunit);
    }


}
