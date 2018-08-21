package com.ludei.ads.cordova;

import android.content.pm.PackageManager;
import android.util.Log;
import com.adcolony.sdk.AdColony;
import com.adcolony.sdk.AdColonyAppOptions;
import org.apache.cordova.CordovaPlugin;

public class AdColonyAdapterPlugin extends CordovaPlugin {

    @Override
    public Object onMessage(String id, Object data) {
        if (id.equals("AdMob consent")) {
            Log.d("AdColony", "Setting AdColony user consent as: " + data);

            String appId = preferences.getString("ADCOLONY_ADAPTER_APP_ID", "");
            String zoneId = preferences.getString("ADCOLONY_ADAPTER_ZONE_ID", "");

            String appVersion = "1.0";
            try {
                appVersion = cordova.getActivity().getPackageManager().getPackageInfo(cordova.getActivity().getPackageName(), 0).versionName;
            } catch (PackageManager.NameNotFoundException e) {
                e.printStackTrace();
            }

            AdColonyAppOptions clientOptions = new AdColonyAppOptions().setAppVersion(appVersion);
            if ((Boolean) data) {
                clientOptions.setGDPRConsentString("1")
                    .setGDPRRequired(true);
            }
            AdColony.configure(cordova.getActivity(), clientOptions, appId, zoneId);
        }
        return null;
    }
}
