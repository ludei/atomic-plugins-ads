package com.ludei.ads.admob;


import android.app.Activity;
import android.content.Context;

import com.google.android.gms.ads.AdListener;
import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.InterstitialAd;
import com.ludei.ads.AbstractAdInterstitial;

class AdInterstitialAdMob extends AbstractAdInterstitial
{
    private InterstitialAd _interstitial;

    AdInterstitialAdMob(Context ctx, String adunit) {
        _interstitial = new InterstitialAd(ctx);
        _interstitial.setAdUnitId(adunit);
        _interstitial.setAdListener(new AdListener() {
            @Override
            public void onAdClosed() {
                notifyOnDismissed();
            }

            @Override
            public void onAdFailedToLoad(int errorCode) {
                notifyOnFailed(errorCode, "Error with code: " + errorCode);
            }

            @Override
            public void onAdLeftApplication() {
                notifyOnClicked();
            }

            @Override
            public void onAdOpened() {
                notifyOnShown();
            }

            @Override
            public void onAdLoaded() {
                notifyOnLoaded();
            }
        });

    }

    @Override
    public void loadAd() {
        _interstitial.loadAd(new AdRequest.Builder().build());
    }

    @Override
    public void show() {
        if (_interstitial.isLoaded()) {
            _interstitial.show();
        }
        else {
            loadAd();
        }

    }

    @Override
    public void destroy() {

    }
}
