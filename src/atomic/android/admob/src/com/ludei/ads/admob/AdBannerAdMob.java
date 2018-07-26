package com.ludei.ads.admob;

import android.content.Context;
import android.os.Bundle;
import android.view.View;

import com.google.ads.mediation.admob.AdMobAdapter;
import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.AdSize;
import com.google.android.gms.ads.AdListener;
import com.google.android.gms.ads.AdView;
import com.ludei.ads.AbstractAdBanner;
import com.ludei.ads.AdBanner;


public class AdBannerAdMob extends AbstractAdBanner {

    private AdView banner;
    private boolean adsConsent;

    AdBannerAdMob(Context ctx, String adUnit, BannerSize size, boolean personalizedAdsConsent) {
        adsConsent = personalizedAdsConsent;

        banner = new AdView(ctx);

        AdSize admobSize;
        switch (size) {
            case SMART_SIZE:
                admobSize = AdSize.SMART_BANNER;
                break;
            case BANNER_SIZE:
                admobSize = AdSize.BANNER;
                break;
            case MEDIUM_RECT_SIZE:
                admobSize = AdSize.MEDIUM_RECTANGLE;
                break;
            case LEADERBOARD_SIZE:
                admobSize = AdSize.LEADERBOARD;
                break;
            default:
                admobSize = AdSize.SMART_BANNER;
                break;
        }

        banner.setAdSize(admobSize);
        banner.setMinimumWidth(admobSize.getWidth());
        banner.setMinimumHeight(admobSize.getHeight());
        banner.setAdUnitId(adUnit);

        banner.setAdListener(new AdListener() {
            @Override
            public void onAdClosed() {
                notifyOnCollapsed();
            }

            @Override
            public void onAdFailedToLoad(int errorCode) {
                AdBanner.Error error = new Error();
                error.code = errorCode;
                error.message = "Error with code: " + errorCode;
                notifyOnFailed(error);
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
        AdRequest adRequest;
        if (adsConsent) {
            Bundle extras = new Bundle();
            extras.putString("npa", "1");
            adRequest = new AdRequest.Builder().addNetworkExtrasBundle(AdMobAdapter.class, extras).build();
        } else {
            adRequest = new AdRequest.Builder().build();
        }

        banner.loadAd(adRequest);
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
