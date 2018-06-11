//
//  TETabBar.m
//  CustomTabBar
//
//  Created by Timothy Ellis on 29/5/18.
//  Copyright © 2018 Timothy Ellis. All rights reserved.
//

#import "TETabBar.h"
#import "TETabBarDelegate.h"
#import "TETabBarButton.h"

static CGFloat const TETabBarRegularHeight = 49.0f;
static CGFloat const TETabBarCompactHeight = 32.0f;
static CGFloat const TETabBarBackgroundWhiteAmount = 248.0f/255.0f;
static CGFloat const TETabBarTopLineWhiteAmount = 217.0f/255.0f;

@interface TETabBarItem (Private)
- (__kindof TETabBarButton *)generateButton;
@property (nonatomic, readwrite) TETabBarItemStyle style;
@property (nonatomic, readwrite) NSUInteger index;
@end

@interface TETabBar ()

// UI
@property (nonatomic, nonnull) NSMutableArray <TETabBarButton *> *buttons;
@property (nonatomic, nonnull) UIView *topLineView;

// Constraints
@property (nonatomic, nullable) NSLayoutConstraint *buttonVerticalConstraint;

@end

@implementation TETabBar

#pragma mark - Setters

- (void)setItems:(NSArray<TETabBarItem *> *)items {
	_items = [items copy];
	[self updateDisplayedButtons];
}

- (void)setSelectedItem:(TETabBarItem *)selectedItem {
	NSUInteger itemIndex = [self.items indexOfObject:selectedItem];
	if (itemIndex != NSNotFound) {
		TETabBarItem *item = self.items[itemIndex];
		TETabBarButton *button = self.buttons[itemIndex];
		[self selectButton:button withItem:item];
	}
}

- (void)setBottomInset:(CGFloat)bottomInset {
	_bottomInset = bottomInset;
	if (self.buttonVerticalConstraint) {
		self.buttonVerticalConstraint.constant = -_bottomInset;
	}
	[self invalidateIntrinsicContentSize];
}

#pragma mark - Inits

- (instancetype)init {
	if (self = [super init]) {
		[self commonInit];
	}
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder]) {
		[self commonInit];
	}
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self commonInit];
	}
	return self;
}

- (void)commonInit {
	self.bottomInset = 0.0f;
	self.buttons = [NSMutableArray new];
	self.backgroundColor = [UIColor colorWithWhite:TETabBarBackgroundWhiteAmount alpha:1.0f];
	
	self.topLineView = [UIView new];
	self.topLineView.translatesAutoresizingMaskIntoConstraints = NO;
	self.topLineView.backgroundColor = [UIColor colorWithWhite:TETabBarTopLineWhiteAmount alpha:1.0f];
	[self addSubview:self.topLineView];
	[self setupConstraints];
}

- (void)setupConstraints {
	[NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_topLineView]|"
																					options:0
																					metrics:nil
																					  views:NSDictionaryOfVariableBindings(_topLineView)
											 ]
	 ];
	[NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_topLineView]"
																					options:0
																					metrics:nil
																					  views:NSDictionaryOfVariableBindings(_topLineView)
											 ]
	 ];
	[NSLayoutConstraint constraintWithItem:self.topLineView
								 attribute:NSLayoutAttributeHeight
								 relatedBy:NSLayoutRelationEqual
									toItem:nil
								 attribute:NSLayoutAttributeNotAnAttribute
								multiplier:1.0f
								  constant:1.0f
	 ].active = YES;
}

#pragma mark - Overrides

- (CGSize)intrinsicContentSize {
	CGSize size = [super intrinsicContentSize];
	CGFloat height = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? TETabBarCompactHeight : TETabBarRegularHeight;
	TETabBarItemStyle style = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? TETabBarItemStyleCompact : TETabBarItemStyleRegular;
	NSInteger idx = 0;
	for (TETabBarItem *item in self.items) {
		item.style = style;
		TETabBarButton *button = self.buttons[idx++];
		[button didChangeDisplayStyle];
	}
	size.height = height + self.bottomInset;
	return size;
}

- (CGSize)sizeThatFits:(CGSize)size {
	CGSize superSize = [super sizeThatFits:size];
	superSize.height = TETabBarRegularHeight + self.bottomInset;
	return superSize;
}

#pragma mark - Buttons

- (void)selectButtonAtIndex:(NSInteger)index {
	for (TETabBarButton *b in self.buttons) {
		b.selected = (index == b.tag);
	}
	if (index < self.items.count) {
		_selectedItem = self.items[index];
	}
}

- (void)selectButton:(TETabBarButton *)button withItem:(TETabBarItem *)item {
	if (self.selectedItem && self.selectedItem.index == item.index) {
		if (self.delegate && [self.delegate respondsToSelector:@selector(tabBar:didSelectSameItem:)]) {
			[self.delegate tabBar:self didSelectSameItem:item];
		}
		return;
	}

	if (self.delegate && [self.delegate respondsToSelector:@selector(tabBar:didSelectItem:)]) {
		[self.delegate tabBar:self didSelectItem:item];
	}
	if (self.delegate && [self.delegate respondsToSelector:@selector(tabBar:shouldSelectItem:)]) {
		if (![self.delegate tabBar:self shouldSelectItem:item]) {
			return;
		}
	}
	else if (!item.isSelectable) {
		return;
	}
	if (button) {
		[self selectButtonAtIndex:item.index];
	}
}

- (void)actionButtonTapped:(TETabBarButton *)sender {
	if (sender.tag >= self.items.count) {
		@throw [NSException exceptionWithName:NSInternalInconsistencyException
									   reason:@"The tabBar action could not be correctly mapped to an action index (index out of bounds)"
									 userInfo:nil
				];
		return;
	}
	TETabBarItem *item = self.items[sender.tag];
	[self selectButton:sender withItem:item];
}

- (void)updateDisplayedButtons {
	for (TETabBarButton *button in self.buttons) {
		[button removeFromSuperview];
	}
	[self.buttons removeAllObjects];
	
	NSInteger buttonIdx = 0;
	for (TETabBarItem *item in self.items) {
		item.index = buttonIdx;
		TETabBarButton *button = [item generateButton];
		button.tag = buttonIdx++;
		[button addTarget:self action:@selector(actionButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
		
		[self addSubview:button];
		[self.buttons addObject:button];
	}
	
	[self updateButtonConstraints];
	if (self.selectedItem) {
		[self selectButtonAtIndex:self.selectedItem.index];
	}
}

- (void)updateButtonConstraints {
	if (self.buttons.count == 0) {
		return;
	}
	TETabBarButton *firstButton = self.buttons.firstObject;
	
	// Vertical Constraints
	[NSLayoutConstraint constraintWithItem:firstButton
								 attribute:NSLayoutAttributeTop
								 relatedBy:NSLayoutRelationEqual
									toItem:self
								 attribute:NSLayoutAttributeTop
								multiplier:1.0f
								  constant:0.0f
	 ].active = YES;
	self.buttonVerticalConstraint = [NSLayoutConstraint constraintWithItem:firstButton
																 attribute:NSLayoutAttributeBottom
																 relatedBy:NSLayoutRelationEqual
																	toItem:self
																 attribute:NSLayoutAttributeBottom
																multiplier:1.0f
																  constant:-_bottomInset
									 ];
	self.buttonVerticalConstraint.active = YES;
	
	// Horizontal Contraints
	NSMutableString *xVisualFormat = [NSMutableString stringWithString:@"H:|"];
	NSMutableDictionary <NSString*, TETabBarButton*>*xViews = [NSMutableDictionary new];
	
	NSString *prevButtonName = nil;
	NSInteger buttonIdx = 0;
	for (TETabBarButton *currentButton in self.buttons) {
		NSString *buttonName = [NSString stringWithFormat:@"button%ld", (long)buttonIdx];
		[xViews setObject:currentButton forKey:buttonName];
		if (prevButtonName != nil) {
			// Apply the constraint with a priority of 999 (1 less than requried). This is so that if we want a
			//  button to have a compressed width, it can override this constraint as it will have a higher priority.
			[xVisualFormat appendFormat:@"[%@(==%@@999)]", buttonName, prevButtonName];
		}
		else {
			[xVisualFormat appendFormat:@"[%@]", buttonName];
		}
		prevButtonName = buttonName;
		buttonIdx++;
	}
	
	[xVisualFormat appendString:@"|"];
	NSArray *xConstraints = [NSLayoutConstraint constraintsWithVisualFormat: xVisualFormat
																	options: NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom
																	metrics: nil
																	  views: xViews
							 ];
	[NSLayoutConstraint activateConstraints:xConstraints];
	for (TETabBarButton *button in self.buttons) {
		[button invalidateIntrinsicContentSize];
	}
}

@end
