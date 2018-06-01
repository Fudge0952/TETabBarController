//
//  TETabBarItem.h
//  CustomTabBar
//
//  Created by Timothy Ellis on 29/5/18.
//  Copyright © 2018 Timothy Ellis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TETabBarButton;

typedef NS_ENUM(NSInteger, TETabBarItemStyle) {
	TETabBarItemStyleRegular = 0,
	TETabBarItemStyleCompact
};

@interface TETabBarItem : NSObject <NSCopying>

@property (nonatomic, nullable) NSString *title;
@property (nonatomic, nullable) UIImage *image;

@property (nonatomic) BOOL isSelectable;

@property (nonatomic, readonly) NSUInteger index;
@property (nonatomic, readonly) TETabBarItemStyle style;

@end
