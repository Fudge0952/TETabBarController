//
//  TETabBarItem.m
//  CustomTabBar
//
//  Created by Timothy Ellis on 29/5/18.
//  Copyright © 2018 Timothy Ellis. All rights reserved.
//

#import "TETabBarItem.h"
#import "TETabBarButton.h"

//static CGFloat const TETabBarItemTextImagePadding = 8.0f;

@interface TETabBarItem ()
@property (nonatomic, readwrite) TETabBarItemStyle style;
@property (nonatomic, readwrite) NSUInteger index;
@end

@implementation TETabBarItem

- (instancetype)init {
	if (self = [super init]) {
		self.style = TETabBarItemStyleRegular;
		self.isSelectable = YES;
		self.index = NSNotFound;
	}
	return self;
}

- (id)copyWithZone:(NSZone *)zone {
	typeof(self) copy = [[self class] allocWithZone:zone];
	copy.title = [self.title copyWithZone:zone];
	copy.image = [[UIImage allocWithZone: zone] initWithCGImage: self.image.CGImage];
	return copy;
}

- (TETabBarButton *)generateButton {
	TETabBarButton *button = [TETabBarButton buttonWithItem:self];
	button.translatesAutoresizingMaskIntoConstraints = NO;
	button.clipsToBounds = YES;
	return button;
}

@end
