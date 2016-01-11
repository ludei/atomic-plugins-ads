(function() {
   	/**
    * Cocoon.Ad.Chartboost class provides an easy to use Chartboost API with built-in support for multiple banners and interstitials.
    * @namespace Cocoon.Ad.Chartboost
    */
    Cocoon.define("Cocoon.Ad", function(extension) {

        extension.Chartboost = new Cocoon.Ad.AdService("LDChartboostPlugin");
        return extension;
    });

})();
