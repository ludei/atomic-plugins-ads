package com.ludei.ads.cordova;

import android.util.Log;
import com.applovin.sdk.AppLovinPrivacySettings;
import org.apache.cordova.CordovaPlugin;

public class AppLovinAdapterPlugin extends CordovaPlugin {

    @Override
    public Object onMessage(String id, Object data) {
        if (id.equals("AdMob consent")) {
            Log.d("AppLovin", "Setting AppLovin user consent as: " + data);
            AppLovinPrivacySettings.setHasUserConsent((Boolean) data, cordova.getActivity());
        }
        return null;
    }
}
