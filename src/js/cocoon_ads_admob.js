(function() {
    Cocoon.define("Cocoon.Ad", function(extension) {

        extension.AdMob = new Cocoon.Ad.AdService("LDAdMobPlugin");
        return extension;
    });

})();
