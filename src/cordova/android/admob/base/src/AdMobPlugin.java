package com.ludei.ads.cordova;

import com.ludei.ads.admob.*;

public class AdMobPlugin extends AdServicePlugin {
	
	@Override
	protected void pluginInitialize() {
		
		AdServiceAdMob mp = new AdServiceAdMob();
		
		String banner= preferences.getString("admob_banner", null);
		String interstitial = preferences.getString("admob_interstitial", null);
		mp.configure(banner, interstitial);
	
		_service = mp;
    }
};