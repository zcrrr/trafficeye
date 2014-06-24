//
//  TEOrderCarViewController.h
//  Trafficeye_new
//
//  Created by zc on 14-5-7.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TEFisrtLevelViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface TEOrderCarViewController : TEFisrtLevelViewController<UIWebViewDelegate,CLLocationManagerDelegate,OrdercarDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webview;
@property (strong, nonatomic) NSString* carID;

@property (strong, nonatomic) CLLocationManager* locationManager;
@property (strong, nonatomic) NSMutableArray* recordPointList;
@property (assign, nonatomic) long startTime;
@property (assign, nonatomic) long lastTime;
@property (assign, nonatomic) BOOL xulie_end;//上报点的一个序列，也就是一个s结束了，或者刚开始也为true
@property (strong, nonatomic) CLLocation* lastLocation;

@end
