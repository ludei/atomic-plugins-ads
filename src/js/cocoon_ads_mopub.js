(function() {
   	/**
    * Cocoon.Ad.MoPub class provides an easy to use MoPub API with built-in support for multiple banners and interstitials.
    * @namespace Cocoon.Ad.MoPub
    * @example
    * //Global configuration
    *Cocoon.Ads.MoPub.configure({
    *     banner:"xxx",
    *     interstitial:"yyy"
    *})
    * //Or platform specific configuration
    *Cocoon.Ads.MoPub.configure({
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

        extension.MoPub = new Cocoon.Ad.AdService("LDMoPubPlugin");
        return extension;
    });

})();
