package com.ludei.ads.admob;

import android.content.Context;
import android.view.View;

import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.AdSize;
import com.google.android.gms.ads.AdListener;
import com.google.android.gms.ads.AdView;
import com.ludei.ads.AbstractAdBanner;


class AdBannerAdMob extends AbstractAdBanner {

    private AdView banner;

    AdBannerAdMob(Context ctx, String adunit, BannerSize size) {

        banner = new AdView(ctx);

        AdSize admobSize = AdSize.SMART_BANNER;
        switch (size) {
            case SMART_SIZE: admobSize = AdSize.SMART_BANNER; break;
            case BANNER_SIZE: admobSize = AdSize.BANNER; break;
            case MEDIUM_RECT_SIZE: admobSize = AdSize.MEDIUM_RECTANGLE; break;
            case LEADERBOARD_SIZE: admobSize = AdSize.LEADERBOARD; break;
        }

        banner.setAdSize(admobSize);
        banner.setMinimumWidth(admobSize.getWidth());
        banner.setMinimumHeight(admobSize.getHeight());
        banner.setAdUnitId(adunit);

        banner.setAdListener(new AdListener() {
            @Override
            public void onAdClosed() {
                notifyOnCollapsed();
            }

            @Override
            public void onAdFailedToLoad(int errorCode) {
                notifyOnFailed(errorCode, "Error with code: " + errorCode);
            }

            @Override
            public void onAdLeftApplication() {
                notifyOnClicked();
            }

            @Override
            public void onAdOpened() {
                notifyOnExpanded();
            }

            @Override
            public void onAdLoaded() {
                notifyOnLoaded();
            }
        });

    }

    @Override
    public void loadAd() {
        banner.loadAd(new AdRequest.Builder().build());
    }

    @Override
    public int getWidth() {
        return banner.getAdSize().getWidthInPixels(banner.getContext());
    }

    @Override
    public int getHeight() {
        return banner.getAdSize().getHeightInPixels(banner.getContext());
    }

    @Override
    public View getView() {
        return banner;
    }

    @Override
    public void destroy() {
        banner.destroy();
    }

}
