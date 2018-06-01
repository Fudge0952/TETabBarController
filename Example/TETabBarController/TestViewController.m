//
//  TestViewController.m
//  CustomTabBar
//
//  Created by Timothy Ellis on 31/5/18.
//  Copyright © 2018 Timothy Ellis. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)setNavTitle:(NSString *)title {
	self.label.text = title;
	self.title = title;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	CGRect labelFrame = self.view.bounds;
	labelFrame.origin.y = 80;
	labelFrame.size.height = 80;
	self.label = [[UILabel alloc] initWithFrame:labelFrame];
	self.label.translatesAutoresizingMaskIntoConstraints = YES;
	self.label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	self.label.textAlignment = NSTextAlignmentCenter;
	self.label.text = self.title;
	[self.view addSubview:self.label];
	
	UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
	button.translatesAutoresizingMaskIntoConstraints = YES;
	button.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[button setTitle:@"Test Push" forState:UIControlStateNormal];
	[button setFrame:CGRectMake(0, labelFrame.origin.y + labelFrame.size.height + 16, self.view.bounds.size.width, 50)];
	[button addTarget:self action:@selector(buttonTapped) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:button];
}

- (void)buttonTapped {
	if (self.navigationController) {
		TestViewController *vc = [TestViewController new];
		vc.view.backgroundColor = [UIColor whiteColor];
		vc.title = @"Pushed view";
		[self.navigationController pushViewController:vc animated:YES];
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
