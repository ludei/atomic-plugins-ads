package com.ludei.ads.cpp;

import android.app.Activity;
import android.content.Intent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;

import com.ludei.ads.*;
import com.safejni.SafeJNI;

import java.util.HashMap;

public class AdServiceBridge implements AdBanner.BannerListener, AdInterstitial.InterstitialListener, SafeJNI.ActivityLifeCycleListener {


    private Activity _activity;
    private AdService _service;
    protected HashMap<Long, BannerData> _banners = new HashMap<>();
    protected HashMap<Long, AdInterstitial> _interstitials = new HashMap<>();

    public AdServiceBridge() {

    }

    public boolean init(String adServiceClassName) {

        try {
            Class<?> adServiceClass = Class.forName(adServiceClassName);
            _service = (AdService)adServiceClass.newInstance();
            _activity = SafeJNI.INSTANCE.getActivity();
            SafeJNI.INSTANCE.addLifeCycleListener(this);
        }
        catch (Exception ex) {
            return false;
        }

        return true;
    }

    private enum BannerLayout {
        TOP_CENTER,
        BOTTOM_CENTER,
        CUSTOM
    }
    private class BannerData {
        public AdBanner banner;
        public BannerLayout layout = BannerLayout.TOP_CENTER;
        public float x;
        public float y;
    }

    protected void runOnThread(Runnable runnable) {
        _activity.runOnUiThread(runnable);
    }

    protected void dispatchNative(Runnable runnable) {
        SafeJNI.INSTANCE.dispatchToNative(runnable);
    }


    public void nativeDestructor() {
        runOnThread(new Runnable() {
            @Override
            public void run() {
                onDestroy();
            }
        });
    }

    public void configure(final String banner, final String interstitial) {
        runOnThread(new Runnable() {
            @Override
            public void run() {
                _service.configure(banner, interstitial);
            }
        });
    }

    public void createBanner(final long bannerId, final String adunit, final String strSize) {

        runOnThread(new Runnable() {
            @Override
            public void run() {

                AdBanner.BannerSize size = AdBanner.BannerSize.SMART_SIZE;
                if (strSize != null) {
                    if (strSize.equals("BANNER")) {
                        size = AdBanner.BannerSize.BANNER_SIZE;
                    }
                    else if (strSize.equals("MEDIUM_RECT")) {
                        size = AdBanner.BannerSize.MEDIUM_RECT_SIZE;
                    }
                    else if (strSize.equals("LEADERBOARD")) {
                        size = AdBanner.BannerSize.LEADERBOARD_SIZE;
                    }
                }

                AdBanner banner = _service.createBanner(_activity, adunit, size);
                banner.setListener(AdServiceBridge.this);
                BannerData data = new BannerData();
                data.banner = banner;
                _banners.put(bannerId, data);
            }
        });
    }

    public void createInterstitial(final long interstitialId, final String adunit) {

        runOnThread(new Runnable() {
            @Override
            public void run() {
                AdInterstitial interstitial = _service.createInterstitial(_activity, adunit);
                interstitial.setListener(AdServiceBridge.this);
                _interstitials.put(interstitialId, interstitial);
            }
        });
    }

    public void releaseBanner(final long bannerId) {
        runOnThread(new Runnable() {
            @Override
            public void run() {
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
        });
    }

    public void releaseInterstitial(final long interstitialId) {

        runOnThread(new Runnable() {
            @Override
            public void run() {
                AdInterstitial interstitial = _interstitials.get(interstitialId);
                if (interstitial != null) {
                    interstitial.setListener(null);
                    interstitial.destroy();
                    _interstitials.remove(interstitialId);
                }
            }
        });
    }

    public void showBanner(final long bannerId) {
        runOnThread(new Runnable() {
            @Override
            public void run() {
                BannerData data = _banners.get(bannerId);
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
        });
    }

    public void hideBanner(final long bannerId) {
        runOnThread(new Runnable() {
            @Override
            public void run() {
                BannerData data = _banners.get(bannerId);
                if (data != null && data.banner.getView() != null) {
                    data.banner.getView().setVisibility(View.GONE);
                }
            }
        });
    }

    public void setBannerPosition(final long bannerId, final float x, final float y) {
        runOnThread(new Runnable() {
            @Override
            public void run() {
                BannerData data = _banners.get(bannerId);
                if (data != null) {
                    data.x = x;
                    data.y = y;
                    layoutBanner(data);
                }
            }
        });
    }

    public void setBannerLayout(final long bannerId, final String value) {
        runOnThread(new Runnable() {
            @Override
            public void run() {
                BannerData data = _banners.get(bannerId);
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
        });
    }

    public void loadBanner(final long bannerId) {
        runOnThread(new Runnable() {
            @Override
            public void run() {
                BannerData data = _banners.get(bannerId);
                if (data != null) {
                    data.banner.loadAd();
                }
            }
        });
    }

    public void showInterstitial(final long interstitialId) {
        runOnThread(new Runnable() {
            @Override
            public void run() {
                AdInterstitial interstitial = _interstitials.get(interstitialId);
                if (interstitial != null) {
                    interstitial.show();
                }
            }
        });
    }

    public void loadInterstitial(final long interstitialId) {
        runOnThread(new Runnable() {
            @Override
            public void run() {
                AdInterstitial interstitial = _interstitials.get(interstitialId);
                if (interstitial != null) {
                    interstitial.loadAd();
                }
            }
        });
    }

    //Ad Listeners

    private static native void nativeBannerOnLoaded(long bannerId, int width, int height);
    private static native void nativeBannerOnFailed(long bannerId, int errorCode, String message);
    private static native void nativeBannerOnClicked(long bannerId);
    private static native void nativeBannerOnExpanded(long bannerId);
    private static native void nativeBannerOnCollapsed(long bannerId);

    private static native void nativeInterstitialOnLoaded(long interstitialId);
    private static native void nativeInterstitialOnFailed(long interstitialId, int errorCode, String message);
    private static native void nativeInterstitialOnClicked(long interstitialId);
    private static native void nativeInterstitialOnShown(long interstitialId);
    private static native void nativeInterstitialOnDismissed(long interstitialId);

    @Override
    public void onLoaded(AdBanner banner) {
        final long bannerId = findBannerId(banner);
        if (bannerId == 0)
            return;
        final int width = banner.getWidth();
        final int height = banner.getHeight();
        dispatchNative(new Runnable() {
            @Override
            public void run() {
                nativeBannerOnLoaded(bannerId, width, height);
            }
        });
    }

    @Override
    public void onFailed(AdBanner banner, final int errorCode, final String errorMessage) {
        final long bannerId = findBannerId(banner);
        if (bannerId == 0)
            return;
        dispatchNative(new Runnable() {
            @Override
            public void run() {
                nativeBannerOnFailed(bannerId, errorCode, errorMessage);
            }
        });
    }

    @Override
    public void onClicked(AdBanner banner) {
        final long bannerId = findBannerId(banner);
        if (bannerId == 0)
            return;
        dispatchNative(new Runnable() {
            @Override
            public void run() {
                nativeBannerOnClicked(bannerId);
            }
        });
    }

    @Override
    public void onExpanded(AdBanner banner) {
        final long bannerId = findBannerId(banner);
        if (bannerId == 0)
            return;
        dispatchNative(new Runnable() {
            @Override
            public void run() {
                nativeBannerOnExpanded(bannerId);
            }
        });
    }

    @Override
    public void onCollapsed(AdBanner banner) {
        final long bannerId = findBannerId(banner);
        if (bannerId == 0)
            return;
        dispatchNative(new Runnable() {
            @Override
            public void run() {
                nativeBannerOnCollapsed(bannerId);
            }
        });
    }

    @Override
    public void onLoaded(AdInterstitial interstitial) {
        final long interstitialId = findInterstitialId(interstitial);
        if (interstitialId == 0)
            return;
        dispatchNative(new Runnable() {
            @Override
            public void run() {
                nativeInterstitialOnLoaded(interstitialId);
            }
        });
    }

    @Override
    public void onFailed(AdInterstitial interstitial, final int errorCode, final String errorMessage) {
        final long interstitialId = findInterstitialId(interstitial);
        if (interstitialId == 0)
            return;
        dispatchNative(new Runnable() {
            @Override
            public void run() {
                nativeInterstitialOnFailed(interstitialId, errorCode, errorMessage);
            }
        });
    }

    @Override
    public void onClicked(AdInterstitial interstitial) {
        final long interstitialId = findInterstitialId(interstitial);
        if (interstitialId == 0)
            return;
        dispatchNative(new Runnable() {
            @Override
            public void run() {
                nativeInterstitialOnClicked(interstitialId);
            }
        });
    }

    @Override
    public void onShown(AdInterstitial interstitial) {
        final long interstitialId = findInterstitialId(interstitial);
        if (interstitialId == 0)
            return;
        dispatchNative(new Runnable() {
            @Override
            public void run() {
                nativeInterstitialOnShown(interstitialId);
            }
        });
    }

    @Override
    public void onDismissed(AdInterstitial interstitial) {
        final long interstitialId = findInterstitialId(interstitial);
        if (interstitialId == 0)
            return;
        dispatchNative(new Runnable() {
            @Override
            public void run() {
                nativeInterstitialOnDismissed(interstitialId);
            }
        });
    }

    //Utility methods

    protected void layoutBanner(BannerData data) {
        if (data.banner == null || data.banner.getView().getParent() == null) {
            return;
        }

        ViewGroup vg = getViewGroup();
        FrameLayout.LayoutParams layoutParams = (FrameLayout.LayoutParams)data.banner.getView().getLayoutParams();
        float density = _activity.getResources().getDisplayMetrics().density;
        layoutParams.width = (int) (data.banner.getWidth() * density);
        layoutParams.height = (int) (data.banner.getHeight() * density);

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
        return (ViewGroup) _activity.getWindow().getDecorView().findViewById(android.R.id.content);
    }

    protected long findBannerId(AdBanner banner) {
        for (long key: _banners.keySet()) {
            BannerData data = _banners.get(key);
            if (data.banner == banner) {
                return key;
            }
        }
        return 0;
    }

    protected long findInterstitialId(AdInterstitial interstitial) {
        for (long key: _interstitials.keySet()) {
            if (_interstitials.get(key) == interstitial) {
                return key;
            }
        }
        return 0;
    }


    //ActivityLifeCycleListener
    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {

    }

    @Override
    public void onPause() {

    }

    @Override
    public void onResume() {

    }

    @Override
    public void onDestroy() {
        SafeJNI.INSTANCE.removeLifeCycleListener(this);

        for (long key: _interstitials.keySet()) {
            AdInterstitial interstitial = _interstitials.get(key);
            interstitial.setListener(null);
            interstitial.destroy();
        }
        for (long key: _banners.keySet()) {
            BannerData data = _banners.get(key);
            if (data.banner.getView().getParent() != null) {
                ViewGroup vg = getViewGroup();
                vg.removeView(data.banner.getView());
            }
        }
        _interstitials.clear();
        _banners.clear();
    }

}
