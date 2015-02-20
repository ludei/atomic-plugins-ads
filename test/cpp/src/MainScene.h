#pragma once
#include "cocos2d.h"


class MainScene : public cocos2d::Layer
{
public:
    static cocos2d::Scene* createScene();

    virtual bool init();
    
    CREATE_FUNC(MainScene);
protected:
    cocos2d::MenuItemImage * createButton(const char * text, const cocos2d::ccMenuCallback & callback);
};

