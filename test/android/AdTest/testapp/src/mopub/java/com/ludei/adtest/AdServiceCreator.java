package com.ludei.adtest;

import com.ludei.ads.AdService;
import com.ludei.ads.mopub.AdServiceMoPub;

public class AdServiceCreator {

    public static AdService create() {
        AdServiceMoPub service = new AdServiceMoPub();
        service.configure("68949c5d9de74b79bb79aa29c203ca02", "74a813ae7a404881bf17eb8d1b0aa943");
        return service;
    }
}
