//
//  TETabBarDelegate.h
//  CustomTabBar
//
//  Created by Timothy Ellis on 29/5/18.
//  Copyright © 2018 Timothy Ellis. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TETabBar;
@class TETabBarItem;

@protocol TETabBarDelegate <NSObject>
@optional

/**
 Called when a new tab is selected by the user.

 @param tabBar The tab bar.
 @param item The tab bar item that was selected.
 */
- (void)tabBar:(TETabBar *)tabBar didSelectItem:(TETabBarItem *)item;

/**
 Called when the same tab is selected by the user.
 
 @param tabBar The tab bar.
 @param item The tab bar item that was selected.
 */
- (void)tabBar:(TETabBar *)tabBar didSelectSameItem:(TETabBarItem *)item;

/**
 Called when a new tab wants to be selected.
 
 @param tabBar The tab bar.
 @param item The tab bar item that was selected.
 @return YES if the item should be selected or NO if you don't want to allow the item to be selected.
 */
- (BOOL)tabBar:(TETabBar *)tabBar shouldSelectItem:(TETabBarItem *)item;


@end
