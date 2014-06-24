//
//  CenNaviDemoViewController.h
//
//  Created by Don Hao on 1/31/12.
//  Copyright (c) 2012 BMW Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MCMainApplicationDelegate;

@interface CenNaviDemoViewController : UIViewController
{
    MCMainApplicationDelegate *_appController;
}

@property (strong, nonatomic) MCMainApplicationDelegate *appController;

@end
