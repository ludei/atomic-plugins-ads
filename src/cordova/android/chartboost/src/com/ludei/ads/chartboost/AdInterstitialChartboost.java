package com.ludei.ads.chartboost;

import com.chartboost.sdk.Chartboost;
import com.ludei.ads.AbstractAdInterstitial;

class AdInterstitialChartboost extends AbstractAdInterstitial {
    private String _location;

    AdInterstitialChartboost(String adUnit) {
        this._location = adUnit;
    }

    @Override
    public void loadAd() {
        Chartboost.cacheInterstitial(_location);
    }

    @Override
    public void show() {
        Chartboost.showInterstitial(_location);
    }

    @Override
    public void destroy() {

    }
}
