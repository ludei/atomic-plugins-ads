(function () {
    /**
     * Cocoon.Ad.Heyzap class provides an easy to use Heyzap API with built-in support for multiple banners and interstitials.
     * @namespace Cocoon.Ad.Heyzap
     * @example
     * //Global configuration
     *Cocoon.Ads.Heyzap.configure({
    *     publisherId:"xxxxxxxxxxxxxxxx"
    *})
     * //Or platform specific configuration
     *Cocoon.Ads.Heyzap.configure({
    *     ios: {
    *          publisherId:"xxxxxxxxxxxxxxxx"
    *     },
    *     android: {
    *          publisherId:"yyyyyyyyyyyyyyyy"
    *     }
    *);*
    */
    Cocoon.define("Cocoon.Ad", function (extension) {

        extension.Heyzap = new Cocoon.Ad.AdService("LDHeyzapPlugin");

        /**
         * Shows a native view to help debug the Heyzap mediation settings
         * @memberOf Cocoon.Ad.Heyzap
         * @function showDebug
         * @example
         * Cocoon.Ad.Heyzap.showDebug();
         */
        extension.Heyzap.showDebug = function () {
            Cocoon.exec(this.serviceName, "showDebug", []);
        };


        return extension;
    });

})();
