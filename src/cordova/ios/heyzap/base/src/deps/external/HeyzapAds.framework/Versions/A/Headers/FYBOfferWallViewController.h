//
//
// Copyright (c) 2016 Fyber. All rights reserved.
//
//

#import <UIKit/UIKit.h>

#import "FYBRequestParameters.h"

/**
 *  Class related to the Offer Wall product
 */
@interface FYBOfferWallViewController : UIViewController

/**
 *  A Boolean that indicates whether the Offer Wall will be dismissed as soon as the user leaves the application
 *
 *  @discussion The default value of this property is NO
 */
@property (nonatomic, assign) BOOL shouldDismissOnRedirect;

/**
 *  Sets if the close button will be displayed while the Offer Wall is loading
 *
 *  @warning This property is not evaluated if the key FYBOFWShowCloseOnLoad is set in the Info file
 */
@property (nonatomic, assign) BOOL showCloseButtonOnLoad __attribute__((deprecated("This property is deprecated in SDK 8.3.1")));

/**
 *  Presents the Offer Wall view controller on top of the passed view controller
 *
 *  @param viewController The view controller parent of the Offer Wall view controller
 *  @param animated       Pass YES to animate the presentation; otherwise, pass NO
 *  @param completion     The block to execute after the presentation finishes. If an error occurred, the error parameter describes the error otherwise this value is nil. You may specify nil for this parameter
 *  @param dismiss        The block to execute after the Offer Wall is dismissed. You may specify nil for this parameter
 */
- (void)presentFromViewController:(UIViewController *)viewController
                         animated:(BOOL)animated
                       completion:(void (^)(void))completion
                          dismiss:(void (^)(NSError *error))dismiss;

/**
 *  Presents the Offer Wall view controller on top of the passed view controller
 *
 *  @param viewController The view controller parent of the Offer Wall view controller
 *  @param parameters     Parameters that you can pass onto the Offer Wall to configure it
 *  @param animated       Pass YES to animate the presentation; otherwise, pass NO
 *  @param completion     The block to execute after the presentation finishes. If an error occurred, the error parameter describes the error otherwise this value is nil. You may specify nil for this parameter
 *  @param dismiss        The block to execute after the Offer Wall is dismissed. You may specify nil for this parameter
 *
 *  @see FYBRequestParameters
 */
- (void)presentFromViewController:(UIViewController *)viewController
                       parameters:(FYBRequestParameters *)parameters
                         animated:(BOOL)animated
                       completion:(void (^)(void))completion
                          dismiss:(void (^)(NSError *error))dismiss;

@end
