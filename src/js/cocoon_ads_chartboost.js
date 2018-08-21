(function () {
    /**
     * Cocoon.Ad.Chartboost class provides an easy to use Chartboost API with built-in support for multiple banners and interstitials.
     * @namespace Cocoon.Ad.Chartboost
     * @example
     * //Global configuration
     *Cocoon.Ads.Chartboost.configure({
    *     banner:"xxx",
    *     interstitial:"yyy"
    *})
     * //Or platform specific configuration
     *Cocoon.Ads.Chartboost.configure({
    *     ios: {
    *          interstitial:"aaa",
    *          interstitialIpad:"bbb", //optional
    *     },
    *     android: {
    *          banner:"ccc",
    *          interstitial:"ddd"
    *     }
    *);*
    */
    Cocoon.define("Cocoon.Ad", function (extension) {

        extension.Chartboost = new Cocoon.Ad.AdService("LDChartboostPlugin");
        return extension;
    });

})();
