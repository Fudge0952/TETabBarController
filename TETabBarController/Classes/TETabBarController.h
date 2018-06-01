//
//  TETabBarController.h
//  CustomTabBar
//
//  Created by Timothy Ellis on 29/5/18.
//  Copyright © 2018 Timothy Ellis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+TETabBarControllerItem.h"
#import "TETabBar.h"
#import "TETabBarDelegate.h"

@interface TETabBarController : UIViewController <TETabBarDelegate>

/// An array of the root view controllers displayed by the tab bar interface.
@property (nonatomic, nullable, copy) NSArray<__kindof UIViewController *> *viewControllers;

/**
 This view controller is the one whose custom view is currently displayed by the tab bar interface.
 The specified view controller must be in the viewControllers array. Assigning a new view controller
 to this property changes the currently displayed view and also selects an appropriate tab in the
 tab bar. Changing the view controller also updates the selectedIndex property accordingly.
 The default value of this property is nil.
 */
@property (nonatomic, nullable, weak) __kindof UIViewController *selectedViewController;

/**
 This property represents an index into the array of the viewControllers property. Setting this
 property changes the selected view controller to the one at the designated index in the viewControllers array.
 */
@property (nonatomic) NSUInteger selectedIndex;

/**
 You should never attempt to manipulate the TETabBar object itself stored in this property. If you attempt to do so,
 the tab bar view throws an exception. To configure the items for your tab bar interface, you should instead assign
 one or more custom view controllers to the viewControllers property. The tab bar collects the needed tab bar items
 from the view controllers you specify.
 */
@property (nonatomic, nonnull, readonly) TETabBar *tabBar;

- (void)addLongPressTarget:(nonnull id)target action:(nonnull SEL)action toViewControllerTab:(nonnull UIViewController *)viewController;

@end
