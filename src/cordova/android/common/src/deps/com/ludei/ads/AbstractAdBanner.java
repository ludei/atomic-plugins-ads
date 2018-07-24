package com.ludei.ads;

public abstract class AbstractAdBanner implements AdBanner {

    private BannerListener _listener;

    public void setListener(BannerListener listener) {
        this._listener = listener;
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

    public void notifyOnExpanded() {
        if (_listener != null) {
            _listener.onExpanded(this);
        }
    }

    public void notifyOnCollapsed() {
        if (_listener != null) {
            _listener.onCollapsed(this);
        }
    }

}
