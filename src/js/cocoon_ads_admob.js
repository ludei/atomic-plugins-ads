(function() {
   	/**
    * Cocoon.Ad.AdMob class provides an easy to use AdMob API with built-in support for multiple banners and interstitials.
    * @namespace Cocoon.Ad.AdMob
    * @example
    * //Global configuration
    *Cocoon.Ads.AdMob.configure({
    *     banner:"xxx",
    *     interstitial:"yyy"
    *})
    * //Or platform specific configuration
    *Cocoon.Ads.AdMob.configure({
    *     ios: {
    *          banner:"aaa",
    *          bannerIpad:"bbb", //optional
    *          interstitial:"ccc",
    *          interstitialIpad:"ddd", //optional
    *     },
    *     android: {
    *          banner:"eee",
    *          interstitial:"fff"
    *     }
    *);*
    */
    Cocoon.define("Cocoon.Ad", function(extension) {

        extension.AdMob = new Cocoon.Ad.AdService("LDAdMobPlugin");
        return extension;
    });

})();
