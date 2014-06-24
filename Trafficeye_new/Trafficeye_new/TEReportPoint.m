//
//  TEReportPoint.m
//  Trafficeye_new
//
//  Created by zc on 14-2-13.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import "TEReportPoint.h"

@implementation TEReportPoint
@synthesize data;
@synthesize time;
@synthesize lon;
@synthesize lat;
@synthesize alt;
@synthesize bearing;
@synthesize speed;
@synthesize accuracy;
@synthesize is_start;
@synthesize disFromLastPoint;
- (void)initValue:(NSString*)data1 :(long)time1 :(int)lon1 :(int)lat1 :(int)alt1 :(int)bearing1 :(int)speed1 :(int)accuracy1 :(BOOL)is_start1{
    self.data = data1;
    self.time = time1;
    self.lon = lon1;
    self.lat = lat1;
    self.alt = alt1;
    self.bearing = bearing1;
    self.speed = speed1;
    self.accuracy = accuracy1;
    self.is_start = is_start1;
}
- (NSString*)printMe{
    NSString *des = [NSString stringWithFormat:@"%@,%li,%i,%i,%i,%i,%i,%i,%i,%f",self.data,self.time,self.lon,self.lat,self.alt,self.bearing,self.speed,self.accuracy,self.is_start,self.disFromLastPoint];
    return des;
    
}
@end
