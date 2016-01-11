"use strict";

(function(){

    var AssetManager = cc.plugin.asset.AssetManager;
    var director;
    var scene;
    var bannerStatus;
    var interstitialStatus;


    var banner;
    var interstitial;
    var demoPosition;


    function createBanner() {

        banner = Cocoon.Ad.createBanner();

        banner.on("load", function(){
            console.log("Banner loaded " + banner.width, banner.height);
            bannerStatus.setText("Banner loaded");
        });

        banner.on("fail", function(){
            console.log("Banner failed to load");
            bannerStatus.setText("Banner failed");
        });

        banner.on("show", function(){
            console.log("Banner shown a modal content");
            bannerStatus.setText("Banner show modal content");
        });

        banner.on("dismiss", function(){
            console.log("Banner dismissed the modal content");
            bannerStatus.setText("Banner dismissed modal");
        });
    }

    function createInterstitial() {

        interstitial = Cocoon.Ad.createInterstitial();

        interstitial.on("load", function(){
            console.log("Interstitial loaded");
            interstitialStatus.setText("Interstitial loaded");
        });
        interstitial.on("fail", function(){
            console.log("Interstitial failed");
            interstitialStatus.setText("Interstitial failed");
        });
        interstitial.on("show", function(){
            console.log("Interstitial shown");
            interstitialStatus.setText("Interstitial shown");
        });
        interstitial.on("dismiss", function(){
            console.log("Interstitial dismissed");
            interstitialStatus.setText("Interstitial dismissed");
        });
    };

    function initAds() {
        //Configuration If AdMob service plugins are installed
Cocoon.Ad.configure({
     ios: {
          banner:"ca-app-pub-7686972479101507/8873903476",
          interstitial:"ca-app-pub-7686972479101507/8873903476",
     },
     android: {
          banner:"ca-app-pub-7686972479101507/4443703872",
          interstitial:"ca-app-pub-7686972479101507/4443703872"
     }
});

        //Configuration If MoPub service plugins are installed
        /*Cocoon.Ad.configure({
             ios: {
                  banner:"agltb3B1Yi1pbmNyDQsSBFNpdGUY5dDoEww",
                  bannerIpad:"agltb3B1Yi1pbmNyDQsSBFNpdGUYk8vlEww", //optional
                  interstitial:"agltb3B1Yi1pbmNyDQsSBFNpdGUYjf30Eww",
                  interstitialIpad:"agltb3B1Yi1pbmNyDQsSBFNpdGUYjf30Eww", //optional
             },
             android: {
                  banner:"68949c5d9de74b79bb79aa29c203ca02",
                  interstitial:"74a813ae7a404881bf17eb8d1b0aa943"
             }
        });*/

        createBanner();
        createInterstitial();
    }

    function init(resources) {

        initAds();

        AssetManager.addImage( resources['background'], 'background' );
        AssetManager.addImage( resources['button1'], 'button1' );
        AssetManager.addImage( resources['button2'], 'button2' );


        var renderer = new cc.render.CanvasRenderer(window.innerWidth, window.innerHeight, document.getElementById("c"));
        director = new cc.node.Director().
            setRenderer(renderer);

        scene = director.createScene().setColor(0.0,0,0.0, 1.0);

        var background= new cc.node.Sprite( { frameName: "background" } );
        background.setPosition(scene.width * 0.5, scene.height * 0.5);
        background.setAnchorPoint(0.5, 0.5);
        var scale = Math.max(scene.height/background.height, scene.width/background.width);
        background.setScale(scale, scale);
        scene.addChild(background);


        var btnShowBanner = createButton("Show banner", function(){
            banner.show();
        });
        var btnHideBanner = createButton("Hide banner", function(){
            banner.hide();
        });
        var btnChangePosition = createButton("Change position", function(){
            if (demoPosition == Cocoon.Ad.BannerLayout.BOTTOM_CENTER) {
                demoPosition = Cocoon.Ad.BannerLayout.TOP_CENTER;
            }
            else {
                demoPosition = Cocoon.Ad.BannerLayout.BOTTOM_CENTER;
            }
            banner.setLayout(demoPosition);
        });
        var btnLoadBanner = createButton("Load banner", function(){
            bannerStatus.setText("Loading...");
            banner.load();
        });

        var btnShowInterstitial = createButton("Show interstial", function(){
            interstitial.show();
        });

        var btnLoadInterstitial = createButton("Load interstial", function(){
            interstitialStatus.setText("Loading...");
            interstitial.load();
        });


        var delta = btnLoadBanner.width * 0.8 * btnLoadBanner.scaleX;
   
        var bannerMenu = new cc.Menu(btnShowBanner, btnHideBanner, btnChangePosition, btnLoadBanner);
        bannerMenu.alignItemsVerticallyWithPadding(10);
        bannerMenu.setPosition(scene.width * 0.5 + delta, scene.height * 0.5);
        scene.addChild(bannerMenu);

        var interstialMenu = new cc.Menu(btnShowInterstitial, btnLoadInterstitial);
        interstialMenu.alignItemsVerticallyWithPadding(10);
        interstialMenu.setPosition(scene.width * 0.5 - delta, scene.height * 0.5);
        scene.addChild(interstialMenu);

        bannerStatus = createText("Created", 20, "#000");
        interstitialStatus = createText("Created", 20, "#000");
        bannerStatus.setPosition(scene.width * 0.5 + delta, scene.height * 0.1);
        interstitialStatus.setPosition(scene.width * 0.5 - delta, scene.height * 0.1);
        scene.addChild(bannerStatus);
        scene.addChild(interstitialStatus);


        director.runScene( scene );

    }

    function loadResources() {
        AssetManager.load(
            {
                prefix: "images/",
                resources: [
                    "background.jpg@background",
                    "button1.png@button1",
                    "button2.png@button2"
                ]},
            function onEnd(resources) {
                init(resources);
            }
        );
    }

    function createButton(text, callback) {

        var normal = new cc.node.Sprite( { frameName: "button1" } );

        var pressed = new cc.node.Sprite( { frameName: "button2" } );
        var item = new cc.MenuItemSprite(normal, pressed, null, callback);
        var text = createText(text, 20);
        text.setPosition(item.width * 0.5, item.height * 0.5);
        item.addChild(text);

        var maxWidth = scene.width * 0.33;
        var maxHeight = scene.height * 0.15;

        if (item.width > maxWidth) {
            var scale = maxWidth/item.width;
            item.setScale(scale, scale);
        }
        if (item.height * item.scaleY > maxHeight) {
            var scale = maxHeight/item.height;
            item.setScale(scale, scale);
        }

        return item;
    }

    function createText(text, size, color) {
        var node = new cc.widget.LabelTTF(text, "Arial");
        if (color) {
            node._fillColor = color;
        }
        node.setFontSize(size);
        node.setAnchorPoint(0.5, 0.5);
        return node;
    }

    if (window.cordova) {
        document.addEventListener("deviceready", loadResources);
    }
    else {
        window.onload = loadResources;
    }


})();







