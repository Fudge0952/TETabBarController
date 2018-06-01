//
//  TETabBarControllerTests.m
//  TETabBarControllerTests
//
//  Created by Timothy Ellis on 05/31/2018.
//  Copyright (c) 2018 Timothy Ellis. All rights reserved.
//

@import XCTest;
@import TETabBarController;

@interface Tests : XCTestCase

@end

@implementation Tests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (TETabBarController *)generateTabBarControllerWithItems {
	TETabBarController *controller = [TETabBarController new];
	
	// Add the controllers
	NSMutableArray *viewControllers = [NSMutableArray new];
	for (NSUInteger i = 0; i < 5; i++) {
		UIViewController *vc = [UIViewController new];
		vc.title = [NSString stringWithFormat:@"Tab %lu", (long unsigned)i];
		[viewControllers addObject:vc];
	}
	controller.viewControllers = viewControllers;
	return controller;
}

#pragma mark - Tests

/// Make sure that a tab bar exists, even when just created.
- (void)testTabBarControllerTabBar {
	TETabBarController *controller = [TETabBarController new];
	XCTAssertNotNil(controller.tabBar);
}

- (void)testTabsEqualsViewControllers {
	TETabBarController *controller = [self generateTabBarControllerWithItems];
	XCTAssertEqual(controller.viewControllers.count, controller.tabBar.items.count);
}

- (void)testTabTitlesMatchViewControllerTitles {
	TETabBarController *controller = [self generateTabBarControllerWithItems];
	for (UIViewController *vc in controller.viewControllers) {
		XCTAssertEqualObjects(vc.tabBarItem.title, vc.title);
	}
}

/// Make sure that if we change the title, then the tab bar keeps up to date
- (void)testChangingTabTitlesMatchViewControllerTitles {
	TETabBarController *controller = [self generateTabBarControllerWithItems];
	NSUInteger idx = controller.viewControllers.count;
	
	// Change all the titles
	for (UIViewController *vc in controller.viewControllers) {
		vc.title = [NSString stringWithFormat:@"Changed %lu", (long unsigned)idx--];
	}
	
	// verify they match
	for (UIViewController *vc in controller.viewControllers) {
		XCTAssertEqualObjects(vc.tabBarItem.title, vc.title);
	}
}

/// Make sure that when we change the selected view controller or the selected index that the repsective object is updated
- (void)testSelectedViewController {
	TETabBarController *controller = [self generateTabBarControllerWithItems];
	
	for (UIViewController *vc in controller.viewControllers) {
		controller.selectedViewController = vc;
		// Changing the selected view controller should change the selected index
		XCTAssertNotNil(controller.selectedViewController);
		XCTAssertEqualObjects(controller.selectedViewController, controller.viewControllers[controller.selectedIndex]);
	}
	
	for (NSUInteger idx = 0; idx < controller.viewControllers.count; idx++) {
		controller.selectedIndex = idx;
		// Changing the selected index should change the selected view controller
		XCTAssertNotNil(controller.selectedViewController);
		XCTAssertEqualObjects(controller.selectedViewController, controller.viewControllers[controller.selectedIndex]);
	}
}

@end

