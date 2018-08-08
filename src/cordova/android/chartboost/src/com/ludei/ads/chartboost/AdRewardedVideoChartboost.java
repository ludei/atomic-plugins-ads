package com.ludei.ads.chartboost;

import com.chartboost.sdk.Chartboost;
import com.ludei.ads.AbstractAdRewardedVideo;

class AdRewardedVideoChartboost extends AbstractAdRewardedVideo {
    private String _location;

    AdRewardedVideoChartboost(String adUnit) {
        this._location = adUnit;
    }

    @Override
    public void loadAd() {
        Chartboost.cacheRewardedVideo(_location);
    }

    @Override
    public void show() {
        Chartboost.showRewardedVideo(_location);
    }

    @Override
    public void destroy() {

    }
}
