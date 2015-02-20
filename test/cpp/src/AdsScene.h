#pragma once

#include "cocos2d.h"

#include "AdService.h"
using namespace ludei::ads;


class AdsScene : public cocos2d::Layer, public ludei::ads::AdBannerListener, public ludei::ads::AdInterstitialListener
{
public:
    static cocos2d::Scene* createScene(AdProvider provider);
    ~AdsScene();

    virtual bool init(AdProvider provider);
    
protected:
    cocos2d::MenuItemImage * createButton(const char * text, const cocos2d::ccMenuCallback & callback);
    AdService * adService;
    AdBanner * banner;
    AdInterstitial * interstitial;
    cocos2d::Label * lblBannerStatus;
    cocos2d::Label * lblInterstitialStatus;
    int mode;
    
    virtual void onKeyReleased(cocos2d::EventKeyboard::KeyCode keyCode, cocos2d::Event* event) override;
    
    
    //banner listener
    virtual void onLoaded(AdBanner * banner) override;
    virtual void onFailed(AdBanner * banner, int32_t code, const std::string & message) override;
    virtual void onClicked(AdBanner * banner) override;
    virtual void onExpanded(AdBanner * banner) override;
    virtual void onCollapsed(AdBanner * banner) override;
    
    //interstitial listener
    virtual void onLoaded(AdInterstitial * interstitial) override;
    virtual void onFailed(AdInterstitial * interstitial, int32_t code, const std::string & message) override;
    virtual void onClicked(AdInterstitial * interstitial) override;
    virtual void onShown(AdInterstitial * interstitial) override;
    virtual void onHidden(AdInterstitial * interstitial) override;
};

