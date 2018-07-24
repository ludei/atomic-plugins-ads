package com.ludei.ads.cordova;

import com.ludei.ads.admob.AdServiceAdMob;
import android.util.Log;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaArgs;
import org.apache.cordova.PluginResult;
import org.apache.cordova.PluginResult.Status;
import org.json.JSONObject;

public class AdMobPlugin extends AdServicePlugin {

    @Override
    protected void pluginInitialize() {
        _service = new AdServiceAdMob();
    }
}
