package com.ludei.ads.admob;

import android.app.Activity;
import android.content.Context;
import com.google.android.gms.ads.MobileAds;
import com.ludei.ads.AdBanner;
import com.ludei.ads.AdInterstitial;
import com.ludei.ads.AdRewardedVideo;
import com.ludei.ads.AdService;
import org.json.JSONObject;

public class AdServiceAdMob implements AdService {

    private boolean _initialized = false;
    private boolean _personalizedAdsConsent;
    private String _bannerAdUnit;
    private String _interstitialAdUnit;
    private String _rewardedVideoAdUnit;

    @Override
    public void configure(Activity activity, JSONObject settings) {
        String appId = settings.optString("appId");
        String banner = settings.optString("banner");
        String interstitial = settings.optString("interstitial");
        String rewardedVideo = settings.optString("rewardedVideo");
        boolean personalizedAdsConsent = settings.optBoolean("personalizedAdsConsent");
        if (appId == null) {
            throw new RuntimeException("Empty App AdUnit");
        }

        if (!_initialized) {
            MobileAds.initialize(activity, appId);
            _initialized = true;
        }
        _bannerAdUnit = banner;
        _interstitialAdUnit = interstitial;
        _rewardedVideoAdUnit = rewardedVideo;
        _personalizedAdsConsent = personalizedAdsConsent;
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
    public AdRewardedVideo createRewardedVideo(Context ctx) {
        return createRewardedVideo(ctx, null);
    }

    @Override
    public AdRewardedVideo createRewardedVideo(Context ctx, String adUnit) {
        if (adUnit == null || adUnit.length() == 0) {
            adUnit = _rewardedVideoAdUnit;
        }
        if (adUnit == null || adUnit.length() == 0) {
            throw new RuntimeException("Empty AdUnit");
        }
        return new AdRewardedAdMob(ctx, adUnit, _personalizedAdsConsent);
    }
}
