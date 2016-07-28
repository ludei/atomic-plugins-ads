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


}
