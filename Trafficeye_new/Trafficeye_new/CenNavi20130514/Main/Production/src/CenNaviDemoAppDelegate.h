//
//  CenNaviDemoAppDelegate.h
//
//  Created by Don Hao on 1/31/12.
//  Copyright (c) 2012 BMW Group. All rights reserved.
//
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#import <UIKit/UIKit.h>

@class CenNaviDemoViewController;

@interface CenNaviDemoAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CenNaviDemoViewController *viewController;

+(CenNaviDemoAppDelegate*)sharedInstance; 

@end
