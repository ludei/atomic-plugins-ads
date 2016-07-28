package com.ludei.ads.cordova;

import com.applovin.sdk.AppLovinSdk;

public class ApplovinPlugin extends AdServicePlugin {

    
    @Override
    protected void pluginInitialize() {
        AppLovinSdk.initializeSdk(cordova.getActivity());
    }

    @Override
    public void onPause(boolean multitasking) {
        super.onPause(multitasking);
    }

    @Override
    public void onResume(boolean multitasking) {
        super.onResume(multitasking);
    }

    @Override
    public void onStart() {
        super.onStart();
    }

    @Override
    public void onStop() {
        
    }

    @Override
    public void onDestroy() {
        
    }
}