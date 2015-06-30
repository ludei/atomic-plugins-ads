package com.ludei.ads.chartboost;

import android.content.Context;

import com.chartboost.sdk.Chartboost;
import com.chartboost.sdk.ChartboostDelegate;
import com.ludei.ads.AbstractAdInterstitial;

class AdInterstitialChartboost extends AbstractAdInterstitial
{
    private String _location;
    private boolean _reward;

    AdInterstitialChartboost(String adunit, Boolean reward) {

        this._location = adunit;
        this._reward = reward;
    }

    @Override
    public void loadAd() {
        if (_reward) {
            Chartboost.cacheRewardedVideo(_location);
        }
        else {
            Chartboost.cacheInterstitial(_location);
        }
    }

    @Override
    public void show() {
        if (_reward) {
            Chartboost.showRewardedVideo(_location);
        }
        else {
            Chartboost.showInterstitial(_location);
        }

    }

    @Override
    public void destroy() {

    }
}
