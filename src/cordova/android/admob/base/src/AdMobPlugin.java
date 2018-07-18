package com.ludei.ads.cordova;

import com.ludei.ads.admob.AdServiceAdMob;
import com.ludei.ads.cordova.AdServicePlugin;

public class AdMobPlugin extends AdServicePlugin {

    @Override
    protected void pluginInitialize() {

        AdServiceAdMob mp = new AdServiceAdMob();

        String banner = preferences.getString("admob_banner", null);
        String interstitial = preferences.getString("admob_interstitial", null);
        mp.configure(banner, interstitial);

        _service = mp;
    }

    public void configure(CordovaArgs args, CallbackContext ctx) {
        JSONObject obj = args.optJSONObject(0);
        if (obj == null) {
            return;
        }

        String appId = obj.optString("appId");
        String banner = obj.optString("banner");
        String interstitial = obj.optString("interstitial");
        String personalizedAdsConsent = obj.optBoolean("personalizedAdsConsent");
        if (appId == null || banner == null || interstitial == null) {
            ctx.error("Invalid settings");
            return;
        }

        _service.init(cordova.getActivity(), appId, banner, interstitial, personalizedAdsConsent);
        _service.onStart(cordova.getActivity());

        ctx.sendPluginResult(new PluginResult(Status.OK));
    }

};
