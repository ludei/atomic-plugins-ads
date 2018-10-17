package com.ludei.ads.cordova;

import com.ludei.ads.mopub.AdServiceMoPub;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaArgs;
import org.json.JSONObject;

public class MoPubPlugin extends AdServicePlugin {

    @Override
    protected void pluginInitialize() {
        _service = new AdServiceMoPub();
    }

    public void configure(CordovaArgs args, CallbackContext ctx) {
        JSONObject obj = args.optJSONObject(0);
        if (obj == null) {
            return;
        }

        _service.configure(cordova.getActivity(), obj);
    }
}
