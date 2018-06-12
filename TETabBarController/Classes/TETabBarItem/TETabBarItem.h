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

/// The title of the view controller. This value will match the value of the view controller's title.
@property (nonatomic, nullable) NSString *title;

@property (nonatomic, nullable) UIImage *image;

/// Optional image to be shown when selected. Will use image if nil
@property (nonatomic, nullable) UIImage *selectedImage;

/**
 Whether or not the option can be selected (this is different from highlighted).
 If this is set to YES then the option can be selected like a radio option.
 If this is set to NO then the option can still be tapped however the selection won't persist.
 Defaults to YES.
 */
@property (nonatomic) BOOL isSelectable;

@property (nonatomic, readonly) NSUInteger index;
@property (nonatomic, readonly) TETabBarItemStyle style;

@end
