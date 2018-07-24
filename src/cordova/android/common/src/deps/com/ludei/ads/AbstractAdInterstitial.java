package com.ludei.ads;

public abstract class AbstractAdInterstitial implements AdInterstitial {

    private InterstitialListener _listener;

    public void setListener(InterstitialListener listener) {
        _listener = listener;
    }

    public void notifyOnLoaded() {
        if (_listener != null) {
            _listener.onLoaded(this);
        }
    }

    public void notifyOnFailed(Error error) {
        if (_listener != null) {
            _listener.onFailed(this, error);
        }
    }

    public void notifyOnClicked() {
        if (_listener != null) {
            _listener.onClicked(this);
        }
    }

    public void notifyOnShown() {
        if (_listener != null) {
            _listener.onShown(this);
        }
    }

    public void notifyOnDismissed() {
        if (_listener != null) {
            _listener.onDismissed(this);
        }
    }
}
