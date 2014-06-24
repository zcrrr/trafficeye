//
//  Connected
//
//  Created by Wolfram Manthey on 02.02.10.
//  Copyright 2010 BMW Group. All rights reserved.
//

#import <ExternalAccessory/ExternalAccessory.h>
#import <BMWAppKit/IDAccessoryMonitor.h>
#import "MCMainApplicationDelegate.h"
#import "CenNaviDemoAppDelegate.h"
#import "CenNaviDemoViewController.h"
#import "MCFeatureManager.h"
#import "MCNotifications.h"
#import "MCAudioManager.h"
#import "BMWAppKit/IDVersion.h"


@interface MCMainApplicationDelegate ()

@property (assign, readwrite) BOOL carConnected;
@property (readonly) MCOnboardViewController*     onboardViewController;

@property (retain) IDAccessoryMonitor *accessoryMonitor;
@property (readwrite, atomic, copy) NSDictionary* connectedVehicleState;

//used to retrieve vehicle info; the connection is being kept until hmi disconnect to work around an issue with appkit
@property (readwrite, retain) IDVehicleInfo *connectedVehicleInfo;


- (void)updateViews;
- (void)carDidConnect:(NSNotification*)notification;
- (void)listenForA4AAccessories;
- (void)ignoreProxyNotifications;

@end




@implementation MCMainApplicationDelegate

@synthesize onboardViewController;
@synthesize carConnected = _carConnected;
@synthesize accessoryMonitor = _accessoryMonitor;
@synthesize connectedVehicleState = _connectedVehicleState;
@synthesize connectedVehicleInfo = _connectedVehicleInfo;

-(id)init
{
    if ((self = [super init]))
    {
        [[EAAccessoryManager sharedAccessoryManager] registerForLocalNotifications];
        
        //name the main thread so it shows up properly on the logs
        [[NSThread currentThread] setName:@"MainThread"];
        
        // set global log level
        [[IDLogger defaultLogger] setMaximumLogLevel:IDLogLevelDebug];
        
        // initialize console log appender
        [[IDLogger defaultLogger] addAppender:[[[IDConsoleLogAppender alloc] init] autorelease]];
        
        [_connectedVehicleState release];
        _connectedVehicleState = [[NSDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] valueForKey:@"vehicleInfo"]];
        
        _accessoryMonitor = [IDAccessoryMonitor new];
        [self.accessoryMonitor startMonitoring];    // needs to monitor permanently for self-diagnosis to work

    }
    
    return self;
}


- (void)dealloc
{
    [onboardViewController release];

    [_accessoryMonitor stopMonitoring];
    [_accessoryMonitor release];
    
    [_connectedVehicleState release];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}


#pragma mark - startup
- (void)startup
{
    
    [self listenForA4AAccessories];
    
    [MCFeatureManager sharedManager];
    [self updateViews];
}

#pragma mark -
#pragma mark UIApplicationDelegate implementation
- (BOOL)mcMainHandleOpenURL:(NSURL*)url
{
    MCLog(IDLogLevelInfo, @"%s: URL: %@", __FUNCTION__, url.scheme);

    NSURL *calledAppSwitcherURL = nil;
    
    /* BEGIN: App Switcher */
    // check if the called URL is a valid AppSwitcher URL
    if ([url.host isEqualToString:@"com.bmw.a4a"]) {
        NSArray* CFBundleURLTypes = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleURLTypes"];
        for (NSDictionary* urlType in CFBundleURLTypes) {
            //NSString* val = [urlType objectForKey:@"CFBundleURLName"];
            //if ([val isEqualToString:@"main"]) {
                NSArray* CFBundleURLSchemes = [urlType objectForKey:@"CFBundleURLSchemes"];
                if([CFBundleURLSchemes containsObject:url.scheme]) {
                    calledAppSwitcherURL = url;
                }
            //}
        }
    }
    /* END: App Switcher */
    
    /* BEGIN: Feature Switcher */
    if (calledAppSwitcherURL) {
        NSString *featureName = @"CenNavi";   //!!!
        MCFeatureIdentifier *desiredFeature = [MCFeatureIdentifier featureIdentifierForFeatureIdentifierName:featureName];
        //first, check if features are already connected
        //if yes -> this was not an App Switch, just a Feature Switch, inform the FeatureController
        //if no -> do nothing here, handle feature switch in feature controller
        //if (![[MCFeatureManager sharedManager] areFeaturesConnected]) {
            [MCFeatureManager sharedManager].calledAppSwitcherFeature = desiredFeature;
        //}
        return YES;
    }
    /* END: Feature Switcher */
    
    return YES;
}

#pragma mark - Connection
- (void)listenForA4AAccessories
{
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(carDidConnect:) name:IDAccessoryDidConnectNotification object:nil];
    [nc addObserver:self selector:@selector(carDidDisconnect:) name:IDAccessoryDidDisconnectNotification object:nil];
}

- (void)ignoreProxyNotifications
{
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self name:IDAccessoryDidConnectNotification object:nil];
    [nc removeObserver:self name:IDAccessoryDidDisconnectNotification object:nil];
}

//callback for IDAccessoryDidConnectNotification
- (void)carDidConnect:(NSNotification*)notification
{
    MCLog(IDLogLevelInfo, @"-- car did connect --");
    
    //this callback is only called when vehicle information is available in vehicle monitor.
    
    self.connectedVehicleInfo = self.accessoryMonitor.vehicleInfo;

    
    self.carConnected = YES;
    
    //A4A-3677 The feature manager is needs to instantiated the first time on the main thread
    //because the delegate call back queue of IDApplication is set implicitly based upon the context
    
    //in which it is called using [NSOperationQueue currentQueue]
    //
    //I know this bad practice to handle such constraints not at their root (technically MCFeatureManager
    //should ensure this constraint is satisfied), but the current implementation is so messy
    //that this is more or the less impossible
    //
    //Remove this if the hard contraint that IDApplication instances have to be created from the context of a NSOperationQueue is no longer true
    [MCFeatureManager sharedManager];   //Brian Jensen: This is really ugly code, but unfortunately we need to make sure that the manager is instantiated
    //before performing further work from a background thread
    
    [self updateViews];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MCConnectionDidStartNotification object:nil];
    
    [self performSelectorInBackground:@selector(connectToHmi) withObject:nil];
    NSString *brand = [NSString stringWithFormat:@"%u", self.connectedVehicleInfo.brand];
    NSString *hmiType = [NSString stringWithFormat:@"%u", self.connectedVehicleInfo.hmiType];
    NSLog(@"brand is %@,and hmiType is %@",brand,hmiType);
    if(self.connectedVehicleInfo.brand == IDVehicleBrandBMW){
        if(self.connectedVehicleInfo.hmiType == IDVehicleHmiTypeID4){
//            [self showOnboardView];
//        }else{
//            [self carDidDisconnect:nil];
        }
    }else{
        [self carDidDisconnect:nil];
    }
    
}

- (void)carDidDisconnect:(NSNotification*)notification
{
    MCLog(IDLogLevelInfo, @"-- car did disconnect --");
    
    if (!self.carConnected)
    {
        MCLog(IDLogLevelWarn, @"%s called although not connected, doing nothing", __PRETTY_FUNCTION__);
        return;
    }
    
    self.carConnected = NO;
    [_connectedVehicleInfo release];
    _connectedVehicleInfo = nil;
    
    [self performSelectorOnMainThread:@selector(updateViews) withObject:nil waitUntilDone:YES];
    
    [self performSelectorInBackground:@selector(disconnectFromHmi) withObject:nil];
}

- (void)connectToHmi {
    @autoreleasepool {
        [[MCFeatureManager sharedManager] connectToHMIType:self.connectedVehicleInfo.hmiType];
        id<MCApplicationDataSource> applicationDataSource = (id<MCApplicationDataSource>)[TEAppDelegate getApplicationDelegate].appController;
        if(applicationDataSource.connectedVehicleInfo.brand == IDVehicleBrandBMW){
            if(applicationDataSource.connectedVehicleInfo.hmiType == IDVehicleHmiTypeID4){
                [self showOnboardView];
            }else{
//                [self carDidDisconnect:nil];
            }
        }else{
//            [self carDidDisconnect:nil];
        }
        // Connection seemes to be successful
        NSNotification* note = [NSNotification notificationWithName:MCConnectionDidFinishNotification object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:note waitUntilDone:YES];
    }
}

- (void)disconnectFromHmi
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    [[MCFeatureManager sharedManager] disconnect];
    
    [pool release];
}


#pragma mark - View Management
- (void)updateViews
{
    MCLog(IDLogLevelDebug, @"%s  has been called", __PRETTY_FUNCTION__);
    
    
    if (self.carConnected)
    {
        NSLog(@"car connected");
        MCLog(IDLogLevelInfo, @"Car is connected, bringing up startup iPhone UI");
        
//        [self showOnboardView];
        
        // Enable Proximity Monitoring while the phone is connected to the car.
        // We are not interested in the proximityState, but this also switches the display off while in a closed middle armrest (tested with iOS4.3.4 and iOS5.0beta4),
        // so that the device heats up less.
        [UIDevice currentDevice].proximityMonitoringEnabled = YES;
        
        // disable automatic screen lock while connected -
        // this is important because starting with iOS5 a locked screen would send the app into the background
        [UIApplication sharedApplication].idleTimerDisabled = YES;
        
        return;
    }
    
    if (!self.carConnected)
    {
        NSLog(@"!car connected");
        MCLog(IDLogLevelInfo, @"Car is not connected, bringing up status iPhone UI");
        
        // Disable Proximity Monitoring.
        [UIDevice currentDevice].proximityMonitoringEnabled = NO;
        
        // enable potential automatic screen lock again when disconnected
        [UIApplication sharedApplication].idleTimerDisabled = NO;
        
        [self showOffboardView];
        return;
    }
    
    //should not happen very often
    MCLog(IDLogLevelInfo, @"%s:%d not performing any iPhone UI transition", __FUNCTION__, __LINE__);
}


- (MCOnboardViewController *) onboardViewController {
    if (!onboardViewController) {
        MCLog(IDLogLevelDebug, @"instantiating new onboardViewController");
        onboardViewController = [[[MCOnboardViewController alloc] initWithNibName:@"MCOnboardViewController" bundle:[NSBundle mainBundle]] retain];
        if(iPhone5){
            onboardViewController.view.frame = CGRectMake(0, 0, 320, 600);
        }else{
            onboardViewController.view.frame = CGRectMake(0, 0, 320, 480);
        }
    }
    
    return onboardViewController;
}


- (void) showOnboardView
{
    if ([[[CenNaviDemoAppDelegate sharedInstance] window].subviews lastObject] != self.onboardViewController.view)
    {
        NSLog(@"showOnboardView");
        [UIView transitionWithView:[[CenNaviDemoAppDelegate sharedInstance] window]
                          duration:0.7
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        animations:^{ 
                            [[[[CenNaviDemoAppDelegate sharedInstance] window].subviews lastObject] removeFromSuperview];
                            [[[CenNaviDemoAppDelegate sharedInstance] window] addSubview:self.onboardViewController.view];
                            
                        }
                        completion:NULL];
        NSLog(@"showOnboardView2");
    }
}

- (void) showOffboardView
{
    if ([[[CenNaviDemoAppDelegate sharedInstance] window].subviews lastObject] != [TEAppDelegate getApplicationDelegate].menuController.view)
    {
        [UIView transitionWithView:[[CenNaviDemoAppDelegate sharedInstance] window]
                          duration:0.7
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^{ 
                            [[[[CenNaviDemoAppDelegate sharedInstance] window].subviews lastObject] removeFromSuperview];
                            [[[CenNaviDemoAppDelegate sharedInstance] window] addSubview:[TEAppDelegate getApplicationDelegate].menuController.view];
//                            [[(AppDelegate*)[[UIApplication sharedApplication] delegate] tabBarViewController] setSelectedIndex:0];
                        }
                        completion:NULL];
    }
}

@end
