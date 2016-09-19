package com.ludei.ads.heyzap;


import android.app.Activity;

import com.heyzap.sdk.ads.HeyzapAds;
import com.heyzap.sdk.ads.IncentivizedAd;
import com.ludei.ads.AbstractAdInterstitial;

class AdRewardedHeyzap extends AbstractAdInterstitial implements HeyzapAds.OnStatusListener, HeyzapAds.OnIncentiveResultListener
{
    private Activity _activity;
    private String _tag;

    AdRewardedHeyzap(Activity activity, String tag) {
        this._tag = tag;
        this._activity = activity;

        IncentivizedAd.setOnStatusListener(this);
        IncentivizedAd.setOnIncentiveResultListener(this);
    }

    @Override
    public void loadAd() {
        IncentivizedAd.fetch(this._tag);
    }

    @Override
    public void show() {
        if (IncentivizedAd.isAvailable()) {
            IncentivizedAd.display(this._activity);
        }
    }

    @Override
    public void destroy() {

    }

    // OnStatusListener

    @Override
    public void onShow(String tag) {
        notifyOnShown();
    }

    @Override
    public void onClick(String tag) {
        notifyOnClicked();
    }

    @Override
    public void onHide(String tag) {
        notifyOnDismissed();
    }

    @Override
    public void onFailedToShow(String tag) {
        Error error = new Error();
        error.code = -1;
        error.message = "Rewarded video failed to show";
        notifyOnFailed(error);
    }

    @Override
    public void onAvailable(String tag) {
        notifyOnLoaded();
    }

    @Override
    public void onFailedToFetch(String tag) {

    }

    @Override
    public void onAudioStarted() {

    }

    @Override
    public void onAudioFinished() {

    }

    // OnIncentiveResultListener

    @Override
    public void onComplete(String tag) {
        Reward reward = new Reward();
        reward.amount = 1;
        reward.itmKey = tag;

        notifyOnRewardCompleted(reward, null);
    }

    @Override
    public void onIncomplete(String tag) {
        Reward reward = new Reward();
        reward.amount = 0;
        reward.itmKey = tag;

        Error error = new Error();
        error.code = -1;
        error.message = "Rewarded video incomplete";
        notifyOnRewardCompleted(reward, error);
    }
}
