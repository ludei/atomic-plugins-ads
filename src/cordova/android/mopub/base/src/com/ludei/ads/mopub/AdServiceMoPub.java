package com.ludei.ads.mopub;

import android.app.Activity;
import android.content.Context;
import com.ludei.ads.AdBanner;
import com.ludei.ads.AdInterstitial;
import com.ludei.ads.AdRewardedVideo;
import com.ludei.ads.AdService;
import com.mopub.common.MoPub;
import com.mopub.common.SdkConfiguration;
import com.mopub.common.SdkInitializationListener;
import org.json.JSONObject;

public class AdServiceMoPub implements AdService {

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

        _bannerAdUnit = banner;
        _interstitialAdUnit = interstitial;
        _rewardedVideoAdUnit = rewardedVideo;
        _personalizedAdsConsent = personalizedAdsConsent;

        if (!_initialized) {
            _initialized = true;
            SdkConfiguration sdkConfiguration = new SdkConfiguration.Builder(appId).build();
            MoPub.initializeSdk(activity, sdkConfiguration, initSdkListener());
        } else {
            if (MoPub.getPersonalInformationManager() != null) {
                if (_personalizedAdsConsent) {
                    MoPub.getPersonalInformationManager().grantConsent();
                } else {
                    MoPub.getPersonalInformationManager().revokeConsent();
                }
            }
        }
    }

    private SdkInitializationListener initSdkListener() {
        return new SdkInitializationListener() {
            @Override
            public void onInitializationFinished() {
                if (MoPub.getPersonalInformationManager() != null) {
                    if (_personalizedAdsConsent) {
                        MoPub.getPersonalInformationManager().grantConsent();
                    } else {
                        MoPub.getPersonalInformationManager().revokeConsent();
                    }
                }
            }
        };
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
        return new AdBannerMoPub(ctx, adUnit, size);
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
        return new AdInterstitialMoPub(ctx, adUnit);
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
        return new AdRewardedMoPub(ctx, adUnit);
    }
}
