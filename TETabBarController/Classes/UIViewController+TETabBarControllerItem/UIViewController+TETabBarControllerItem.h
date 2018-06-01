//
//  UIViewController+TETabBarControllerItem.h
//  CustomTabBar
//
//  Created by Timothy Ellis on 31/5/18.
//  Copyright © 2018 Timothy Ellis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TETabBarController;
@class TETabBarItem;

@interface UIViewController (TETabBarControllerItem)

/// Automatically generated lazily with the view controller's title if it's not set explicitly
@property (nonatomic, nonnull) TETabBarItem *teTabBarItem;

/// If the view controller is contained within a tab bar it returns the tab bar. Otherwise it returns nil.
@property (nonatomic, nullable, readonly) TETabBarController *teTabBarController;

@end
