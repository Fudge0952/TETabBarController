#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "TETabBar.h"
#import "TETabBarDelegate.h"
#import "TETabBarButton.h"
#import "TETabBarController.h"
#import "TETabBarItem.h"
#import "UIViewController+TETabBarControllerItem.h"

FOUNDATION_EXPORT double TETabBarControllerVersionNumber;
FOUNDATION_EXPORT const unsigned char TETabBarControllerVersionString[];

