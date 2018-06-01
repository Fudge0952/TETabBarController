//
//  TEViewController.m
//  TETabBarController
//
//  Created by Timothy Ellis on 05/31/2018.
//  Copyright (c) 2018 Timothy Ellis. All rights reserved.
//

#import "TEViewController.h"
#import "TestViewController.h"

@interface TEViewController ()

@end

@implementation TEViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	[self addTestViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addTestViews {
	NSMutableArray *array = [NSMutableArray new];
	
	NSArray *objs = @[
					  @[
						  @"First",
						  [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemBookmarks tag:0].selectedImage
						  ],
					  @[
						  @"Second",
						  [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemSearch tag:0].selectedImage,
						  ],
					  @[
						  @"",
						  [UIImage imageNamed:@"add"],
						  @NO,
						  ],
					  @[
						  @"Fourth",
						  [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:0].selectedImage,
						  ],
					  @[
						  @"Fifth",
						  [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMostViewed tag:0].selectedImage
						  ],
					  ];
	
	for (NSArray *obj in objs) {
		BOOL isSelectable = YES;
		if (obj.count > 2) {
			isSelectable = [obj[2] boolValue];
		}
		TestViewController *vc = [TestViewController new];
		vc.title = obj[0];
		if (obj.count > 1) {
			vc.teTabBarItem.image = obj[1];
		}
		vc.teTabBarItem.isSelectable = isSelectable;
		[array addObject:vc];
	}
	
	UIViewController *lastVC = array.lastObject;
	[array removeLastObject];
	UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:lastVC];
	[array addObject:navC];
	
	self.viewControllers = array;
	
	[self addLongPressTarget:self action:@selector(didLongPress:) toViewControllerTab:array[0]];
	[self addLongPressTarget:self action:@selector(didLongPress:) toViewControllerTab:array[1]];
	[self addLongPressTarget:self action:@selector(didLongPress:) toViewControllerTab:array[3]];
}

- (void)didLongPress:(id)sender {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Long Press aciton"
													message:[sender debugDescription]
												   delegate:nil
										  cancelButtonTitle:@"Ok"
										  otherButtonTitles: nil];
	[alert show];
}

- (void)tabBar:(TETabBar *)tabBar didSelectItem:(TETabBarItem *)item {
	[super tabBar:tabBar didSelectItem:item];
	if (item.index == 2) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Did press on add"
														message:[item debugDescription]
													   delegate:nil
											  cancelButtonTitle:@"Ok"
											  otherButtonTitles: nil];
		[alert show];
	}
}


@end
