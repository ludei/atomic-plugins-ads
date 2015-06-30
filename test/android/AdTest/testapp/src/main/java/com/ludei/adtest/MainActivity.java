package com.ludei.adtest;

import android.app.Activity;
import android.os.Bundle;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.ludei.ads.AdBanner;
import com.ludei.ads.AdInterstitial;
import com.ludei.ads.AdService;


public class MainActivity extends Activity implements AdInterstitial.InterstitialListener, AdBanner.BannerListener {

    private AdService adService;
    private AdBanner adBanner;
    private AdInterstitial adInterstitial;
    private TextView txtBannerStatus;
    private TextView txtInterstitialStatus;
    private boolean topCenter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        //create the adservice according to selected gradle build variant (MoPub or AdMob)
        adService = AdServiceCreator.create(this);

        adBanner = adService.createBanner(this);
        if (adBanner != null) {
            adBanner.setListener(this);
        }
        adInterstitial = adService.createRewardedVideo(this, null);
        adInterstitial.setListener(this);
        this.initButtons();
        txtBannerStatus = (TextView)findViewById(R.id.txtBannerStatus);
        txtInterstitialStatus = (TextView)findViewById(R.id.txtInterstitialStatus);
        txtBannerStatus.setText("");
        txtInterstitialStatus.setText("");
        topCenter = true;
    }

    private void initButtons() {

        this.findViewById(R.id.btnShowBanner).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                adBanner.getView().setVisibility(View.VISIBLE);
            }
        });

        this.findViewById(R.id.btnHideBanner).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                adBanner.getView().setVisibility(View.GONE);
            }
        });

        this.findViewById(R.id.btnChangePosition).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                topCenter = !topCenter;
                layoutBanner();
            }
        });

        this.findViewById(R.id.btnLoadBanner).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                txtBannerStatus.setText("Loading...");
                adBanner.loadAd();
            }
        });

        this.findViewById(R.id.btnShowInterstitial).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                adInterstitial.show();
            }
        });

        this.findViewById(R.id.btnLoadInterstitial).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                txtInterstitialStatus.setText("Loading...");
                adInterstitial.loadAd();
            }
        });

    }

    private void layoutBanner() {

        if (adBanner == null || adBanner.getView().getParent() == null) {
            return;
        }

        ViewGroup vg = (ViewGroup)getWindow().getDecorView().findViewById(android.R.id.content);
        FrameLayout.LayoutParams layoutParams = (FrameLayout.LayoutParams)adBanner.getView().getLayoutParams();
        layoutParams.width = adBanner.getWidth();
        layoutParams.height = adBanner.getHeight();
        layoutParams.leftMargin = (int)(vg.getWidth() * 0.5 - layoutParams.width * 0.5);
        if (topCenter) {
            layoutParams.topMargin = 0;
        }
        else {
            layoutParams.topMargin = vg.getHeight() - layoutParams.height;
        }
        vg.requestLayout();
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    @Override
    public void onLoaded(AdBanner banner) {
        txtBannerStatus.setText("Loaded");

        if (banner.getView().getParent() == null) {
            ViewGroup vg = (ViewGroup)getWindow().getDecorView().findViewById(android.R.id.content);
            FrameLayout.LayoutParams params = new FrameLayout.LayoutParams(FrameLayout.LayoutParams.WRAP_CONTENT, FrameLayout.LayoutParams.WRAP_CONTENT);
            vg.addView(banner.getView());
        }

        layoutBanner();
    }

    @Override
    public void onFailed(AdBanner banner, int errorCode, String errorMessage) {
        txtBannerStatus.setText("Failed: " + errorMessage);
    }

    @Override
    public void onClicked(AdBanner banner) {
        txtBannerStatus.setText("Clicked");
    }

    @Override
    public void onExpanded(AdBanner banner) {
        txtBannerStatus.setText("Expanded");
    }

    @Override
    public void onCollapsed(AdBanner banner) {
        txtBannerStatus.setText("Collapsed");
    }

    @Override
    public void onLoaded(AdInterstitial interstitial) {
        txtInterstitialStatus.setText("Loaded");
    }

    @Override
    public void onFailed(AdInterstitial interstitial, int errorCode, String errorMessage) {
        txtInterstitialStatus.setText("Failed: " + errorMessage);
    }

    @Override
    public void onClicked(AdInterstitial interstitial) {
        txtInterstitialStatus.setText("Clicked");
    }

    @Override
    public void onShown(AdInterstitial interstitial) {
        txtInterstitialStatus.setText("Shown");
    }

    @Override
    public void onDismissed(AdInterstitial interstitial) {
        txtInterstitialStatus.setText("Dismissed");
    }

    @Override
    public void onRewardCompleted(AdInterstitial interstitial, int quantity) {
        txtInterstitialStatus.setText("Reward " + quantity);
    }
}
