package com.ludei.ads.cordova;

import com.ludei.ads.mopub.AdServiceMoPub;

public class MoPubPlugin extends AdServicePlugin {

    @Override
    protected void pluginInitialize() {

        AdServiceMoPub mp = new AdServiceMoPub();

        String banner = preferences.getString("mopub_banner", null);
        String interstitial = preferences.getString("mopub_interstitial", null);
        mp.configure(banner, interstitial);

        _service = mp;
    }
};
