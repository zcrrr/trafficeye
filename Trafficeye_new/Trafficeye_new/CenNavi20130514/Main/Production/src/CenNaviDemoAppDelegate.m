//
//  CenNaviDemoAppDelegate.m
//
//  Created by Don Hao on 1/31/12.
//  Copyright (c) 2012 BMW Group. All rights reserved.
//

#import "CenNaviDemoAppDelegate.h"

#import "CenNaviDemoViewController.h"
#import <BMWAppKit/BMWAppKit.h>
#import "MCFeatureManager.h"
#import "MCMainApplicationDelegate.h"

CenNaviDemoAppDelegate* g_sharedInstanceAppController;

@implementation CenNaviDemoAppDelegate


@synthesize window = _window;
@synthesize viewController = _viewController;

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

+(TEAppDelegate*)sharedInstance
{
    return [TEAppDelegate getApplicationDelegate];
}  

- (void)redirectNSLogToDocumentFolder{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName =[NSString stringWithFormat:@"ting_test.log"];
    NSString *logFilePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    NSError *attributesError = nil;
    NSDictionary * fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:logFilePath error:&attributesError];
    if (fileAttributes != nil)
    {
        NSNumber *fileSizeNumber = [fileAttributes objectForKey:NSFileSize];
        long long fileSize = [fileSizeNumber longLongValue];
        if (fileSize > 10 * 1024 * 1024) // 10MB
        {
            NSError * removeFileError = nil;
            [[NSFileManager defaultManager] removeItemAtPath:logFilePath error:&removeFileError];
        }
    }
    
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding],"a+",stderr);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    g_sharedInstanceAppController = self;
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        self.viewController = [[[CenNaviDemoViewController alloc] initWithNibName:@"CenNaviDemoViewController_iPhone" bundle:nil] autorelease];
        if(iPhone5){
            self.viewController.view.frame = CGRectMake(0, 0, 320, 600);
        }else{
            self.viewController.view.frame = CGRectMake(0, 0, 320, 480);
        }
    } else 
    {
        self.viewController = [[[CenNaviDemoViewController alloc] initWithNibName:@"CenNaviDemoViewController_iPad" bundle:nil] autorelease];
    }
    //self.window.rootViewController = self.viewController;
    [self.window addSubview:self.viewController.view];
    
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    MCLog(IDLogLevelInfo, @"%s", __FUNCTION__);
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    MCLog(IDLogLevelInfo, @"%s", __FUNCTION__);

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
    MCLog(IDLogLevelInfo, @"%s", __FUNCTION__);
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    MCLog(IDLogLevelInfo, @"%s", __FUNCTION__);
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    MCLog(IDLogLevelInfo, @"%s", __FUNCTION__);
    
    //cleanup
    self.viewController = nil;
    self.window = nil;
}

- (BOOL)application:(UIApplication*)application handleOpenURL:(NSURL*)url
{
    MCLog(IDLogLevelInfo, @"%s", __FUNCTION__);
    
    [[self.viewController appController] mcMainHandleOpenURL:url];
    
    return YES;
}

@end