package com.ludei.ads.cordova;

import com.ludei.ads.chartboost.AdServiceChartboost;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaArgs;
import org.json.JSONObject;

public class ChartboostPlugin extends AdServicePlugin {

    protected AdServiceChartboost _cbService;
    @Override
    protected void pluginInitialize() {
        _cbService = new AdServiceChartboost();
        _service = _cbService;
    }

    public void configure(CordovaArgs args, CallbackContext ctx) {
        JSONObject obj = args.optJSONObject(0);
        if (obj == null) {
            return;
        }

        String appId = obj.optString("appId");
        String appSignature = obj.optString("appSignature");
        if (appId == null || appSignature == null) {
            ctx.error("Invalid settings");
            return;
        }

        _cbService.init(cordova.getActivity(), appId, appSignature);
        _cbService.onStart(cordova.getActivity());

        ctx.success();
    }


    @Override
    public void onPause(boolean multitasking) {
        super.onPause(multitasking);
        _cbService.onPause(cordova.getActivity());
    }

    @Override
    public void onResume(boolean multitasking) {
        super.onResume(multitasking);
        _cbService.onResume(cordova.getActivity());
    }

    @Override
    public void onStart() {
        super.onStart();
        _cbService.onStart(cordova.getActivity());
    }

    @Override
    public void onStop() {
        _cbService.onStop(cordova.getActivity());
    }

    @Override
    public void onDestroy() {
        _cbService.onDestroy(cordova.getActivity());
    }
}