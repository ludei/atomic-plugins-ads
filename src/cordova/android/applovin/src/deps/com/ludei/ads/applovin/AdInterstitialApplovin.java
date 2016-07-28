package com.ludei.ads.applovin;

import android.app.Activity;
import android.content.Context;

import com.applovin.adview.AppLovinInterstitialAd;

public class AdInterstitialApplovin implements AdService {


    AdInterstitialApplovin(Context ctx, String adunit) {
        
    }

    @Override
    public void show() {
        if (AppLovinInterstitialAd.isAdReadyToDisplay()) {
            AppLovinInterstitialAd.show();
        }
    }


}
