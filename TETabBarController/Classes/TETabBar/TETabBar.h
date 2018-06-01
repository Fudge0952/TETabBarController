//
//  TETabBar.h
//  CustomTabBar
//
//  Created by Timothy Ellis on 29/5/18.
//  Copyright © 2018 Timothy Ellis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TETabBarItem.h"

@class TETabBarItem;
@protocol TETabBarDelegate;

@interface TETabBar : UIView

/**
 The items displayed by the tab bar.
 
 gets/sets visible TETabBarItem's. Default is nil. Changes are not animated. Shown in order.
 */
@property (nonatomic, nullable, copy) NSArray <TETabBarItem *> *items;

/// The currently selected item or nil if no item is selected. Setting this value will adjust the selected item.
@property (nonatomic, nullable, weak) TETabBarItem *selectedItem;

///// The tint color to apply to the tab bar background. Default is nil.
//@property (nonatomic, nullable) UIColor *barTintColor UI_APPEARANCE_SELECTOR;

@property (nonatomic, nullable, weak) id<TETabBarDelegate> delegate;

/// The inset to be applied to the bottom of the tab bar. Default is 0.
@property (nonatomic) CGFloat bottomInset;

@end
