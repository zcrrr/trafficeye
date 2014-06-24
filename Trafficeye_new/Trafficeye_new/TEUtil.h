//
//  TEUtil.h
//  Trafficeye_new
//
//  Created by zc on 13-10-18.
//  Copyright (c) 2013年 张 驰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TEUtil : NSObject

+ (BOOL)isStringNULL:(NSString*)str;
+ (NSString*)getTimeFromTimestamp:(NSString*)timestamp;
+ (NSString*)getCityName:(NSString*)cityCode;
+ (NSString *)URLDecode:(NSString*)content;
+ (long)getNowTime;
+ (void)appendStringToPlist:(NSString *)str;
+ (double)getUserLocationLon;
+ (double)getUserLocationLat;
+ (NSString*)cityNameByLocation:(double)lon :(double)lat;
@end
