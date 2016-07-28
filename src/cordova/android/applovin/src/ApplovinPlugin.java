package com.ludei.ads.cordova;

import com.ludei.ads.applovin.AdServiceApplovin;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaArgs;
import org.json.JSONObject;

public class ApplovinPlugin extends AdServicePlugin {

    protected AdServiceApplovin _cbService;
    @Override
    protected void pluginInitialize() {
        _cbService = new AdServiceApplovin();
        _cbService.init(cordova.getActivity());
        _service = _cbService;
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
        _cbService.onStart(cordova.getActivity());
    }

    @Override
    public void onStop() {
        
    }

    @Override
    public void onDestroy() {
        
    }
}