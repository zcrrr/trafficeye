//
//  TEReportPoint.h
//  Trafficeye_new
//
//  Created by zc on 14-2-13.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TEReportPoint : NSObject
@property (strong, nonatomic) NSString* data;
@property (assign, nonatomic) long time;//系统时间
@property (assign, nonatomic) int lon;
@property (assign, nonatomic) int lat;
@property (assign, nonatomic) int alt;//高程
@property (assign, nonatomic) int bearing;//角度
@property (assign, nonatomic) int speed;//速度
@property (assign, nonatomic) int accuracy;//精确度
@property (assign, nonatomic) BOOL is_start;//是否是一个记录点序列的开始
@property (assign, nonatomic) double disFromLastPoint;//与上一个点的距离
- (void)initValue:(NSString*)data1 :(long)time1 :(int)lon1 :(int)lat1 :(int)alt1 :(int)bearing1 :(int)speed1 :(int)accuracy1 :(BOOL)is_start1;
- (NSString*)printMe;
@end
