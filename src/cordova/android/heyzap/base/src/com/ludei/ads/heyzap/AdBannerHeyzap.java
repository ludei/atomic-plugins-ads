package com.ludei.ads.heyzap;

import android.app.Activity;
import android.view.View;
import com.heyzap.sdk.ads.BannerAdView;
import com.heyzap.sdk.ads.HeyzapAds;
import com.ludei.ads.AbstractAdBanner;


class AdBannerHeyzap extends AbstractAdBanner implements HeyzapAds.BannerListener {

    private Activity _activity;
    private BannerAdView _banner;
    private String _tag;

    AdBannerHeyzap(Activity activity, String tag) {
        this._tag = tag;
        this._activity = activity;
        this._banner = new BannerAdView(activity);
        this._banner.setBannerListener(this);
    }

    @Override
    public void loadAd() {
        this._banner.load(this._tag);
    }

    @Override
    public int getWidth() {
        float density = this._activity.getResources().getDisplayMetrics().density;
        return (int) (this._banner.getWidth() * density);
    }

    @Override
    public int getHeight() {
        float density = this._activity.getResources().getDisplayMetrics().density;
        return (int) (this._banner.getHeight() * density);
    }

    @Override
    public View getView() {
        return this._banner;
    }

    @Override
    public void destroy() {
        this._banner.destroy();
    }

    @Override
    public void onAdError(BannerAdView bannerAdView, HeyzapAds.BannerError bannerError) {
        Error error = new Error();
        error.code = bannerError.getErrorCode().ordinal();
        error.message = bannerError.getErrorMessage();
        notifyOnFailed(error);
    }

    @Override
    public void onAdLoaded(BannerAdView bannerAdView) {
        notifyOnLoaded();
    }

    @Override
    public void onAdClicked(BannerAdView bannerAdView) {
        notifyOnClicked();
    }
}
