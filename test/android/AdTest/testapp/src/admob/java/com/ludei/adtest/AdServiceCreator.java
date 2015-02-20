package com.ludei.adtest;

import com.ludei.ads.AdService;
import com.ludei.ads.admob.AdServiceAdMob;

public class AdServiceCreator {

    public static AdService create() {
        AdServiceAdMob service = new AdServiceAdMob();
        String adunit = "ca-app-pub-7686972479101507/4443703872";
        service.configure(adunit, adunit);
        return service;
    }
}
