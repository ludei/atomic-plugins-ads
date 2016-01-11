(function() {
   	/**
    * Cocoon.Ad.MoPub class provides an easy to use MoPub API with built-in support for multiple banners and interstitials.
    * @namespace Cocoon.Ad.MoPub
    */
    Cocoon.define("Cocoon.Ad", function(extension) {

        extension.MoPub = new Cocoon.Ad.AdService("LDMoPubPlugin");
        return extension;
    });

})();
