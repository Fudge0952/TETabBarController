//
//  TETabBarButton.h
//  CustomTabBar
//
//  Created by Timothy Ellis on 30/5/18.
//  Copyright © 2018 Timothy Ellis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TETabBarItem;

@interface TETabBarButton : UIControl

+ (nonnull instancetype)buttonWithItem:(nonnull TETabBarItem *)item;

- (void)didChangeDisplayStyle;

/// Adds a long press gesture with the specified target and action
- (void)addLongPressTarget:(nonnull id)target action:(nonnull SEL)action;

@end
