package com.ludei.ads.admob;

import android.content.Context;
import android.os.Bundle;
import com.google.ads.mediation.admob.AdMobAdapter;
import com.google.android.gms.ads.AdListener;
import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.InterstitialAd;
import com.ludei.ads.AbstractAdInterstitial;

class AdInterstitialAdMob extends AbstractAdInterstitial {
    private InterstitialAd _interstitial;
    private Bundle extras;

    AdInterstitialAdMob(Context ctx, String adUnit, Bundle personalizedAdsConsent) {
        extras = personalizedAdsConsent;

        _interstitial = new InterstitialAd(ctx);
        _interstitial.setAdUnitId(adUnit);
        _interstitial.setAdListener(new AdListener() {
            @Override
            public void onAdClosed() {
                notifyOnDismissed();
            }

            @Override
            public void onAdFailedToLoad(int errorCode) {
                Error error = new Error();
                error.code = errorCode;
                error.message = "Error with code: " + errorCode;
                notifyOnFailed(error);
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
        _interstitial.loadAd(new AdRequest.Builder().addNetworkExtrasBundle(AdMobAdapter.class, extras).build());
    }

    @Override
    public void show() {
        if (_interstitial.isLoaded()) {
            _interstitial.show();
        } else {
            loadAd();
        }

    }

    @Override
    public void destroy() {

    }
}
