package com.ludei.ads.cordova;

import com.ludei.ads.heyzap.*;

public class HeyzapPlugin extends AdServicePlugin {
	
	@Override
	protected void pluginInitialize() {
		
		AdServiceHeyzap hz = new AdServiceHeyzap();

		String publishedId= preferences.getString("publisherId", null);
		hz.init(this.cordova.getActivity(), publishedId);
	
		_service = hz;
    }
};