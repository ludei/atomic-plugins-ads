#include "AdsScene.h"



USING_NS_CC;

using namespace ludei::ads;


Scene* AdsScene::createScene(AdProvider provider)
{
    auto scene = Scene::create();
    auto layer = new AdsScene();
    layer->init(provider);
    scene->addChild(layer);
    layer->autorelease();
    return scene;
}

AdsScene::~AdsScene()
{
    delete banner;
    delete interstitial;
    delete adService;
}

// on "init" you need to initialize your instance
bool AdsScene::init(AdProvider provider)
{
    if ( !Layer::init() )
    {
        return false;
    }

    this->setKeypadEnabled(true);
    
    /* 
     * Create the service using the optional provider parameter
     * If not provider specified the services auto instantiates the first one available in the binary
     */
    adService = AdService::create(provider);
    
    AdServiceSettings settings;
    
    
#if CC_TARGET_PLATFORM == CC_PLATFORM_IOS
    if (provider == AdProvider::MOPUB) {
        settings.banner = "agltb3B1Yi1pbmNyDQsSBFNpdGUY5dDoEww";
        settings.bannerTablet = "agltb3B1Yi1pbmNyDQsSBFNpdGUYk8vlEww";
        settings.interstitial = "agltb3B1Yi1pbmNyDQsSBFNpdGUYjf30Eww";
        settings.interstitialTablet = "agltb3B1Yi1pbmNyDQsSBFNpdGUYjf30Eww";
    }
    else if (provider == AdProvider::ADMOB) {
        //pure admob ios
        settings.banner = "ca-app-pub-7686972479101507/8873903476";
        settings.interstitial = "ca-app-pub-7686972479101507/8873903476";
    }
#elif CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID
    if (provider == AdProvider::MOPUB) {
        settings.banner = "agltb3B1Yi1pbmNyDQsSBFNpdGUY5qXqEww";
        settings.interstitial = "agltb3B1Yi1pbmNyDQsSBFNpdGUYjv30Eww";
    }
    else if (provider == AdProvider::ADMOB) {
        //pure admob android
        settings.banner = "ca-app-pub-7686972479101507/4443703872";
        settings.interstitial = "ca-app-pub-7686972479101507/4443703872";
    }
#endif
    
    adService->configure(settings);
    
    banner = adService->createBanner();
    banner->setListener(this);
    interstitial = adService->createInterstitial();
    interstitial->setListener(this);
    
    
    
    Size size = Director::getInstance()->getVisibleSize();


    auto background = Sprite::create("background.jpg");

    double scale =  MAX(size.height/background->getContentSize().height, size.width/background->getContentSize().width);
    background->setScale(scale);
    background->setPosition(Vec2(size.width * 0.5, size.height * 0.5));
    
    this->addChild(background, 0);
    
    
    MenuItemImage * btnShowBanner = createButton("Show banner", [=](Ref* sender){
        banner->show();
    });
    
    MenuItemImage * btnHideBanner = createButton("Hide banner", [=](Ref* sender){
        banner->hide();
    });
    
    mode = 0;
    MenuItemImage * btnChangePositionBanner = createButton("Change position", [=](Ref* sender){
        mode = (mode + 1) % 3;
        switch (mode) {
            case 0:
                banner->setLayout(AdBannerLayout::TOP_CENTER);
                break;
            case 1:
                banner->setLayout(AdBannerLayout::BOTTOM_CENTER);
                break;
            default:
                banner->setLayout(AdBannerLayout::CUSTOM);
                banner->setPosition(10, 10);
                break;
        }
        
    });
    
    MenuItemImage * btnLoadBanner = createButton("Load banner", [=](Ref* sender){
        lblBannerStatus->setString("Loading banner");
        banner->load();
    });
    
    MenuItemImage * btnShowInterstitial = createButton("Show interstitial", [=](Ref* sender){
        interstitial->show();
    });
    
    MenuItemImage * btnLoadInterstitial = createButton("Load interstitial", [=](Ref* sender){
        lblInterstitialStatus->setString("Loading interstitial");
        interstitial->load();
    });
    
    
    const float padding = 10;
    const float buttonWidth = btnShowBanner->getContentSize().width * btnShowBanner->getScale();
    const float buttonHeight = btnShowBanner->getContentSize().height * btnShowBanner->getScale();
    
    auto bannerMenu = CCMenu::create(btnShowBanner, btnHideBanner, btnChangePositionBanner, btnLoadBanner, NULL);
    bannerMenu->alignItemsVerticallyWithPadding(padding);
    bannerMenu->setPosition(Vec2(size.width * 0.5 + buttonWidth * 0.75
                                 , size.height * 0.5));

    
    auto interstitialMenu = CCMenu::create(btnShowInterstitial, btnLoadInterstitial,  NULL);
    interstitialMenu->alignItemsVerticallyWithPadding(padding);
    interstitialMenu->setPosition(Vec2(size.width * 0.5 - buttonWidth * 0.75
                                 , size.height * 0.5  + buttonHeight + padding));
    
    this->addChild(bannerMenu);
    this->addChild(interstitialMenu);
    
    lblBannerStatus = Label::createWithSystemFont("Created", "Verdana", buttonHeight * 0.4);
    lblBannerStatus->setPosition(Vec2(bannerMenu->getPosition().x, size.height * 0.5 - buttonHeight * 2 - padding * 3));
    lblBannerStatus->setColor(Color3B(50, 50, 50));
    
    lblInterstitialStatus = Label::createWithSystemFont("Created", "Verdana", buttonHeight * 0.4);
    lblInterstitialStatus->setPosition(Vec2(interstitialMenu->getPosition().x, interstitialMenu->getPosition().y - buttonHeight - padding * 3));
    lblInterstitialStatus->setColor(Color3B(50, 50, 50));
    
    this->addChild(lblBannerStatus);
    this->addChild(lblInterstitialStatus);
    
    MenuItem * backItem = createButton("Back", [](Ref * sender){
        Director::getInstance()->popScene();
    });
    backItem->setScale(0.5);
    
    Menu * backMenu = Menu::createWithItem(backItem);
    backMenu->setPosition(Vec2(backItem->getContentSize().width * backItem->getScale() * 0.5,
                               size.height - backItem->getContentSize().height * backItem->getScale() * 0.5));
    this->addChild(backMenu);
    
    return true;
}

void AdsScene::onKeyReleased(EventKeyboard::KeyCode keyCode, Event* event)
{
    if (keyCode == EventKeyboard::KeyCode::KEY_BACK)
    {
        Director::getInstance()->popScene();
    }
    else {
        CCLayer::onKeyReleased(keyCode, event);
    }
}

MenuItemImage * AdsScene::createButton(const char * text, const cocos2d::ccMenuCallback & callback)
{
    auto item = MenuItemImage::create("button1.png", "button2.png", callback);
    auto label = Label::createWithSystemFont(text, "Arial", item->getContentSize().height * 0.33);
    label->setPosition(Vec2(item->getContentSize().width/2, item->getContentSize().height/2));
    item->addChild(label);
    return item;
}


#pragma mark Banner Listener

void AdsScene::onLoaded(AdBanner * banner)
{
    CCLOGINFO("Banner loaded");
    lblBannerStatus->setString("Banner loaded");
}

void AdsScene::onFailed(AdBanner * banner, int32_t code, const std::string & message)
{
    CCLOGINFO("Banner failed");
    lblBannerStatus->setString("Banner failed");
}

void AdsScene::onClicked(AdBanner * banner)
{
    CCLOGINFO("Banner clicked");
    lblBannerStatus->setString("Banner clicked");
}

void AdsScene::onExpanded(AdBanner * banner)
{
    CCLOGINFO("Banner expanded");
    lblBannerStatus->setString("Banner expanded");
}

void AdsScene::onCollapsed(AdBanner * banner)
{
    CCLOGINFO("Banner collapsed");
    lblBannerStatus->setString("Banner collapsed");
}

#pragma mark Interstitial Listener

void AdsScene::onLoaded(AdInterstitial * interstitial)
{
    CCLOGINFO("Interstitial loaded");
    lblInterstitialStatus->setString("Interstitial loaded");
}

void AdsScene::onFailed(AdInterstitial * interstitial, int32_t code, const std::string & message)
{
    CCLOGINFO("Interstitial failed");
    lblInterstitialStatus->setString("Interstitial failed");
}

void AdsScene::onClicked(AdInterstitial * interstitial)
{
    CCLOGINFO("Interstitial clicked");
    lblInterstitialStatus->setString("Interstitial clicked");
}

void AdsScene::onShown(AdInterstitial * interstitial)
{
    CCLOGINFO("Interstitial shown");
    lblInterstitialStatus->setString("Interstitial shown");
}

void AdsScene::onHidden(AdInterstitial * interstitial)
{
    CCLOGINFO("Interstitial hidden");
    lblInterstitialStatus->setString("Interstitial hidden");
}

