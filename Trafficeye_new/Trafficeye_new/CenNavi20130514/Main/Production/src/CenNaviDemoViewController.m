//
//  CenNaviDemoViewController.m
//
//  Created by Don Hao on 1/31/12.
//  Copyright (c) 2012 BMW Group. All rights reserved.
//

#import "CenNaviDemoViewController.h"
#import "MCMainApplicationDelegate.h"

@implementation CenNaviDemoViewController
@synthesize appController = _appController;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    _appController = [[MCMainApplicationDelegate alloc] init];
    [_appController startup];
    
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIDeviceOrientationPortrait);
}

@end
