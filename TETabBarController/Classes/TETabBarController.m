//
//  TETabBarController.m
//  CustomTabBar
//
//  Created by Timothy Ellis on 29/5/18.
//  Copyright © 2018 Timothy Ellis. All rights reserved.
//

#import "TETabBarController.h"
#import "TETabBarButton.h"

@interface TETabBar (Private)
@property (nonatomic, nonnull) NSArray <TETabBarButton *> *buttons;
- (void)selectButtonAtIndex:(NSInteger)index;
@end

@interface TETabBarController ()

@property (nonatomic, nonnull, readwrite) TETabBar *tabBar;

@end

@implementation TETabBarController

@synthesize tabBar = _tabBar;

#pragma mark - Getters/Setters

- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers {
	_viewControllers = [viewControllers copy];
	[self updateTabBarButtons];
	[self setSelectedIndex:0];
}

- (void)setSelectedViewController:(__kindof UIViewController *)selectedViewController {
	NSUInteger index = [self.viewControllers indexOfObject:selectedViewController];
	if (index == NSNotFound) {
		return;
	}
	[self setSelectedIndex:index];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
	if (selectedIndex >= self.viewControllers.count) {
		return;
	}
	_selectedIndex = selectedIndex;
	[self.tabBar selectButtonAtIndex:_selectedIndex];
	if (_selectedViewController) {
		[_selectedViewController.view removeFromSuperview];
		[_selectedViewController removeFromParentViewController];
	}
	
	_selectedViewController = self.viewControllers[_selectedIndex];
	[self addChildViewController:(__kindof UIViewController *)_selectedViewController];
	[self setupConstraintsForSelectedViewController:_selectedViewController];
}

- (void)setTabBar:(TETabBar * _Nonnull)tabBar {
	@throw [NSException exceptionWithName:NSInternalInconsistencyException
								   reason:@"You should not be trying to change the value of the tabBar."
								 userInfo:nil
			];
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	[self initObjects];
	[self setupConstraints];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addChildViewController:(UIViewController *)childController {
	[super addChildViewController:childController];
	if (childController.view) {
		childController.view.translatesAutoresizingMaskIntoConstraints = NO;
		[self.view insertSubview:(UIView *)childController.view belowSubview:self.tabBar];
	}
	[childController didMoveToParentViewController:self];
}

#pragma mark - Custom Loading

- (TETabBar *)tabBar {
	if (!_tabBar) {
		_tabBar = [self generateTabBar];
	}
	return _tabBar;
}

- (void)initObjects {
	if (![self.view.subviews containsObject:self.tabBar]) {
		[self.view addSubview:self.tabBar];
	}
}

- (void)setupConstraints {
	[self.tabBar setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
	[self.tabBar setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
	
	[NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tabBar]|"
																					options:0
																					metrics:nil
																					  views:NSDictionaryOfVariableBindings(_tabBar)
											 ]
	 ];
	[NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_tabBar]|"
																					options:0
																					metrics:nil
																					  views:NSDictionaryOfVariableBindings(_tabBar)
											 ]
	 ];
}

- (void)setupConstraintsForSelectedViewController:(__kindof UIViewController *)viewController {
	UIView *childView = viewController.view;
	if (!childView) {
		return;
	}
	[NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[childView]|"
																					options:0
																					metrics:nil
																					  views:NSDictionaryOfVariableBindings(childView)
											 ]
	 ];
	[NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[childView][_tabBar]"
																					options:0
																					metrics:nil
																					  views:NSDictionaryOfVariableBindings(childView, _tabBar)
											 ]
	 ];
}

- (void)viewSafeAreaInsetsDidChange API_AVAILABLE(ios(11.0)) {
	[super viewSafeAreaInsetsDidChange];
	if (@available(iOS 11, *)) {
		self.tabBar.bottomInset = self.view.safeAreaInsets.bottom;
	}
}

- (void)updateTabBarButtons {
	if (self.viewControllers.count == 0) {
		self.tabBar.items = nil;
		return;
	}
	NSMutableArray <TETabBarItem *> *items = [NSMutableArray new];
	for (UIViewController *viewController in self.viewControllers) {
		[items addObject:viewController.teTabBarItem];
	}
	self.tabBar.items = items;
}

#pragma mark - Generators

- (TETabBar *)generateTabBar {
	TETabBar *tabBar = [TETabBar new];
	tabBar.translatesAutoresizingMaskIntoConstraints = NO;
	tabBar.delegate = self;
	return tabBar;
}

#pragma mark - TETabBarDelegate Methods

- (void)tabBar:(TETabBar *)tabBar didSelectItem:(TETabBarItem *)item {
	NSUInteger index = (NSUInteger)item.index;
	if (index >= self.viewControllers.count || !item.isSelectable) {
		return;
	}
	self.selectedViewController = self.viewControllers[index];
}

- (void)tabBar:(TETabBar *)tabBar didSelectSameItem:(TETabBarItem *)item {
	// Tapping the same one twice will pop to the root view (if it is a navigation controller)
	if (self.selectedViewController && [self.selectedViewController isKindOfClass:UINavigationController.class]) {
		[((UINavigationController *)self.selectedViewController) popToRootViewControllerAnimated:YES];
	}
}

#pragma mark - Public Methods

- (void)addLongPressTarget:(id)target action:(SEL)action toViewControllerTab:(UIViewController *)viewController {
	if (!self.viewControllers || self.viewControllers.count == 0) {
		return;
	}
	NSUInteger idx = [self.viewControllers indexOfObject:viewController];
	if (idx == NSNotFound || idx >= self.tabBar.buttons.count) {
		return;
	}
	TETabBarButton *button = self.tabBar.buttons[idx];
	[button addLongPressTarget:target action:action];
}

@end
