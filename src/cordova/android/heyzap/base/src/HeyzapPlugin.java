package com.ludei.ads.cordova;

import com.ludei.ads.heyzap.*;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaArgs;

public class HeyzapPlugin extends AdServicePlugin {
	
	@Override
	protected void pluginInitialize() {
		
		AdServiceHeyzap hz = new AdServiceHeyzap();

		String publishedId= preferences.getString("publisherId", null);
		hz.init(this.cordova.getActivity(), publishedId);
	
		_service = hz;
    }

	@SuppressWarnings("unused")
	public void showDebug(CordovaArgs args, CallbackContext ctx) {
		((AdServiceHeyzap)this._service).showDebug();
	}
};