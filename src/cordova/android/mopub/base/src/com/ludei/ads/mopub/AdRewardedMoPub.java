package com.ludei.ads.mopub;

import android.content.Context;
import android.support.annotation.NonNull;
import com.ludei.ads.AbstractAdRewardedVideo;
import com.ludei.ads.AdRewardedVideo;
import com.mopub.common.MoPubReward;
import com.mopub.mobileads.MoPubErrorCode;
import com.mopub.mobileads.MoPubRewardedVideoListener;
import com.mopub.mobileads.MoPubRewardedVideos;

import java.util.Set;

class AdRewardedMoPub extends AbstractAdRewardedVideo implements MoPubRewardedVideoListener {
    private String adUnit;
    private boolean rewardCompleted = false;

    AdRewardedMoPub(Context ctx, String adUnit) {
        this.adUnit = adUnit;
        MoPubRewardedVideos.setRewardedVideoListener(this);
    }

    @Override
    public void loadAd() {
        MoPubRewardedVideos.loadRewardedVideo(this.adUnit);
    }

    @Override
    public void show() {
        rewardCompleted = false;
        if (MoPubRewardedVideos.hasRewardedVideo(adUnit)) {
            MoPubRewardedVideos.showRewardedVideo(adUnit);
        } else {
            MoPubRewardedVideos.loadRewardedVideo(adUnit);
            AdRewardedVideo.Error error = new AdRewardedVideo.Error();
            error.message = "Rewarded video not ready yet";
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
        AdRewardedVideo.Error error = new AdRewardedVideo.Error();
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
        AdRewardedVideo.Error error = new AdRewardedVideo.Error();
        error.code = errorCode.ordinal();
        error.message = errorCode.toString();
        notifyOnRewardCompleted(null, error);
    }

    @Override
    public void onRewardedVideoClicked(@NonNull String adUnitId) {

    }

    @Override
    public void onRewardedVideoClosed(String adUnitId) {
        notifyOnDismissed();
        if (!rewardCompleted) {
            AdRewardedVideo.Error error = new AdRewardedVideo.Error();
            error.message = "Rewarded video closed or skipped";
            notifyOnRewardCompleted(null, error);
        }
    }

    @Override
    public void onRewardedVideoCompleted(Set<String> adUnitIds, MoPubReward reward) {
        rewardCompleted = true;
        AdRewardedVideo.Reward result = new AdRewardedVideo.Reward();
        result.amount = Math.max(reward.getAmount(), 1);
        result.currency = reward.getLabel();

        notifyOnRewardCompleted(result, null);
    }
}
