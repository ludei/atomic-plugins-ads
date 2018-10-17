package com.ludei.ads.mopub;

import android.content.Context;
import android.view.View;
import com.ludei.ads.AbstractAdBanner;
import com.ludei.ads.AdBanner;
import com.mopub.mobileads.MoPubErrorCode;
import com.mopub.mobileads.MoPubView;

/**
 * Created by mortimer on 15/1/15.
 */
class AdBannerMoPub extends AbstractAdBanner implements MoPubView.BannerAdListener {

    private Context ctx;
    private MoPubView banner;

    AdBannerMoPub(Context ctx, String adUnit, BannerSize size) {
        this.ctx = ctx;
        banner = new MoPubView(ctx);
        banner.setAdUnitId(adUnit);
        banner.setBannerAdListener(this);
    }

    @Override
    public void loadAd() {
        banner.loadAd();
    }

    @Override
    public int getWidth() {
        float density = this.ctx.getResources().getDisplayMetrics().density;
        return (int) (banner.getAdWidth() * density);
    }

    @Override
    public int getHeight() {
        float density = this.ctx.getResources().getDisplayMetrics().density;
        return (int) (banner.getAdHeight() * density);
    }

    @Override
    public View getView() {
        return banner;
    }

    @Override
    public void destroy() {
        banner.destroy();
    }

    /**
     * Mopub Listener
     **/

    @Override
    public void onBannerLoaded(MoPubView banner) {
        this.notifyOnLoaded();
    }

    @Override
    public void onBannerFailed(MoPubView banner, MoPubErrorCode errorCode) {
        AdBanner.Error error = new AdBanner.Error();
        error.code = errorCode.ordinal();
        error.message = errorCode.toString();
        notifyOnFailed(error);
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
