//
//  MCOnboardViewController.m
//  BMWAppKitDemo
//
//  Created by shiny on 1/5/12.
//  Copyright (c) 2012 BMW Group. All rights reserved.
//

#import <BMWAppKit/BMWAppKit.h>
#import "MCApplicationDataSource.h"
#import "MCOnboardViewController.h"
#import "MCNotifications.h"
#import "MCMainApplicationDelegate.h"


@interface MCOnboardViewController ()

- (void)connectionDidStart:(NSNotification*)notification;
- (void)connectionDidFinish:(NSNotification*)notification;

- (void)subscribeForNotifications;
- (void)unsubscribeFromNotifications;

@end

@implementation MCOnboardViewController

static BOOL didSubscribeToNotifications = NO;

@synthesize statusLabel;
@synthesize logoView;
@synthesize logoView_MINI;
@synthesize activityIndicator;

#pragma mark - Connection management 

- (void)connectionDidStart:(NSNotification*)notification
{
    MCLog(IDLogLevelInfo, @"startAnimating");
    // ignore everything if not logged in
    
    //statusLabel.textColor = [UIColor highlightTextColor];
     statusLabel.text = @"正在连接...";
    [activityIndicator startAnimating];
    
    logoView.hidden = YES;
    logoView_MINI.hidden = YES;
}

- (void)connectionDidFinish:(NSNotification*)notification
{
    MCLog(IDLogLevelInfo, @"stopAnimating");
    // ignore everything if not logged in
    
    statusLabel.text = @"已连接";
    [activityIndicator stopAnimating];
    activityIndicator.hidden = YES;
    
    id<MCApplicationDataSource> applicationDataSource = (id<MCApplicationDataSource>)[TEAppDelegate getApplicationDelegate].appController;
    if (applicationDataSource.connectedVehicleInfo.brand == IDVehicleBrandMINI)
    {
        logoView_MINI.hidden = NO;
    }
    else {
        logoView.hidden = NO;
    }
    NSLog(@"brandis--------%d",applicationDataSource.connectedVehicleInfo.brand);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    statusLabel.text = nil;


    [self subscribeForNotifications];
}

- (void)viewDidAppear:(BOOL)animated
{
    [activityIndicator startAnimating];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [self unsubscribeFromNotifications];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Notification handling

- (void)subscribeForNotifications
{
    if (!didSubscribeToNotifications) {
        didSubscribeToNotifications = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionDidStart:) name:MCConnectionDidStartNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionDidFinish:) name:MCConnectionDidFinishNotification object:nil];
    }
}

- (void)unsubscribeFromNotifications
{
    if (didSubscribeToNotifications) {
        didSubscribeToNotifications = NO;
        [[NSNotificationCenter defaultCenter] removeObserver:self name:MCConnectionDidStartNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:MCConnectionDidFinishNotification object:nil];
    }
}


@end
