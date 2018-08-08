package com.ludei.ads.admob;

import android.content.Context;
import android.os.Bundle;
import com.google.ads.mediation.admob.AdMobAdapter;
import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.MobileAds;
import com.google.android.gms.ads.reward.RewardItem;
import com.google.android.gms.ads.reward.RewardedVideoAd;
import com.google.android.gms.ads.reward.RewardedVideoAdListener;
import com.ludei.ads.AbstractAdRewardedVideo;
import com.ludei.ads.AdRewardedVideo;

public class AdRewardedAdMob extends AbstractAdRewardedVideo {
    private RewardedVideoAd _rewardedVideo;
    private String adUnit;
    private boolean loading = false;
    private boolean adsConsent;

    AdRewardedAdMob(Context ctx, String adUnit, boolean personalizedAdsConsent) {
        adsConsent = personalizedAdsConsent;

        _rewardedVideo = MobileAds.getRewardedVideoAdInstance(ctx);
        this.adUnit = adUnit;
        _rewardedVideo.setRewardedVideoAdListener(new RewardedVideoAdListener() {
            public void onRewardedVideoAdLoaded() {
                loading = false;
                notifyOnLoaded();
            }

            public void onRewardedVideoAdOpened() {
                notifyOnShown();
            }

            public void onRewardedVideoStarted() {
            }

            public void onRewardedVideoAdClosed() {
                notifyOnDismissed();
            }

            public void onRewarded(RewardItem rewardItem) {
                AdRewardedVideo.Reward result = new AdRewardedVideo.Reward();
                result.amount = Math.max(rewardItem.getAmount(), 1);
                result.currency = rewardItem.getType();
                result.itmKey = rewardItem.getType();
                notifyOnRewardCompleted(result, null);
            }

            public void onRewardedVideoAdLeftApplication() {
                notifyOnClicked();
            }

            public void onRewardedVideoAdFailedToLoad(int errorCode) {
                loading = false;
                Error error = new Error();
                error.code = errorCode;
                error.message = "Error with code: " + errorCode;
                notifyOnFailed(error);
            }

            public void onRewardedVideoCompleted() {

            }
        });
    }

    @Override
    public void loadAd() {
        if (!loading) {
            loading = true;
            AdRequest adRequest;
            if (adsConsent) {
                Bundle extras = new Bundle();
                extras.putString("npa", "1");
                adRequest = new AdRequest.Builder().addNetworkExtrasBundle(AdMobAdapter.class, extras).build();
            } else {
                adRequest = new AdRequest.Builder().build();
            }

            _rewardedVideo.loadAd(adUnit, adRequest);
        }
    }

    @Override
    public void show() {
        if (_rewardedVideo.isLoaded()) {
            _rewardedVideo.show();
        } else {
            if (!loading) {
                loadAd();
            }
            AdRewardedVideo.Error error = new AdRewardedVideo.Error();
            error.message = "Rewarded video not ready yet";
            notifyOnRewardCompleted(null, error);
        }
    }

    @Override
    public void destroy() {

    }
}
