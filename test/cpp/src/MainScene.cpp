#include "MainScene.h"
#include "AdsScene.h"

USING_NS_CC;


Scene* MainScene::createScene()
{
    auto scene = Scene::create();
    auto layer = MainScene::create();
    scene->addChild(layer);
    return scene;
}

// on "init" you need to initialize your instance
bool MainScene::init()
{
    if ( !Layer::init() )
    {
        return false;
    }
    
    
    Size size = Director::getInstance()->getVisibleSize();

    auto background = Sprite::create("background.jpg");

    double scale =  MAX(size.height/background->getContentSize().height, size.width/background->getContentSize().width);
    background->setScale(scale);
    background->setPosition(Vec2(size.width * 0.5, size.height * 0.5));
    
    this->addChild(background, 0);
    
    MenuItemImage * btnMoPub = createButton("MoPub", [=](Ref* sender){
        
        Director::getInstance()->pushScene(AdsScene::createScene(AdProvider::MOPUB));

    });
    
    MenuItemImage * btnAdMob = createButton("AdMob", [=](Ref* sender){
        Director::getInstance()->pushScene(AdsScene::createScene(AdProvider::ADMOB));
    });
    
    
    Menu * menu = Menu::create(btnMoPub, btnAdMob, NULL);
    menu->alignItemsVerticallyWithPadding(20);
    menu->setPosition(Vec2(size.width/2, size.height/2));
    this->addChild(menu);
    
    return true;
}

MenuItemImage * MainScene::createButton(const char * text, const cocos2d::ccMenuCallback & callback)
{
    auto item = MenuItemImage::create("button1.png", "button2.png", callback);
    auto label = Label::createWithSystemFont(text, "Arial", item->getContentSize().height * 0.33);
    label->setPosition(Vec2(item->getContentSize().width/2, item->getContentSize().height/2));
    item->addChild(label);
    return item;
}