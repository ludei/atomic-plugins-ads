package com.ludei.ads.cordova;


import android.content.pm.PackageManager;

import com.jirbo.adcolony.AdColony;

import org.apache.cordova.CordovaPlugin;


public class AdColonyAdapterPlugin extends CordovaPlugin {
	
	@Override
	protected void pluginInitialize() {

        String appId = preferences.getString("ADCOLONY_ADAPTER_APP_ID", "");
        String zoneId = preferences.getString("ADCOLONY_ADAPTER_ZONE_ID", "");
        String versionName = "1.0";
        try {
            versionName = cordova.getActivity().getPackageManager().getPackageInfo(cordova.getActivity().getPackageName(), 0).versionName;
        }
        catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }
        String clientOptions = "version:" + versionName + ",store:google";
        AdColony.configure(cordova.getActivity(), clientOptions, appId, zoneId);
    }

    @Override
    public void onPause(boolean multitasking) {
        super.onPause(multitasking);
        AdColony.pause();
    }

    @Override
    public void onResume(boolean multitasking) {
        super.onResume(multitasking);
        AdColony.resume(cordova.getActivity());
    }
};