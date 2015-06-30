package com.ludei.adtest;

import android.app.Activity;

import com.ludei.ads.AdService;
import com.ludei.ads.chartboost.AdServiceChartboost;

public class AdServiceCreator {

    public static AdService create(Activity activity) {
        AdServiceChartboost service = new AdServiceChartboost();
        service.init(activity, APP_ID, APP_SIGNATURE);
        return service;
    }
}
