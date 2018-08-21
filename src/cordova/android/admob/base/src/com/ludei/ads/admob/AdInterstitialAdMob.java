package com.ludei.ads.admob;

import android.content.Context;
import android.os.Bundle;
import com.google.ads.mediation.admob.AdMobAdapter;
import com.google.android.gms.ads.AdListener;
import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.InterstitialAd;
import com.ludei.ads.AbstractAdInterstitial;

public class AdInterstitialAdMob extends AbstractAdInterstitial {
    private InterstitialAd _interstitial;
    private boolean adsConsent;

    AdInterstitialAdMob(Context ctx, String adUnit, boolean personalizedAdsConsent) {
        adsConsent = personalizedAdsConsent;

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
        AdRequest adRequest;
        if (!adsConsent) {
            Bundle extras = new Bundle();
            extras.putString("npa", "1");
            adRequest = new AdRequest.Builder().addNetworkExtrasBundle(AdMobAdapter.class, extras).build();
        } else {
            adRequest = new AdRequest.Builder().build();
        }

        _interstitial.loadAd(adRequest);
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
