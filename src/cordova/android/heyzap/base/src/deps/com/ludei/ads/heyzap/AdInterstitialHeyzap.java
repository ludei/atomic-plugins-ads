package com.ludei.ads.heyzap;


import android.app.Activity;

import com.heyzap.sdk.ads.HeyzapAds;
import com.heyzap.sdk.ads.VideoAd;
import com.ludei.ads.AbstractAdInterstitial;

class AdInterstitialHeyzap extends AbstractAdInterstitial implements HeyzapAds.OnStatusListener
{
    private Activity _activity;
    private String _tag;

    AdInterstitialHeyzap(Activity activity, String tag) {
        this._activity = activity;

        VideoAd.setOnStatusListener(this);
    }

    @Override
    public void loadAd() {
        VideoAd.fetch(this._tag);
    }

    @Override
    public void show() {
        if (VideoAd.isAvailable()) {
            VideoAd.display(this._activity);
        }
    }

    @Override
    public void destroy() {

    }

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
        notifyOnFailed(-1, tag);
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
}
