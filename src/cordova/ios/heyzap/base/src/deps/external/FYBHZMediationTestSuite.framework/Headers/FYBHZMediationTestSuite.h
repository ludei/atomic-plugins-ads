//
//  FYBHZMediationTestSuite.h
//  FYBHZMediationTestSuite
//
//  Created by Monroe Ekilah on 6/13/16.
//  Copyright © 2016 heyzap.com. All rights reserved.
//


// In this header, you should import all the public headers of your framework using statements like #import <TestSuite/PublicHeader.h>


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FYBHZMediationTestSuite : NSObject

+ (void)show;
+ (void)showFromViewController:(UIViewController *)viewController;

@end
