//
//  UIViewController+TETabBarControllerItem.m
//  CustomTabBar
//
//  Created by Timothy Ellis on 31/5/18.
//  Copyright © 2018 Timothy Ellis. All rights reserved.
//

#import "UIViewController+TETabBarControllerItem.h"
#import "TETabBarController.h"
#import "TETabBarItem.h"
#import <objc/runtime.h>

static const void *TETabBarItemAssocKey = &TETabBarItemAssocKey;

@implementation UIViewController (TETabBarControllerItem)

- (TETabBarItem *)teTabBarItem {
	if ([self isKindOfClass:UINavigationController.class]) {
		UINavigationController *navController = (UINavigationController *)self;
		if (navController.topViewController && ![navController.topViewController isEqual:self]) {
			return [navController.topViewController teTabBarItem];
		}
	}
	TETabBarItem *item = objc_getAssociatedObject(self, TETabBarItemAssocKey);
	if (!item) {
		item = [TETabBarItem new];
		item.title = self.title;
		[self setTeTabBarItem:item];
	}
	return item;
}

- (void)setTeTabBarItem:(TETabBarItem *)teTabBarItem {
	if ([self isKindOfClass:UINavigationController.class]) {
		UINavigationController *navController = (UINavigationController *)self;
		if (navController.topViewController && ![navController.topViewController isEqual:self]) {
			return [navController.topViewController setTeTabBarItem:teTabBarItem];
		}
	}
	objc_setAssociatedObject(self, TETabBarItemAssocKey, teTabBarItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (TETabBarController *)teTabBarController {
	if (self.parentViewController) {
		if ([self.parentViewController isKindOfClass:TETabBarController.class]) {
			return (TETabBarController *)self.parentViewController;
		}
		return [self.parentViewController teTabBarController];
	}
	if (self.navigationController) {
		return [self.navigationController teTabBarController];
	}
	return nil;
}

@end
