package com.ludei.ads.admob;

import android.app.Activity;
import android.content.Context;

import android.os.Bundle;
import com.google.android.gms.ads.MobileAds;
import com.ludei.ads.AdBanner;
import com.ludei.ads.AdInterstitial;
import com.ludei.ads.AdService;

public class AdServiceAdMob implements AdService {

    private Bundle _personalizedAdsConsent;
    private String _bannerAdUnit;
    private String _interstitialAdUnit;

    public void init(Activity activity, String appId, String bannerAdUnit, String interstitialAdUnit, boolean personalizedAdsConsent) {
        if (personalizedAdsConsent) {
            _personalizedAdsConsent = null;
        } else {
            _personalizedAdsConsent = new Bundle();
            _personalizedAdsConsent.putString("npa", "1");
        }
        MobileAds.initialize(activity, appId);
        _bannerAdUnit = bannerAdUnit;
        _interstitialAdUnit = interstitialAdUnit;
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
    public AdBanner createBanner(Context ctx, String adUnit, AdBanner.BannerSize size) {
        if (adUnit == null || adUnit.length() == 0) {
            adUnit = _bannerAdUnit;
        }
        if (adUnit == null || adUnit.length() == 0) {
            throw new RuntimeException("Empty AdUnit");
        }
        return new AdBannerAdMob(ctx, adUnit, size, _personalizedAdsConsent);
    }


    @Override
    public AdInterstitial createInterstitial(Context ctx) {
        return createInterstitial(ctx, null);
    }

    @Override
    public AdInterstitial createInterstitial(Context ctx, String adUnit) {

        if (adUnit == null || adUnit.length() == 0) {
            adUnit = _interstitialAdUnit;
        }
        if (adUnit == null || adUnit.length() == 0) {
            throw new RuntimeException("Empty AdUnit");
        }
        return new AdInterstitialAdMob(ctx, adUnit, _personalizedAdsConsent);
    }

    @Override
    public AdInterstitial createRewardedVideo(Context ctx) {
        return createRewardedVideo(ctx, null);
    }

    @Override
    public AdInterstitial createRewardedVideo(Context ctx, String adUnit) {
        if (adUnit == null || adUnit.length() == 0) {
            adUnit = _interstitialAdUnit;
        }
        if (adUnit == null || adUnit.length() == 0) {
            throw new RuntimeException("Empty AdUnit");
        }
        return new AdRewardedAdMob(ctx, adUnit, _personalizedAdsConsent);
    }
}
