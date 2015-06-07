(function() {
    Cocoon.define("Cocoon.Ad", function(extension) {

        extension.MoPub = new Cocoon.Ad.AdService("LDMoPubPlugin");
        return extension;
    });

})();
