package com.ludei.ads.cordova;

import android.util.Log;
import com.unity3d.ads.metadata.MetaData;
import org.apache.cordova.CordovaPlugin;

public class UnityAdsAdapterPlugin extends CordovaPlugin {

    @Override
    public Object onMessage(String id, Object data) {
        if (id.equals("AdMob consent")) {
            Log.d("UnityAds", "Setting UnityAds user consent as: " + data);

            MetaData gdprMetaData = new MetaData(cordova.getActivity());
            gdprMetaData.set("gdpr.consent", (Boolean) data);
            gdprMetaData.commit();
        }
        return null;
    }
}
