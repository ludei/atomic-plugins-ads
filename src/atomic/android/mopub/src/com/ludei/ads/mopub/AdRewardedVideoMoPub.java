package com.ludei.ads.mopub;


import android.app.Activity;
import android.content.Context;

import com.ludei.ads.AbstractAdInterstitial;
import com.ludei.ads.AdInterstitial;
import com.mopub.common.MoPub;
import com.mopub.common.MoPubReward;
import com.mopub.mobileads.MoPubErrorCode;
import com.mopub.mobileads.MoPubInterstitial;
import com.mopub.mobileads.MoPubRewardedVideoListener;
import com.mopub.mobileads.MoPubRewardedVideoManager;

import java.util.Set;

class AdRewardedVideoMoPub extends AbstractAdInterstitial implements MoPubRewardedVideoListener {
    private String adUnit;
    private static boolean mopubInitialized = false;
    private boolean rewardCompleted = false;

    AdRewardedVideoMoPub(Context ctx, String adUnit) {
        this.adUnit = adUnit;
        MoPub.setRewardedVideoListener(this);
    }

    @Override
    public void loadAd() {
        MoPub.loadRewardedVideo(this.adUnit);
    }

    @Override
    public void show() {
        rewardCompleted = false;
        if (MoPub.hasRewardedVideo(adUnit)) {
            MoPub.showRewardedVideo(adUnit);
        } else {
            MoPub.loadRewardedVideo(adUnit);
            AdInterstitial.Error error = new AdInterstitial.Error();
            error.message = "Rewarded Video not ready yet";
            notifyOnRewardCompleted(null, error);
        }
    }

    @Override
    public void destroy() {

    }

    @Override
    public void onRewardedVideoLoadSuccess(String adUnitId) {
        notifyOnLoaded();
    }

    @Override
    public void onRewardedVideoLoadFailure(String adUnitId, MoPubErrorCode errorCode) {
        AdInterstitial.Error error = new AdInterstitial.Error();
        error.code = errorCode.ordinal();
        error.message = errorCode.toString();
        notifyOnFailed(error);
    }

    @Override
    public void onRewardedVideoStarted(String adUnitId) {
        notifyOnShown();
    }

    @Override
    public void onRewardedVideoPlaybackError(String adUnitId, MoPubErrorCode errorCode) {
        rewardCompleted = true;
        AdInterstitial.Error error = new AdInterstitial.Error();
        error.code = errorCode.ordinal();
        error.message = errorCode.toString();
        notifyOnRewardCompleted(null, error);
    }

    @Override
    public void onRewardedVideoClosed(String adUnitId) {
        notifyOnDismissed();
        if (!rewardCompleted) {
            AdInterstitial.Error error = new AdInterstitial.Error();
            error.message = "Rewarded video closed or skipped";
            notifyOnRewardCompleted(null, error);
        }
    }

    @Override
    public void onRewardedVideoCompleted(Set<String> adUnitIds, MoPubReward reward) {
        rewardCompleted = true;
        AdInterstitial.Reward result = new AdInterstitial.Reward();
        result.amount = Math.max(reward.getAmount(), 1);
        result.currency = reward.getLabel();

        notifyOnRewardCompleted(result, null);
    }

   /* @Override
    public void onInterstitialLoaded(MoPubInterstitial interstitial) {
        notifyOnLoaded();
    }

    @Override
    public void onInterstitialFailed(MoPubInterstitial interstitial, MoPubErrorCode errorCode) {
        AdInterstitial.Error error = new AdInterstitial.Error();
        error.code = errorCode.ordinal();
        error.message = errorCode.toString();
        notifyOnFailed(error);
    }

    @Override
    public void onInterstitialShown(MoPubInterstitial interstitial) {
        notifyOnShown();
    }

    @Override
    public void onInterstitialClicked(MoPubInterstitial interstitial) {
        notifyOnClicked();
    }

    @Override
    public void onInterstitialDismissed(MoPubInterstitial interstitial) {
        notifyOnDismissed();
    }*/
}
