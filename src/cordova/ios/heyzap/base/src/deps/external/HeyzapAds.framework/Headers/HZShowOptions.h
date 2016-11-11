//
//  HZShowOptions.h
//  Heyzap
//
//  Created by Maximilian Tagher on 7/11/16.
//  Copyright © 2016 Heyzap. All rights reserved.
//

#import <UIKit/UIKit.h>

/** HZShowOptions allows you to pass options to configure how ads are shown */
@interface HZShowOptions : NSObject

/**
 *  @discussion A UIViewController that should present the ad being shown. If not specified the application's key window's root view controller is used.
 */
@property (nonatomic, weak) UIViewController *viewController;

/**
 *  @discussion An identifier for the location of the ad, which you can use to disable the ad from your dashboard. If not specified the tag "default" is always used.
 */
@property (nonatomic, strong) NSString *tag;

/**
 *  @discussion A block called when the ad is shown or fails to show. `result` states whether the show was successful; the error object describes the issue, if there was one.
 */
@property (nonatomic, copy) void (^completion)(BOOL result, NSError *error);

/**
 *  @discussion When an incentivized video is completed, this string will be sent to your server via our server-to-server callbacks. Set it to anything you want to pass to your server regarding this incentivized video view (i.e.: a username, user ID, level name, etc.), or leave it `nil` if you don't need to use it / aren't using server callbacks for incentivized video. This parameter will be ignored for ads shown via classes other than `HZIncentivizedAd`.
 */
@property (nonatomic, strong) NSString *incentivizedInfo;

@end
