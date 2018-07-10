package com.ludei.ads.cordova;

import com.chartboost.sdk.Chartboost;

import org.apache.cordova.CordovaPlugin;


public class ChartboostAdapterPlugin extends CordovaPlugin {

    @Override
    public void onStart() {
        super.onStart();
        Chartboost.onStart(cordova.getActivity());
    }

    @Override
    public void onResume(boolean multitasking) {
        super.onResume(multitasking);
        Chartboost.onResume(cordova.getActivity());
    }

    @Override
    public void onPause(boolean multitasking) {
        super.onPause(multitasking);
        Chartboost.onPause(cordova.getActivity());
    }

    @Override
    public void onStop() {
        super.onStop();
        Chartboost.onStop(cordova.getActivity());
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        Chartboost.onDestroy(cordova.getActivity());
    }
};
