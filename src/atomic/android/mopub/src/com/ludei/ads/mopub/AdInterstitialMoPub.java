package com.ludei.ads.mopub;


import android.app.Activity;
import android.content.Context;

import com.ludei.ads.AbstractAdInterstitial;
import com.ludei.ads.AdInterstitial;
import com.mopub.mobileads.MoPubErrorCode;
import com.mopub.mobileads.MoPubInterstitial;
import com.mopub.mobileads.MoPubRewardedVideoManager;

class AdInterstitialMoPub extends AbstractAdInterstitial implements MoPubInterstitial.InterstitialAdListener
{
    private MoPubInterstitial _interstitial;

    AdInterstitialMoPub(Context ctx, String adunit) {
        _interstitial = new MoPubInterstitial((Activity)ctx, adunit);
        _interstitial.setInterstitialAdListener(this);

    }

    @Override
    public void loadAd() {
        _interstitial.load();
    }

    @Override
    public void show() {
        if (_interstitial.isReady()) {
            _interstitial.show();
        }
        else {
            _interstitial.load();
        }

    }

    @Override
    public void destroy() {
        _interstitial.destroy();
    }

    @Override
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
    }
}
