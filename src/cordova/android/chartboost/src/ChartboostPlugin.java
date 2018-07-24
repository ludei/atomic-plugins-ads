package com.ludei.ads.cordova;

import com.ludei.ads.chartboost.AdServiceChartboost;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaArgs;
import org.json.JSONObject;

public class ChartboostPlugin extends AdServicePlugin {

    @Override
    protected void pluginInitialize() {
        _service = new AdServiceChartboost();
    }

    public void configure(CordovaArgs args, CallbackContext ctx) {
        JSONObject obj = args.optJSONObject(0);
        if (obj == null) {
            return;
        }

        String appId = obj.optString("appId");
        String appSignature = obj.optString("appSignature");
        String personalizedAdsConsent = obj.optBoolean("personalizedAdsConsent");
        if (appId == null || appSignature == null) {
            ctx.error("Invalid settings");
            return;
        }

        ((AdServiceChartboost) (_service)).init(cordova.getActivity(), appId, appSignature, personalizedAdsConsent);
        ((AdServiceChartboost) (_service)).onStart(cordova.getActivity());

        ctx.success();
    }


    @Override
    public void onPause(boolean multitasking) {
        super.onPause(multitasking);
        ((AdServiceChartboost) (_service)).onPause(cordova.getActivity());
    }

    @Override
    public void onResume(boolean multitasking) {
        super.onResume(multitasking);
        ((AdServiceChartboost) (_service)).onResume(cordova.getActivity());
    }

    @Override
    public void onStart() {
        super.onStart();
        ((AdServiceChartboost) (_service)).onStart(cordova.getActivity());
    }

    @Override
    public void onStop() {
        super.onStop();
        ((AdServiceChartboost) (_service)).onStop(cordova.getActivity());
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        ((AdServiceChartboost) (_service)).onDestroy(cordova.getActivity());
    }

    @Override
    public void onBackPressed() {
        // If an interstitial is on screen, close it.
        if (!((AdServiceChartboost) (_service)).onBackPressed())
            super.onBackPressed();
    }
}
