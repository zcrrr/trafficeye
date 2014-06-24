//
//  TEUploadLocation.h
//  Trafficeye_new
//
//  Created by zc on 14-2-12.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface TEUploadLocation : NSObject<CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager* locationManager;
@property (strong, nonatomic) NSMutableArray* recordPointList;
@property (assign, nonatomic) long startTime;
@property (assign, nonatomic) long lastTime;
@property (assign, nonatomic) BOOL xulie_end;//上报点的一个序列，也就是一个s结束了，或者刚开始也为true
@property (strong, nonatomic) CLLocation* lastLocation;
@property (assign, nonatomic) double userLocation_lon;
@property (assign, nonatomic) double userLocation_lat;

- (void)startUploadLocation;

@end
