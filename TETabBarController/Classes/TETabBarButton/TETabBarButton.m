//
//  TETabBarButton.m
//  CustomTabBar
//
//  Created by Timothy Ellis on 30/5/18.
//  Copyright © 2018 Timothy Ellis. All rights reserved.
//

#import "TETabBarButton.h"
#import "TETabBarItem.h"

static CGFloat const TETabBarButtonUnselectedWhiteAmount = 0.57f;
static CGFloat const TETabBarButtonIsPressedWhiteAmount = 0.37f;

static CGFloat const TETabBarButtonRegularImageSize = 30.0f;
static CGFloat const TETabBarButtonRegularEdgePadding = 4.0f;
static CGFloat const TETabBarButtonCompactImageSize = 20.0f;
static CGFloat const TETabBarButtonCompactObjectPadding = 4.0f;

static CGFloat const TETabBarButtonRegulatFontSize = 10.0f;
static CGFloat const TETabBarButtonCompactFontSize = 12.0f;

static void * TETabBarButtonContext = &TETabBarButtonContext;

@interface TETabBarButton ()

@property (nonatomic, nonnull) UIColor *highlightedTintColor;
@property (nonatomic, nullable, weak) TETabBarItem *item;

@property (nonatomic, nonnull) UIImageView *imageView;
@property (nonatomic, nonnull) UILabel *titleLabel;

@property (nonatomic) TETabBarItemStyle constrainedStyle;
@property (nonatomic, nonnull) NSArray <NSLayoutConstraint *> *currentConstraints;

@property (nonatomic, nonnull) NSMutableArray <NSArray <NSValue *> *> *longPressTargets;
@property (nonatomic, nullable) UILongPressGestureRecognizer *longPressGestureRecognizer;

@end

@implementation TETabBarButton

#pragma mark - Lifecycle

+ (instancetype)buttonWithItem:(TETabBarItem *)item {
	return [[self alloc] initWithItem:item];
}

- (instancetype)initWithItem:(nonnull TETabBarItem *)item {
	if (self = [super init]) {
		self.item = item;
		[self commonInit];
	}
	return self;
}

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

- (void)dealloc {
	@try {
		NSArray <NSString *> *keyPathsToObserve = @[
			NSStringFromSelector(@selector(title)),
			NSStringFromSelector(@selector(image)),
			NSStringFromSelector(@selector(selectedImage)),
		];
		for (NSString *keyPath in keyPathsToObserve) {
			[self.item removeObserver:self
						   forKeyPath:keyPath
							  context:TETabBarButtonContext
			 ];
		}
	}
	@catch (NSException *exception) {}
}

- (void)commonInit {
	if ([self setupObjects]) {
		[self setupConstraints];
	}
	if (self.item) {
		if (self.item.image) {
			self.imageView.image = [self.item.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		}
		if (self.item.title) {
			self.titleLabel.text = self.item.title;
		}
		if (!self.item.isSelectable) {
			self.imageView.tintColor = [self highlightedTintColor];
		}
		NSArray <NSString *> *keyPathsToObserve = @[
			NSStringFromSelector(@selector(title)),
			NSStringFromSelector(@selector(image)),
			NSStringFromSelector(@selector(selectedImage)),
		];
		for (NSString *keyPath in keyPathsToObserve) {
			[self.item addObserver:self
						forKeyPath:keyPath
						   options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
						   context:TETabBarButtonContext
			 ];
		}
	}
}

- (BOOL)setupObjects {
	self.longPressTargets = [NSMutableArray new];
	
	if (self.imageView && self.titleLabel) {
		return NO;
	}
	
	self.imageView = [self generateImageView];
	[self addSubview:self.imageView];
	
	self.titleLabel = [self generateLabel];
	[self addSubview:self.titleLabel];
	
	return YES;
}

- (void)setupConstraints {
	self.currentConstraints = [self getConstraintsForCurrentStyle];
	self.constrainedStyle = [self getItemStyle];
	[NSLayoutConstraint activateConstraints:self.currentConstraints];
}

- (void)addLongPressTarget:(id)target action:(SEL)action {
	NSValue *targetValue = [NSValue valueWithNonretainedObject:target];
	NSValue *actionValue = [NSValue valueWithPointer:action];
	[self.longPressTargets addObject:@[
									   targetValue,
									   actionValue,
									   ]];
	if (!self.longPressGestureRecognizer) {
		self.longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPressWithGestureRecognizer:)];
		[self addGestureRecognizer:self.longPressGestureRecognizer];
	}
}

- (void)didLongPressWithGestureRecognizer:(UILongPressGestureRecognizer *)gestureRecognizer {
	if (gestureRecognizer.state != UIGestureRecognizerStateBegan) {
		return;
	}
	for (NSArray <NSValue *> *arrayValues in self.longPressTargets) {
		id target = [arrayValues objectAtIndex:0].nonretainedObjectValue;
		if (!target) {
			continue;
		}
		SEL selector = (SEL)[arrayValues objectAtIndex:1].pointerValue;
		if (!selector) {
			continue;
		}
		IMP imp = [target methodForSelector:selector];
		void (*func)(id, SEL, id) = (void *)imp;
		func(target, selector, self);
	}
}

#pragma mark -

/// This is called by the tab bar when the display mode changes.
- (void)didChangeDisplayStyle {
	if (self.item && self.constrainedStyle != self.item.style) {
		[NSLayoutConstraint deactivateConstraints:self.currentConstraints];
		self.currentConstraints = [self getConstraintsForCurrentStyle];
		self.constrainedStyle = [self getItemStyle];
		[NSLayoutConstraint activateConstraints:self.currentConstraints];
		if (self.titleLabel) {
			self.titleLabel.font = [self getLabelFontForCurrentStyle];
		}
	}
}

- (TETabBarItemStyle)getItemStyle {
	if (self.item) {
		return self.item.style;
	}
	return TETabBarItemStyleRegular;
}

- (NSArray <NSLayoutConstraint *> *)getConstraintsForCurrentStyle {
	return [self getConstraintsForStyle:[self getItemStyle]];
}

- (NSArray <NSLayoutConstraint *> *)getConstraintsForStyle:(TETabBarItemStyle)style {
	switch (style) {
		case TETabBarItemStyleRegular: {
			return [self getConstraintsForRegularStyle];
		}
		case TETabBarItemStyleCompact: {
			return [self getConstraintsForCompactStyle];
		}
	}
}

- (NSArray <NSLayoutConstraint *> *)getConstraintsForRegularStyle {
	NSMutableArray <NSLayoutConstraint *> *constraints = [NSMutableArray new];
	
	[constraints addObject:[NSLayoutConstraint constraintWithItem:self.imageView
														attribute:NSLayoutAttributeWidth
														relatedBy:NSLayoutRelationEqual
														   toItem:nil
														attribute:NSLayoutAttributeNotAnAttribute
													   multiplier:1.0f
														 constant:TETabBarButtonRegularImageSize
							]
	 ];
	[constraints addObject:[NSLayoutConstraint constraintWithItem:self.imageView
														attribute:NSLayoutAttributeHeight
														relatedBy:NSLayoutRelationEqual
														   toItem:nil
														attribute:NSLayoutAttributeNotAnAttribute
													   multiplier:1.0f
														 constant:TETabBarButtonRegularImageSize
							]
	 ];
	
	[constraints addObject:[NSLayoutConstraint constraintWithItem:self.imageView
														attribute:NSLayoutAttributeCenterX
														relatedBy:NSLayoutRelationEqual
														   toItem:self
														attribute:NSLayoutAttributeCenterX
													   multiplier:1.0f
														 constant:0.0f
							]
	 ];
	
	[constraints addObject:[NSLayoutConstraint constraintWithItem:self.titleLabel
														attribute:NSLayoutAttributeCenterX
														relatedBy:NSLayoutRelationEqual
														   toItem:self
														attribute:NSLayoutAttributeCenterX
													   multiplier:1.0f
														 constant:0.0f
							]
	 ];
	
	[constraints addObject:[NSLayoutConstraint constraintWithItem:self.titleLabel
														attribute:NSLayoutAttributeWidth
														relatedBy:NSLayoutRelationLessThanOrEqual
														   toItem:self
														attribute:NSLayoutAttributeWidth
													   multiplier:1.0f
														 constant:0.0f
							]
	 ];
	
	[constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(padding)-[_imageView]-(>=0)-[_titleLabel]-(padding)-|"
																			 options:0
																			 metrics:@{
																					   @"padding": @(TETabBarButtonRegularEdgePadding),
																					   }
																			   views:NSDictionaryOfVariableBindings(_imageView, _titleLabel)
									  ]
	 ];
	
	return constraints;
}

- (NSArray <NSLayoutConstraint *> *)getConstraintsForCompactStyle {
	NSMutableArray <NSLayoutConstraint *> *constraints = [NSMutableArray new];
	
	[constraints addObject:[NSLayoutConstraint constraintWithItem:self.imageView
														attribute:NSLayoutAttributeWidth
														relatedBy:NSLayoutRelationEqual
														   toItem:nil
														attribute:NSLayoutAttributeNotAnAttribute
													   multiplier:1.0f
														 constant:TETabBarButtonCompactImageSize
							]
	 ];
	[constraints addObject:[NSLayoutConstraint constraintWithItem:self.imageView
														attribute:NSLayoutAttributeHeight
														relatedBy:NSLayoutRelationEqual
														   toItem:nil
														attribute:NSLayoutAttributeNotAnAttribute
													   multiplier:1.0f
														 constant:TETabBarButtonCompactImageSize
							]
	 ];
	
	[constraints addObject:[NSLayoutConstraint constraintWithItem:self.imageView
														attribute:NSLayoutAttributeRight
														relatedBy:NSLayoutRelationEqual
														   toItem:self.titleLabel
														attribute:NSLayoutAttributeLeft
													   multiplier:1.0f
														 constant:-TETabBarButtonCompactObjectPadding
							]
	 ];
	
	[constraints addObject:[NSLayoutConstraint constraintWithItem:self.imageView
														attribute:NSLayoutAttributeCenterY
														relatedBy:NSLayoutRelationEqual
														   toItem:self
														attribute:NSLayoutAttributeCenterY
													   multiplier:1.0f
														 constant:0.0f
							]
	 ];
	
	[constraints addObject:[NSLayoutConstraint constraintWithItem:self.titleLabel
														attribute:NSLayoutAttributeCenterX
														relatedBy:NSLayoutRelationEqual
														   toItem:self
														attribute:NSLayoutAttributeCenterX
													   multiplier:1.0f
														 constant:!!self.item.image ? (TETabBarButtonCompactImageSize / 2.0f) : 0.0f
							]
	 ];
	
	[constraints addObject:[NSLayoutConstraint constraintWithItem:self.titleLabel
														attribute:NSLayoutAttributeWidth
														relatedBy:NSLayoutRelationLessThanOrEqual
														   toItem:self
														attribute:NSLayoutAttributeWidth
													   multiplier:0.9f
														 constant:0.0f
							]
	 ];
	
	[constraints addObject:[NSLayoutConstraint constraintWithItem:self.titleLabel
														attribute:NSLayoutAttributeCenterY
														relatedBy:NSLayoutRelationEqual
														   toItem:self
														attribute:NSLayoutAttributeCenterY
													   multiplier:1.0f
														 constant:0.0f
							]
	 ];
	
	return constraints;
}

- (UIFont *)getLabelFontForCurrentStyle {
	switch ([self getItemStyle]) {
		case TETabBarItemStyleRegular:
			return [UIFont systemFontOfSize:TETabBarButtonRegulatFontSize weight:UIFontWeightMedium];
		case TETabBarItemStyleCompact:
			return [UIFont systemFontOfSize:TETabBarButtonCompactFontSize weight:UIFontWeightRegular];
	}
}

- (UIColor *)unselectedColor {
	if (!self.item.isSelectable) {
		return [self changeBrightness:self.tintColor amount:0.7f];
	}
	return [UIColor colorWithWhite:TETabBarButtonUnselectedWhiteAmount alpha:1.0f];
}

- (UIColor *)isPressedColor {
	if (!self.item.isSelectable) {
		return [self changeBrightness:[self unselectedColor] amount:0.8f];
	}
	return [UIColor colorWithWhite:TETabBarButtonIsPressedWhiteAmount alpha:1.0f];
}

- (UIColor *)changeBrightness:(UIColor *)color amount:(CGFloat)amount {
	if (!color) {
		return nil;
	}
	CGFloat hue, saturation, brightness, alpha;
	if ([color getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha]) {
		brightness += (amount-1.0);
		brightness = MAX(MIN(brightness, 1.0), 0.0);
		return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha];
	}
	
	CGFloat white;
	if ([color getWhite:&white alpha:&alpha]) {
		white += (amount-1.0);
		white = MAX(MIN(white, 1.0), 0.0);
		return [UIColor colorWithWhite:white alpha:alpha];
	}
	
	return nil;
}

- (UIColor *)highlightedTintColor {
	if (!_highlightedTintColor) {
		_highlightedTintColor = [self changeBrightness:self.tintColor amount:0.8f];
	}
	return _highlightedTintColor;
}

- (void)tintColorDidChange {
	[super tintColorDidChange];
	self.highlightedTintColor = [self changeBrightness:self.tintColor amount:0.8f];
	if (self.selected) {
		self.imageView.tintColor = self.tintColor;
		self.titleLabel.highlightedTextColor = self.tintColor;
	}
	else if (!self.item.isSelectable) {
		UIColor *unselectedColor = [self unselectedColor];
		self.imageView.tintColor = unselectedColor;
		self.titleLabel.highlightedTextColor = unselectedColor;
	}
}

- (void)setIsPressed:(BOOL)isPressed {
	UIColor *notPressedColor = self.selected ? self.tintColor : [self unselectedColor];
	UIColor *isPressedColor = self.selected ? self.highlightedTintColor : [self isPressedColor];
	self.imageView.tintColor = isPressed ? isPressedColor : notPressedColor;
	self.titleLabel.highlightedTextColor = isPressed ? isPressedColor : self.tintColor;
	self.titleLabel.highlighted = isPressed || self.selected;
}

#pragma mark - Generators

- (UILabel *)generateLabel {
	UILabel *label = [UILabel new];
	label.translatesAutoresizingMaskIntoConstraints = NO;
	label.numberOfLines = 1;
	label.textColor = [UIColor colorWithWhite:TETabBarButtonUnselectedWhiteAmount alpha:1.0f];
	label.textAlignment = NSTextAlignmentCenter;
	label.font = [self getLabelFontForCurrentStyle];
	label.lineBreakMode = NSLineBreakByTruncatingTail;
	label.highlighted = NO;
	return label;
}

- (UIImageView *)generateImageView {
	UIImageView *imageView = [UIImageView new];
	imageView.translatesAutoresizingMaskIntoConstraints = NO;
	imageView.contentMode = UIViewContentModeScaleAspectFit;
	imageView.tintColor = [self unselectedColor];
	return imageView;
}

- (UIImage *)imageForCurrentState {
	if (!self.item) {
		return nil;
	}
	if ((!self.item.image || self.selected) && self.item.selectedImage) {
		return self.item.selectedImage;
	}
	return self.item.image;
}

- (void)setSelected:(BOOL)selected {
	[super setSelected:selected];
	self.imageView.tintColor = selected ? self.tintColor : [self unselectedColor];
	self.titleLabel.highlightedTextColor = selected ? self.tintColor : [self unselectedColor];
	self.titleLabel.highlighted = selected;
	self.imageView.image = [[self imageForCurrentState] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

#pragma mark - UIControl overrides

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
	BOOL shouldContinueTracking = [super beginTrackingWithTouch:touch withEvent:event];
	if (shouldContinueTracking) {
		[self setIsPressed:YES];
	}
	return shouldContinueTracking;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
	BOOL shouldContinueTracking = [super continueTrackingWithTouch:touch withEvent:event];
	if (shouldContinueTracking) {
		[self setIsPressed:self.touchInside];
	}
	return shouldContinueTracking;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
	[self setIsPressed:NO];
	return [super endTrackingWithTouch:touch withEvent:event];
}

- (void)cancelTrackingWithEvent:(UIEvent *)event {
	[self setIsPressed:NO];
	return [super cancelTrackingWithEvent:event];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
	if (context != TETabBarButtonContext) {
		return;
	}
	if ([keyPath isEqualToString:NSStringFromSelector(@selector(title))]) {
		NSString *newTitle = change[NSKeyValueChangeNewKey];
		self.titleLabel.text = newTitle;
	}
	else if ([keyPath isEqualToString:NSStringFromSelector(@selector(image))]) {
		self.imageView.image = [[self imageForCurrentState] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	}
	else if ([keyPath isEqualToString:NSStringFromSelector(@selector(selectedImage))]) {
		UIImage *selectedImage = change[NSKeyValueChangeNewKey];
		if (selectedImage && self.selected) {
			self.imageView.image = [[self imageForCurrentState] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		}
	}

}

@end
