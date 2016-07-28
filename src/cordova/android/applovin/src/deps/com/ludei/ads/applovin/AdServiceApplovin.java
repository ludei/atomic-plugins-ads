package com.ludei.ads.applovin;

import android.app.Activity;
import android.content.Context;

import com.applovin.sdk.AppLovinSdk;

public class AdServiceApplovin implements AdService {


    public AdServiceApplovin()
    {
    }

    public void init(Activity activity)
    {
        AppLovinSdk.initializeSdk(activity);
    }

    @Override
    public AdInterstitial createInterstitial(Context ctx) {
        return createInterstitial(ctx, null);
    }

    @Override
    public AdInterstitial createInterstitial(Context ctx, String adunit) {
        if (adunit == null || adunit.length() == 0) {
            adunit = "";
        }
        AdInterstitialApplovin cb = new AdInterstitialApplovin(ctx, false);
        return cb;
    }


}
