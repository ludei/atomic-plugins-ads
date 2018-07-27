package com.ludei.ads.cordova;

import android.content.pm.PackageManager;

import com.adcolony.sdk.AdColony;
import com.adcolony.sdk.AdColonyAppOptions;
import org.apache.cordova.CordovaPlugin;
import com.ludei.ads.admob.AdServiceAdMob;

public class AdColonyAdapterPlugin extends CordovaPlugin {

    @Override
    public Object onMessage(String id, Object data) {
        if (id.equals("AdMob consent") && ((Boolean) data)) {
            String appId = preferences.getString("ADCOLONY_ADAPTER_APP_ID", "");
            String zoneId = preferences.getString("ADCOLONY_ADAPTER_ZONE_ID", "");

            String appVersion = "1.0";
            try {
                appVersion = cordova.getActivity().getPackageManager().getPackageInfo(cordova.getActivity().getPackageName(), 0).versionName;
            } catch (PackageManager.NameNotFoundException e) {
                e.printStackTrace();
            }

            AdColonyAppOptions clientOptions = new AdColonyAppOptions().setAppVersion(appVersion);
            if (AdServiceAdMob._personalizedAdsConsent) {
                clientOptions.setGDPRConsentString("1")
                    .setGDPRRequired(true);
            }
            AdColony.configure(cordova.getActivity(), clientOptions, appId, zoneId);
        }
        return null;
    }

    @Override
    public void onPause(boolean multitasking) {
        super.onPause(multitasking);
    }

    @Override
    public void onResume(boolean multitasking) {
        super.onResume(multitasking);
    }
}
