package com.ludei.ads.chartboost;

import android.app.Activity;
import android.content.Context;
import com.chartboost.sdk.CBLocation;
import com.chartboost.sdk.Chartboost;
import com.chartboost.sdk.ChartboostDelegate;
import com.chartboost.sdk.Model.CBError;
import com.ludei.ads.AdBanner;
import com.ludei.ads.AdInterstitial;
import com.ludei.ads.AdRewardedVideo;
import com.ludei.ads.AdService;
import org.json.JSONObject;

import java.util.HashMap;

public class AdServiceChartboost implements AdService {


    private HashMap<String, AdInterstitialChartboost> _interstitials = new HashMap<String, AdInterstitialChartboost>();
    private HashMap<String, AdRewardedVideoChartboost> _rewards = new HashMap<String, AdRewardedVideoChartboost>();

    public AdServiceChartboost() {
    }

    @Override
    public void configure(Activity activity, JSONObject settings) {
        String appId = settings.optString("appId");
        String appSignature = settings.optString("appSignature");
        boolean personalizedAdsConsent = settings.optBoolean("personalizedAdsConsent");
        if (appId == null || appSignature == null) {
            throw new RuntimeException("Empty App ID and App Signature are needed.");
        }

        Chartboost.restrictDataCollection(activity, !personalizedAdsConsent);
        Chartboost.startWithAppId(activity, appId, appSignature);
        Chartboost.onCreate(activity);
        Chartboost.setAutoCacheAds(true);
        Chartboost.setDelegate(new ChartboostDelegate() {
            @Override
            public void didDisplayInterstitial(String location) {
                AdInterstitialChartboost interstitial = _interstitials.get(location);
                if (interstitial != null) {
                    interstitial.notifyOnShown();
                }
            }

            @Override
            public void didClickInterstitial(String location) {
                AdInterstitialChartboost interstitial = _interstitials.get(location);
                if (interstitial != null) {
                    interstitial.notifyOnClicked();
                }
            }


            @Override
            public void didDismissInterstitial(String location) {
                AdInterstitialChartboost interstitial = _interstitials.get(location);
                if (interstitial != null) {
                    interstitial.notifyOnDismissed();
                }
            }

            @Override
            public void didFailToLoadInterstitial(String location, CBError.CBImpressionError error) {
                AdInterstitialChartboost interstitial = _interstitials.get(location);
                if (interstitial != null) {
                    AdInterstitial.Error err = new AdInterstitial.Error();
                    err.code = error.ordinal();
                    err.message = "Error with code: " + error.ordinal();
                    interstitial.notifyOnFailed(err);
                }
            }

            @Override
            public void didCacheInterstitial(String location) {
                AdInterstitialChartboost interstitial = _interstitials.get(location);
                if (interstitial != null) {
                    interstitial.notifyOnLoaded();
                }
            }

            @Override
            public void didDisplayRewardedVideo(String location) {
                AdRewardedVideoChartboost rewardedVideo = _rewards.get(location);
                if (rewardedVideo != null) {
                    rewardedVideo.notifyOnShown();
                }
            }

            @Override
            public void didCompleteRewardedVideo(String location, int reward) {
                AdRewardedVideoChartboost rewardedVideo = _rewards.get(location);
                if (rewardedVideo != null) {
                    AdRewardedVideo.Reward rw = new AdRewardedVideo.Reward();
                    rw.amount = reward;
                    rewardedVideo.notifyOnRewardCompleted(rw, null);
                }
            }

            @Override
            public void didClickRewardedVideo(String location) {
                AdRewardedVideoChartboost rewardedVideo = _rewards.get(location);
                if (rewardedVideo != null) {
                    rewardedVideo.notifyOnClicked();
                }
            }

            @Override
            public void didDismissRewardedVideo(String location) {
                AdRewardedVideoChartboost rewardedVideo = _rewards.get(location);
                if (rewardedVideo != null) {
                    rewardedVideo.notifyOnDismissed();
                }
            }

            @Override
            public void didFailToLoadRewardedVideo(String location, CBError.CBImpressionError error) {
                AdRewardedVideoChartboost rewardedVideo = _rewards.get(location);
                if (rewardedVideo != null) {
                    AdRewardedVideo.Error err = new AdRewardedVideo.Error();
                    err.code = error.ordinal();
                    err.message = "Error with code: " + error.ordinal();
                    rewardedVideo.notifyOnFailed(err);
                }
            }

            @Override
            public void didCacheRewardedVideo(String location) {
                AdRewardedVideoChartboost rewardedVideo = _rewards.get(location);
                if (rewardedVideo != null) {
                    rewardedVideo.notifyOnLoaded();
                }
            }
        });
    }


    public void onPause(Activity activity) {
        Chartboost.onPause(activity);
    }

    public void onResume(Activity activity) {
        Chartboost.onResume(activity);
    }

    public void onStop(Activity activity) {
        Chartboost.onResume(activity);
    }

    public void onStart(Activity activity) {
        Chartboost.onStart(activity);
    }

    public void onDestroy(Activity activity) {
        Chartboost.onDestroy(activity);
    }

    public boolean onBackPressed() {
        return Chartboost.onBackPressed();
    }

    @Override
    public AdBanner createBanner(Context ctx) {
        return createBanner(ctx, null, AdBanner.BannerSize.SMART_SIZE);
    }

    @Override
    public AdBanner createBanner(Context ctx, String adUnit, AdBanner.BannerSize size) {
        return null;
    }


    @Override
    public AdInterstitial createInterstitial(Context ctx) {
        return createInterstitial(ctx, CBLocation.LOCATION_DEFAULT);
    }

    @Override
    public AdInterstitial createInterstitial(Context ctx, String adUnit) {
        if (adUnit == null || adUnit.length() == 0) {
            adUnit = CBLocation.LOCATION_DEFAULT;
        }
        AdInterstitialChartboost cb = new AdInterstitialChartboost(adUnit);
        _interstitials.put(adUnit, cb);
        return cb;
    }

    @Override
    public AdRewardedVideo createRewardedVideo(Context ctx) {
        return createRewardedVideo(ctx, CBLocation.LOCATION_GAMEOVER);
    }

    @Override
    public AdRewardedVideo createRewardedVideo(Context ctx, String adUnit) {
        if (adUnit == null || adUnit.length() == 0) {
            adUnit = CBLocation.LOCATION_GAMEOVER;
        }
        AdRewardedVideoChartboost cb = new AdRewardedVideoChartboost(adUnit);
        _rewards.put(adUnit, cb);
        return cb;
    }
}
