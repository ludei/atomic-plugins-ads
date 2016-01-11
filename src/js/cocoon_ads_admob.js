(function() {
   	/**
    * Cocoon.Ad.AdMob class provides an easy to use AdMob API with built-in support for multiple banners and interstitials.
    * @namespace Cocoon.Ad.AdMob
    */
    Cocoon.define("Cocoon.Ad", function(extension) {

        extension.AdMob = new Cocoon.Ad.AdService("LDAdMobPlugin");
        return extension;
    });

})();
