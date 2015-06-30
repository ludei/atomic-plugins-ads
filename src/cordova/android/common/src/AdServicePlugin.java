package com.ludei.ads.cordova;
import java.lang.reflect.Method;
import java.util.HashMap;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaArgs;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;
import org.apache.cordova.PluginResult.Status;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;

import com.ludei.ads.*;
import com.ludei.ads.AdBanner.BannerSize;

public class AdServicePlugin extends CordovaPlugin implements AdBanner.BannerListener, AdInterstitial.InterstitialListener {
	
	
	protected AdService _service;
	protected HashMap<String, BannerData> _banners = new HashMap<String,BannerData>();
	protected HashMap<String, AdInterstitial> _interstitials = new HashMap<String, AdInterstitial>();
	protected CallbackContext _bannerListener;
	protected CallbackContext _interstitialListener;
	
	protected void pluginInitialize() {
		throw new RuntimeException("Override this method and create the InAppService instance");
    }
	
	
	private enum BannerLayout {
		TOP_CENTER,
		BOTTOM_CENTER,
		CUSTOM
	}
	private class BannerData {
		public AdBanner banner;
		public BannerLayout layout = BannerLayout.TOP_CENTER;
		public double x;
		public double y;
	}
	
	
	@Override
    public boolean execute(final String action, final CordovaArgs args, final CallbackContext callbackContext) throws JSONException {
		//Run everything in the Main Thread
		this.cordova.getActivity().runOnUiThread(new Runnable() {
			@Override
			public void run() {
				try {
					final Method method = AdServicePlugin.this.getClass().getMethod(action, CordovaArgs.class, CallbackContext.class);
					method.invoke(AdServicePlugin.this, args, callbackContext);
				} catch (Exception e) {
					e.printStackTrace();
				} 
			}
		});

		return true;
    }
	
	@Override
	public void onDestroy() {
		for (String key: _interstitials.keySet()) {
			AdInterstitial interstitial = _interstitials.get(key);
			interstitial.destroy();
		}

		for (String key: _banners.keySet()) {
			BannerData banner = _banners.get(key);
			banner.banner.destroy();
		}
	}
	
	public void configure(CordovaArgs args, CallbackContext ctx) {
		JSONObject obj = args.optJSONObject(0);
		if (obj == null) {
			return;
		}
		
		String banner = obj.optString("banner");
		String interstitial = obj.optString("interstitial");
		_service.configure(banner, interstitial);
		
		ctx.sendPluginResult(new PluginResult(Status.OK));
	}
	
	//Bridge methods
	public void setBannerListener(CordovaArgs args, CallbackContext ctx) {
		_bannerListener = ctx;
	}
	
	public void setInterstitialListener(CordovaArgs args, CallbackContext ctx) {
		_interstitialListener = ctx;
	}
	
	public void createBanner(CordovaArgs args, CallbackContext ctx) {
		
		String bannerId = getId(args);

		String adunit = args.isNull(1) ? null : args.optString(1);
		String strSize = args.isNull(2) ? null : args.optString(2);
		
		BannerSize size = BannerSize.SMART_SIZE;
		if (strSize != null) {
			if (strSize.equals("BANNER")) {
				size = BannerSize.BANNER_SIZE;
			}
			else if (strSize.equals("MEDIUM_RECT")) {
				size = BannerSize.MEDIUM_RECT_SIZE;
			}
			else if (strSize.equals("LEADERBOARD")) {
				size = BannerSize.LEADERBOARD_SIZE;
			}
		}
		
		AdBanner banner = _service.createBanner(this.cordova.getActivity(), adunit, size);
		banner.setListener(this);
		BannerData data = new BannerData();
		data.banner = banner;
		_banners.put(bannerId, data);
		ctx.sendPluginResult(new PluginResult(Status.OK));
	}
	
	public void createInterstitial(CordovaArgs args, CallbackContext ctx) {
		
		String interstitialId = getId(args);
		String adunit = args.isNull(1) ? null : args.optString(1);
		AdInterstitial interstitial = _service.createInterstitial(this.cordova.getActivity(), adunit);
		interstitial.setListener(this);
		_interstitials.put(interstitialId, interstitial);
		ctx.sendPluginResult(new PluginResult(Status.OK));
	}

	public void createRewardedVideo(CordovaArgs args, CallbackContext ctx) {

		String interstitialId = getId(args);
		String adunit = args.isNull(1) ? null : args.optString(1);
		AdInterstitial interstitial = _service.createRewardedVideo(this.cordova.getActivity(), adunit);
		interstitial.setListener(this);
		_interstitials.put(interstitialId, interstitial);
		ctx.sendPluginResult(new PluginResult(Status.OK));
	}
	
	public void releaseBanner(CordovaArgs args, CallbackContext ctx) {
		String bannerId = getId(args);
		BannerData data = _banners.get(bannerId);
		if (data != null) {
			data.banner.setListener(null);
			if (data.banner.getView().getParent() != null) {
				ViewGroup vg = getViewGroup();
				vg.removeView(data.banner.getView());
			}
			_banners.remove(bannerId);
		}
	}
	
	public void releaseInterstitial(CordovaArgs args, CallbackContext ctx) {
		String interstitialId = getId(args);
		AdInterstitial interstitial = _interstitials.get(interstitialId);
		if (interstitial != null) {
			interstitial.setListener(null);
			interstitial.destroy();
			_interstitials.remove(interstitialId);
		}
	}
	
	public void showBanner(CordovaArgs args, CallbackContext ctx) {
		BannerData data = _banners.get(getId(args));
		if (data != null && data.banner.getView() != null) {
			AdBanner banner = data.banner;
			banner.getView().setVisibility(View.VISIBLE);
			
	        if (banner.getView().getParent() == null) {
	            ViewGroup vg = getViewGroup();
	            FrameLayout.LayoutParams params = new FrameLayout.LayoutParams(FrameLayout.LayoutParams.WRAP_CONTENT, FrameLayout.LayoutParams.WRAP_CONTENT);
	            vg.addView(banner.getView(), params);
	        }
	        layoutBanner(data);
		}
	}
	
	public void hideBanner(CordovaArgs args, CallbackContext ctx) {
		BannerData data = _banners.get(getId(args));
		if (data != null && data.banner.getView() != null) {
			data.banner.getView().setVisibility(View.GONE);
		}
	}
	
	public void setBannerPosition(CordovaArgs args, CallbackContext ctx) {
		BannerData data = _banners.get(getId(args));
		if (data != null) {
			data.x = args.optDouble(1);
			data.y = args.optDouble(2);
			layoutBanner(data);
		}
	}
	
	public void setBannerLayout(CordovaArgs args, CallbackContext ctx) {
		BannerData data = _banners.get(getId(args));
		String value = args.optString(1);
		if (data != null) {
			if ("TOP_CENTER".equals(value)) {
				data.layout = BannerLayout.TOP_CENTER;
			}
			else if ("BOTTOM_CENTER".equals(value)) {
				data.layout = BannerLayout.BOTTOM_CENTER;
			}
			else{
				data.layout = BannerLayout.CUSTOM;
			}
			layoutBanner(data);
		}
	}
	
	public void loadBanner(CordovaArgs args, CallbackContext ctx) {
		BannerData data = _banners.get(getId(args));
		if (data != null) {
			data.banner.loadAd();
		}
	}
	
	public void showInterstitial(CordovaArgs args, CallbackContext ctx) {
		AdInterstitial interstitial = _interstitials.get(getId(args));
		if (interstitial != null) {
			interstitial.show();
		}
	}
	
	public void loadInterstitial(CordovaArgs args, CallbackContext ctx) {
		AdInterstitial interstitial = _interstitials.get(getId(args));
		if (interstitial != null) {
			interstitial.loadAd();
		}
	}

	
	//Ad Listeners
	
	@Override
    public void onLoaded(AdBanner banner) {
		String bannerId = findBannerId(banner);
		layoutBanner(_banners.get(bannerId));
        callListeners(_bannerListener, "load", bannerId, banner.getWidth(), banner.getHeight());
    }

    @Override
    public void onFailed(AdBanner banner, int errorCode, String errorMessage) {
        callListeners(_bannerListener, "fail", errorToJSON(errorCode, errorMessage));
    }

    @Override
    public void onClicked(AdBanner banner) {
    	callListeners(_bannerListener, "click", findBannerId(banner));
    }

    @Override
    public void onExpanded(AdBanner banner) {
    	callListeners(_bannerListener, "show", findBannerId(banner));
    }

    @Override
    public void onCollapsed(AdBanner banner) {
    	callListeners(_bannerListener, "dismiss", findBannerId(banner));
    }

    @Override
    public void onLoaded(AdInterstitial interstitial) {
    	callListeners(_interstitialListener, "load", findInterstitialId(interstitial));
    }

    @Override
    public void onFailed(AdInterstitial interstitial, int errorCode, String errorMessage) {
    	callListeners(_interstitialListener, "fail", findInterstitialId(interstitial), errorToJSON(errorCode, errorMessage));
    }

    @Override
    public void onClicked(AdInterstitial interstitial) {
    	callListeners(_interstitialListener, "click", findInterstitialId(interstitial));
    }

    @Override
    public void onShown(AdInterstitial interstitial) {
    	callListeners(_interstitialListener, "show", findInterstitialId(interstitial));
    }

    @Override
    public void onDismissed(AdInterstitial interstitial) {
    	callListeners(_interstitialListener, "dismiss", findInterstitialId(interstitial));
    }

	@Override
	public void onRewardCompleted(AdInterstitial interstitial, int quantity) {
		callListeners(_interstitialListener, "reward", findInterstitialId(interstitial), quantity);
	}

	//Utility methods
	
    
	protected void callListeners(CallbackContext ctx, Object... args) {
		JSONArray array = new JSONArray();
		for (Object obj: args) {
			array.put(obj);
		}
		PluginResult pluginResult = new PluginResult(Status.OK, array);
		pluginResult.setKeepCallback(true);
		ctx.sendPluginResult(pluginResult);
	}
	
	protected void layoutBanner(BannerData data) {
		if (data.banner == null || data.banner.getView().getParent() == null) {
            return;
        }

        ViewGroup vg = getViewGroup();
        FrameLayout.LayoutParams layoutParams = (FrameLayout.LayoutParams)data.banner.getView().getLayoutParams();
        layoutParams.width = data.banner.getWidth();
        layoutParams.height = data.banner.getHeight();
        
        if (data.layout == BannerLayout.CUSTOM) {
        	layoutParams.leftMargin = (int)data.x;
        	layoutParams.topMargin = (int)data.y;
        }
        else if (data.layout == BannerLayout.TOP_CENTER) {
            layoutParams.leftMargin = (int)(vg.getWidth() * 0.5 - layoutParams.width * 0.5);
            layoutParams.topMargin = 0;
        }
        else {
            layoutParams.leftMargin = (int)(vg.getWidth() * 0.5 - layoutParams.width * 0.5);
            layoutParams.topMargin = vg.getHeight() - layoutParams.height;
        }
        vg.requestLayout();
	}
	
	protected ViewGroup getViewGroup() {
		return (ViewGroup) this.cordova.getActivity().getWindow().getDecorView().findViewById(android.R.id.content);
	}
	protected JSONObject errorToJSON(int code, String message) {
		JSONObject result = new JSONObject();
		try {
			result.put("code", code);
			result.put("message", message);
		} catch (JSONException e) {
			e.printStackTrace();
		}
		return result;
	}
	
	protected String findBannerId(AdBanner banner) {
		for (String key: _banners.keySet()) {
			BannerData data = _banners.get(key);
			if (data.banner == banner) {
				return key;
			}
		}
		return "";	
	}
	
	protected String findInterstitialId(AdInterstitial interstitial) {
		for (String key: _interstitials.keySet()) {
			if (_interstitials.get(key) == interstitial) {
				return key;
			}
		}
		return "";	
	}
	
	protected String getId(CordovaArgs args) {
		return args.optString(0);
	}

};