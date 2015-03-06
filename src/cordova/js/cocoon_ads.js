    /**
    * @fileOverview
    <h2>About Atomic Plugins</h2>
    <p>Atomic Plugins provide an elegant and minimalist API and are designed with portability in mind from the beginning. Framework dependencies are avoided by design so the plugins can run on any platform and can be integrated with any app framework or game engine.
    <br/><p>You can contribute and help to create more awesome plugins. </p>
    <h2>Atomic Plugins for Ads</h2>
    <p>This repo contains Ad APIs designed using the Atomic Plugins paradigm. Monetize your app and take advantage of all the features provided: elegant API, flexible monetization solution that works across multiple platforms, full support for banners and full screen ads (interstitials), single API for different Ad Providers, etc. The API is already available in many languagues and we have the plan to add more in the future.</p>
    <p>Currently there are 2 Ad providers implemented but new ones can be easily added:</p>
    <ul>
    <li>MoPub with optional adapters</li>
    <li>AdMob</li>
    </ul>
    <h3>Setup your project</h3>
    <p>Releases are deployed to Cordova Plugin Registry. 
    You only have to install the desired plugins using Cordova CLI, Cocoon CLI or Cocoon Cloud Server.</p>
    <ul>
    <code>
    cordova plugin add com.ludei.ads.ios.admob; //AdMob plugin for iOS<br/>
    cordova plugin add com.ludei.ads.ios.mopub; //MoPub plugin for iOS<br/>
    cordova plugin add com.ludei.ads.android.admob; //AdMob plugin for Android<br/>
    cordova plugin add com.ludei.ads.android.mopub; //MoPub plugin for Android<br/><br/>
    //Optional MoPub adapters for iOS and Android<br/>
    cordova plugin add com.ludei.ads.ios.mopub.charboost;<br/>
    cordova plugin add com.ludei.ads.ios.mopub.admob;<br/>
    cordova plugin add com.ludei.ads.ios.mopub.millennial;<br/>
    cordova plugin add con.ludei.ads.android.adcolony;<br/>
    cordova plugin add con.ludei.ads.android.admob;<br/>
    cordova plugin add con.ludei.ads.android.charboost;<br/>
    cordova plugin add con.ludei.ads.android.greystripe;<br/>
    cordova plugin add con.ludei.ads.android.inmobi;<br/>
    cordova plugin add con.ludei.ads.android.millennial;<br/></code>
    </ul>
    <p>Include the following JavaScript files in your html project:</p>
    <ul>
    <li><a href="https://github.com/ludei/atomic-plugins-ads/blob/master/src/cordova/js/cocoon_ads.js">cocoon_ads.js</a></li>
    <li><a href="https://github.com/ludei/atomic-plugins-ads/tree/master/src/cordova/js/external">cocoon.js</a></li>
    </ul>
    <h3>Documentation</h3>
    <p>In this section you will find all the documentation you need for using this plugin in your Cordova project. 
    Select the specific namespace below to open the relevant documentation section:</p>
    <ul>
    <li><a href="http://ludei.github.io/cocoon-common/dist/doc/js/Cocoon.html">Cocoon</a></li>
    <li><a href="Cocoon.Ad.html">Ad</a></li>
    </ul>
    <h3>API Reference</h3>
    <p>For a complete project that tests all the features provided in the API run the following command:</p>
    <ul><code>gulp create-cordova</code></ul>
    <br/><p>We hope you find everything you need to get going here, but if you stumble on any problems with the docs or the plugins, 
    just drop us a line at our forum and we will do our best to help you out.</p>
    <h3>Tools</h3>
    <a href="http://support.ludei.com/hc/communities/public/topics"><img src="img/cocoon-tools-1.png" /></a>
    <a href="http://support.ludei.com/hc"><img src="img/cocoon-tools-2.png" /></a>
    <a href="https://cloud.ludei.com/"><img src="img/cocoon-tools-3.png" /></a>
    <a href="https://www.ludei.com/cocoonjs/how-to-use/"><img src="img/cocoon-tools-4.png" /></a>
    * @version 1.0
    */

  /**
    * Cocoon.Ad class provides an easy to use Ads API that can be used with different Ad providers with built-in support for multiple banners and interstitials.
    * @namespace Cocoon.Ad
    */

Cocoon.define("Cocoon.Ad" , function(extension){
    "use strict";
    
  
    extension.serviceName = "AdService";
    extension.activeAds = {};

    /**
     * The predefined possible layouts for a banner ad.
     * @name Cocoon.Ad.BannerLayout
     * @memberOf Cocoon.Ad
     * @property {string} TOP_CENTER Specifies that the banner must be shown in the top of the screen and vertically centered.
     * @property {string} BOTTOM_CENTER Specifies that the banner must be shown in the bottom of the screen and vertically centered.
     * @property {string} CUSTOM Specifies that the uses sets a custom banner position
     */
    extension.BannerLayout =
    {
        TOP_CENTER      : "TOP_CENTER",
        BOTTOM_CENTER   : "BOTTOM_CENTER",
        CUSTOM          : "CUSTOM"
    };

    /**
     * The predefined possible sizes for a banner ad.
     * @name Cocoon.Ad.BannerSize
     * @memberOf Cocoon.Ad
     * @property {string} SMART Smart banner size according to screen size (Phones and Tablets)
     * @property {string} BANNER Standard banner size (Phones and Tablets)
     * @property {string} MEDIUM_RECT Medium rectangle size (Phones and Tablets)
     * @property {string} LEADERBOARD Leaderboard size (Tablets)
     */
    extension.BannerSize =
    {
        SMART           : "SMART",
        BANNER          : "BANNER",
        MEDIUM_RECT     : "MEDIUM_RECT",
        LEADERBOARD     :"LEADERBOARD"
    };

    /**
    * @private
    */
    extension.Banner = function(bannerId, serviceName) {
        this.id = bannerId;
        this.serviceName = serviceName;
        this.signal = new Cocoon.Signal();
        this.width = 0;
        this.height = 0;
    };

    /**
    * 
    * @namespace Cocoon.Ad.Banner
    * @example
    * 
    * banner = Cocoon.Ad.createBanner();
    *
    * banner.on("load", function(){
    *    console.log("Banner loaded " + banner.width, banner.height);
    *    banner.show();
    * });
    *
    * banner.on("fail", function(){
    *    console.log("Banner failed to load");
    * });
    *
    * banner.on("show", function(){
    *    console.log("Banner shown a modal content");
    * });
    *
    * banner.on("dismiss", function(){
    *    console.log("Banner dismissed the modal content");
    * });
    *
    * banner.on("click", function(){
    *    console.log("Banner clicked");
    * });
    *
    * banner.load();
    */
    extension.Banner.prototype = {

        /**
        * Shows the banner ad. 
        * @memberOf Cocoon.Ad.Banner
        * @function show 
        * @example
        * myBanner = Cocoon.Ad.createBanner(settings);
        * myBanner.show(); 
        */
        show: function() {
            Cocoon.callNative(this.serviceName, "showBanner", [this.id]);
        },

        /**
        * Hides the banner ad. 
        * @memberOf Cocoon.Ad.Banner
        * @function hide
        * @example
        * banner = Cocoon.Ad.createBanner(settings);
        * banner.hide(); 
        */
        hide: function() {
            Cocoon.callNative(this.serviceName, "hideBanner", [this.id]);
        },

        /**
        * Sets a specific layout for a banner ad. 
        * @memberOf Cocoon.Ad.Banner
        * @function setLayout 
        * @param {Cocoon.Ad.BannerLayout} layout The predefined layout for a banner ad.
        * @example
        * banner = Cocoon.Ad.createBanner(settings);
        * banner.setLayout(layout); // If CUSTOM layout
        */
        setLayout: function(layout) {
            Cocoon.callNative(this.serviceName, "setBannerLayout", [this.id, layout]);
        },

        /**
        * Sets a specific position for a banner ad in CUSTOM layout. 
        * @memberOf Cocoon.Ad.Banner
        * @function setPosition 
        * @param {number} x The top lef x coordinate of the banner.
        * @param {number} y The top lef y coordinate of the banner.
        * @example
        * banner = Cocoon.Ad.createBanner(settings);
        * banner.setLayout(layout); // If CUSTOM layout
        * banner.setPosition(x, y); 
        */
        setPosition: function(x, y) {
            Cocoon.callNative(this.serviceName, "setBannerPosition", [this.id, x, y]);
        },

        /**
        * Loads a banner ad. 
        * @memberOf Cocoon.Ad.Banner
        * @function load 
        * @example
        * banner = Cocoon.Ad.createBanner(settings);
        * banner.load();  
        */
        load: function() {
            Cocoon.callNative(this.serviceName, "loadBanner", [this.id]);
        },

        /**
        * Triggered when a new banner is loaded. 
        * @memberOf Cocoon.Ad.Banner
        * @event On load
        * @example
        * banner.on("load", function(){
        *    console.log("Banner loaded " + banner.width, banner.height);
        * });
        */

        /**
        * Triggered when the loading process of a banner has failed. 
        * @memberOf Cocoon.Ad.Banner
        * @event On fail
        * @example
        * banner.on("fail", function(error){
        *    console.log("Banner failed to load: " + JSON.stringify(error));
        * });
        */

        /**
        * Triggered when a new banner is expanded to full screen. 
        * @memberOf Cocoon.Ad.Banner
        * @event On show
        * @example
        * banner.on("show", function(){
        *    console.log("Banner shown a modal content");
        * });
        */

        /**
        * Triggered when a banner is collapsed.
        * @memberOf Cocoon.Ad.Banner
        * @event On dismiss
        * @example
        * banner.on("dismiss", function(){
        *    console.log("Banner dismissed the modal content");
        * });
        */

        /**
        * Triggered when a banner is clicked.
        * @memberOf Cocoon.Ad.Banner
        * @event On click
        * @example
        * banner.on("click", function(){
        *    console.log("Banner clicked");
        * });
        */

        on: function(eventName, handler) {
            this.signal.on(eventName, handler);
        }
    };

   /**
    * @private
    */
    extension.Interstitial = function(interstitialId, serviceName) {
        this.id = interstitialId;
        this.serviceName = serviceName;
        this.signal = new Cocoon.Signal();
    };

   /**
    * 
    * @namespace Cocoon.Ad.Interstitial
    * @example
    * interstitial = Cocoon.Ad.createInterstitial();
    *
    * interstitial.on("load", function(){
    *     console.log("Interstitial loaded");
    * });
    * interstitial.on("fail", function(){
    *     console.log("Interstitial failed");
    * });
    * interstitial.on("show", function(){
    *     console.log("Interstitial shown");
    * });
    * interstitial.on("dismiss", function(){
    *     console.log("Interstitial dismissed");
    * });
    *
    * interstitial.on("click", function(){
    *     console.log("Interstitial clicked");
    * });
    * 
    * interstitial.load();
    */
    extension.Interstitial.prototype = {

        /**
        * Shows the interstitial ad. 
        * @memberOf Cocoon.Ad.Interstitial
        * @function show
        * @example
        * interstitial = Cocoon.Ad.createInterstitial(settings);
        * interstitial.show(); 
        */
        show: function() {
            Cocoon.callNative(this.serviceName, "showInterstitial", [this.id]);
        },

        /**
        * Loads an interstitial ad. 
        * @memberOf Cocoon.Ad.Interstitial
        * @function load 
        * @example
        * interstitial = Cocoon.Ad.createInterstitial(settings);
        * interstitial.load(); 
        */
        load: function() {
            Cocoon.callNative(this.serviceName, "loadInterstitial", [this.id]);
        },

        /**
        * Triggered when a new interstitial is loaded. 
        * @memberOf Cocoon.Ad.Interstitial
        * @event On load
        * @example
        * banner.on("load", function(){
        *    console.log("Interstitial loaded");
        * });
        */

        /**
        * Triggered when the loading process of an interstitial has failed. 
        * @memberOf Cocoon.Ad.Interstitial
        * @event On fail
        * @example
        * interstitial.on("fail", function(error){
        *    console.log("Interstitial failed to load: " + JSON.stringify(error));
        * });
        */

        /**
        * Triggered when a new interstitial is shown. 
        * @memberOf Cocoon.Ad.Interstitial
        * @event On show
        * @example
        * interstitial.on("show", function(){
        *    console.log("Interstitial shown");
        * });
        */

        /**
        * Triggered when an interstitial is closed.
        * @memberOf Cocoon.Ad.Interstitial
        * @event On dismiss
        * @example
        * interstitial.on("dimissed", function(){
        *    console.log("Interstitial dimissed");
        * });
        */

        /**
        * Triggered when an interstitial is clicked.
        * @memberOf Cocoon.Ad.Interstitial
        * @event On click
        * @example
        * interstitial.on("click", function(){
        *    console.log("Interstitial clicked");
        * });
        */

        on: function(eventName, handler) {
            this.signal.on(eventName, handler);
        }
    };

    var idCounter = 0;

    function listenerHandler(args) {
        var eventName = args[0];
        var adId = args[1];
        var params = args.slice(2);

        var ad = extension.activeAds[adId];
        if (ad) {

            if (eventName === "load" && params.length > 0) {
                //cache banner size
                ad.width = params[0];
                ad.height = params[1];
                params = params.slice(2);
            }

            ad.signal.emit(eventName, null, params);
        }
    }

    /** 
    * @memberOf Cocoon.Ad
    * @function init
    * @private
    */
    extension.init = function() {
        if (this.initialized) {
            return;
        }
        Cocoon.callNative(this.serviceName, "setBannerListener", [], listenerHandler);
        Cocoon.callNative(this.serviceName, "setInterstitialListener", [], listenerHandler);

        this.initialized = true;
    };

    /**
    * Configure default banner and interstitial adunits.
    * @memberOf Cocoon.Ad
    * @function configure
    * @param {object} [settings] The banner optional settings.
    * @example
    * //Global configuration
    *Cocoon.Ads.configure({
    *     banner:"agltb3B1Yi1pbmNyDQsSBFNpdGUxxxxxxx",
    *     interstitial:"agltb3B1Yi1pbmNyDQsSBFNpdGUyyyyyyy"
    *})
    * //Or platform specific configuration
    *Cocoon.Ads.configure({
    *     ios: {
    *          banner:"agltb3B1Yi1pbmNyDQsSBFNpdGUxxxxxxx",
    *          bannerIpad:"agltb3B1Yi1pbmNyDQsSBFNpdGUzzzzz", //optional
    *          interstitial:"agltb3B1Yi1pbmNyDQsSBFNpdGUyyyyyyy",
    *          interstitialIpad:"agltb3B1Yi1pbmNyDQsSBFNpdGUtttttt", //optional
    *     },
    *     android: {
    *          banner:"agltb3B1Yi1pbmNyDQsSBFNpdGUwwwwww",
    *          interstitial:"agltb3B1Yi1pbmNyDQsSBFNpdGUhhhhhh"
    *     }
    *);*
    */
    extension.configure = function(settings) {

        var platform = Cocoon.getPlatform();
        if (platform === Cocoon.PlatformType.AMAZON && settings[Cocoon.PlatformType.ANDROID]) {
            //fallback from amazon to android if only android specified
            platform = Cocoon.PlatformType.ANDROID;
        }
        if (settings[platform]) {
            settings = settings[platform];
        }

        Cocoon.callNative(this.serviceName, "configure", [settings]);
    };

    /**
    * Creates a banner. 
    * @memberOf Cocoon.Ad
    * @function createBanner
    * @param {string} [adunit] banner adunit. Taken from cordova settings or configure method if not specified.
    * @param {Cocoon.Ad.BannerSize} [size] The banner size. Default value: Smart Size
    * @return {Cocoon.Ad.Banner} banner A new banner ad.
    * @example
    * var banner = Cocoon.Ad.createBanner();
    * banner.load(); 
    */
    extension.createBanner = function(adunit, size) {
        this.init();
        var bannerId = idCounter++;
        Cocoon.callNative(this.serviceName, "createBanner", [bannerId, adunit, size]);
        var banner = new extension.Banner(bannerId, this.serviceName);
        this.activeAds[bannerId] = banner;
        return banner;
    };

    /**
    * Releases the banner given. 
    * @memberOf Cocoon.Ad
    * @function releaseBanner
    * @param {Cocoon.Ad.Banner} The banner ad to release. 
    * @example
    * Cocoon.Ad.releaseBanner(banner);
    */
    extension.releaseBanner = function(banner) {
        Cocoon.callNative(this.serviceName, "releaseBanner", [banner.id]);
        delete this.activeAds[id];
    };

    /**
    * Creates an interstitial. 
    * @memberOf Cocoon.Ad
    * @function createInterstitial
    * @param {string} [adunit] Interstitial adunit. Taken from cordova settings or configure method if not specified.
    * @return {Cocoon.Ad.Interstitial} A new interstitial. 
    * @example
    * var interstitial = Cocoon.Ad.createInterstitial();
    * iterstitial.load(); 
    */
    extension.createInterstitial = function(adunit) {
        this.init();
        var interstitialId = idCounter++;
        Cocoon.callNative(this.serviceName, "createInterstitial", [interstitialId, adunit]);
        var interstitial = new extension.Interstitial(interstitialId, this.serviceName);
        this.activeAds[interstitialId] = interstitial;
        return interstitial;
    };

    /**
    * Releases the interstitial given. 
    * @memberOf Cocoon.Ad
    * @function releaseInterstitial
    * @param {Cocoon.Ad.Interstitial} The interstitial to release. 
    * @example
    * Cocoon.Ad.releaseInterstitial(interstitial);
    */
    extension.releaseInterstitial = function(interstitial) {
        Cocoon.callNative(this.serviceName, "releaseInterstitial", [interstitial.id]);
        delete this.activeAds[interstitial.id];
    };

    return extension;
});