(function() {
    Cocoon.define("Cocoon.Ad", function(extension) {

        extension.Chartboost = new Cocoon.Ad.AdService("LDChartboostPlugin");
        return extension;
    });

})();
