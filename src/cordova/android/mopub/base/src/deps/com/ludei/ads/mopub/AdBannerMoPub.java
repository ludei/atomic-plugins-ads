package com.ludei.ads.mopub;

import android.content.Context;
import android.view.View;

import com.ludei.ads.AbstractAdBanner;
import com.mopub.mobileads.MoPubErrorCode;
import com.mopub.mobileads.MoPubView;

/**
 * Created by mortimer on 15/1/15.
 */
class AdBannerMoPub extends AbstractAdBanner implements MoPubView.BannerAdListener {

    private MoPubView banner;

    AdBannerMoPub(Context ctx, String adunit, BannerSize size) {

        banner = new MoPubView(ctx);
        banner.setAdUnitId(adunit);
        banner.setBannerAdListener(this);
    }

    @Override
    public void loadAd() {
        banner.loadAd();
    }

    @Override
    public int getWidth() {
        return banner.getAdWidth();
    }

    @Override
    public int getHeight() {
        return banner.getAdHeight();
    }

    @Override
    public View getView() {
        return banner;
    }

    @Override
    public void destroy() {
        banner.destroy();
    }

    /** Mopub Listener **/

    @Override
    public void onBannerLoaded(MoPubView banner) {
        this.notifyOnLoaded();
    }

    @Override
    public void onBannerFailed(MoPubView banner, MoPubErrorCode errorCode) {
        this.notifyOnFailed(errorCode.ordinal(), errorCode.toString());
    }

    @Override
    public void onBannerClicked(MoPubView banner) {
        this.notifyOnClicked();
    }

    @Override
    public void onBannerExpanded(MoPubView banner) {
        this.notifyOnExpanded();
    }

    @Override
    public void onBannerCollapsed(MoPubView banner) {
        this.notifyOnCollapsed();
    }
}
