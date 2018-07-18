package com.ludei.ads.chartboost;

import android.app.Activity;
import android.content.Context;

import com.chartboost.sdk.CBLocation;
import com.chartboost.sdk.Chartboost;
import com.chartboost.sdk.ChartboostDelegate;
import com.chartboost.sdk.Model.CBError;
import com.ludei.ads.AdBanner;
import com.ludei.ads.AdInterstitial;
import com.ludei.ads.AdService;

import java.util.HashMap;

public class AdServiceChartboost implements AdService {


    private HashMap<String, AdInterstitialChartboost> _interstitials = new HashMap<String, AdInterstitialChartboost>();
    private HashMap<String, AdInterstitialChartboost> _rewards = new HashMap<String, AdInterstitialChartboost>();

    public AdServiceChartboost() {
    }

    public void init(Activity activity, String appID, String appSignature, boolean personalizedAdsConsent) {
        Chartboost.restrictDataCollection(activity, personalizedAdsConsent);
        Chartboost.startWithAppId(activity, appID, appSignature);
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
                AdInterstitialChartboost interstitial = _rewards.get(location);
                if (interstitial != null) {
                    interstitial.notifyOnShown();
                }
            }

            @Override
            public void didCompleteRewardedVideo(String location, int reward) {
                AdInterstitialChartboost interstitial = _rewards.get(location);
                if (interstitial != null) {
                    AdInterstitial.Reward rw = new AdInterstitial.Reward();
                    rw.amount = reward;
                    interstitial.notifyOnRewardCompleted(rw, null);
                }
            }

            @Override
            public void didClickRewardedVideo(String location) {
                AdInterstitialChartboost interstitial = _rewards.get(location);
                if (interstitial != null) {
                    interstitial.notifyOnClicked();
                }
            }

            @Override
            public void didDismissRewardedVideo(String location) {
                AdInterstitialChartboost interstitial = _rewards.get(location);
                if (interstitial != null) {
                    interstitial.notifyOnDismissed();
                }
            }

            @Override
            public void didFailToLoadRewardedVideo(String location, CBError.CBImpressionError error) {
                AdInterstitialChartboost interstitial = _rewards.get(location);
                if (interstitial != null) {
                    AdInterstitial.Error err = new AdInterstitial.Error();
                    err.code = error.ordinal();
                    err.message = "Error with code: " + error.ordinal();
                    interstitial.notifyOnFailed(err);
                }
            }

            @Override
            public void didCacheRewardedVideo(String location) {
                AdInterstitialChartboost interstitial = _rewards.get(location);
                if (interstitial != null) {
                    interstitial.notifyOnLoaded();
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
    public void configure(String bannerAdUnit, String interstitialAdUnit) {
        //Nothing to do
    }

    @Override
    public AdBanner createBanner(Context ctx) {
        return createBanner(ctx, null, AdBanner.BannerSize.SMART_SIZE);
    }

    @Override
    public AdBanner createBanner(Context ctx, String adunit, AdBanner.BannerSize size) {
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
        AdInterstitialChartboost cb = new AdInterstitialChartboost(adUnit, false);
        _interstitials.put(adUnit, cb);
        return cb;
    }

    @Override
    public AdInterstitial createRewardedVideo(Context ctx) {
        return createRewardedVideo(ctx, CBLocation.LOCATION_GAMEOVER);
    }

    @Override
    public AdInterstitial createRewardedVideo(Context ctx, String adUnit) {
        if (adUnit == null || adUnit.length() == 0) {
            adUnit = CBLocation.LOCATION_GAMEOVER;
        }
        AdInterstitialChartboost cb = new AdInterstitialChartboost(adUnit, true);
        _rewards.put(adUnit, cb);
        return cb;
    }
}
