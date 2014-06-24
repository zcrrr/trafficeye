//
//  TEUtil.m
//  Trafficeye_new
//
//  Created by zc on 13-10-18.
//  Copyright (c) 2013年 张 驰. All rights reserved.
//

#import "TEPersistenceHandler.h"

@implementation TEUtil

+ (BOOL)isStringNULL:(NSString*)str{
    if ((NSNull *)str == [NSNull null]){
        return YES;
    }else{
        return NO;
    }
}

+ (NSString*)getTimeFromTimestamp:(NSString*)timestamp{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyyMMddHHMMss"];
    NSDate *date = [formatter dateFromString:timestamp];
    NSString *destDateString = [formatter stringFromDate:date];
    return destDateString;
}
+ (NSString*)getCityName:(NSString*)cityCode{
    if([cityCode isEqualToString:@"101010100"])return @"北京";
    if([cityCode isEqualToString:@"101020100"])return @"上海";
    if([cityCode isEqualToString:@"101280101"])return @"广州";
    if([cityCode isEqualToString:@"101280601"])return @"深圳";
    if([cityCode isEqualToString:@"101210101"])return @"杭州";
    if([cityCode isEqualToString:@"101230101"])return @"福州";
    if([cityCode isEqualToString:@"101200101"])return @"武汉";
    if([cityCode isEqualToString:@"101270101"])return @"成都";
    if([cityCode isEqualToString:@"101040100"])return @"重庆";
    if([cityCode isEqualToString:@"101120201"])return @"青岛";
    if([cityCode isEqualToString:@"101070101"])return @"沈阳";
    if([cityCode isEqualToString:@"101190101"])return @"南京";
    if([cityCode isEqualToString:@"101210401"])return @"宁波";
    if([cityCode isEqualToString:@"101060101"])return @"长春";
    if([cityCode isEqualToString:@"101281701"])return @"中山";
    if([cityCode isEqualToString:@"101090101"])return @"石家庄";
    if([cityCode isEqualToString:@"101250101"])return @"长沙";
    if([cityCode isEqualToString:@"101281601"])return @"东莞";
    if([cityCode isEqualToString:@"101280701"])return @"珠海";
    if([cityCode isEqualToString:@"101280800"])return @"佛山";
    if([cityCode isEqualToString:@"101190201"])return @"无锡";
    if([cityCode isEqualToString:@"101030100"])return @"天津";
    if([cityCode isEqualToString:@"101230201"])return @"厦门";
    if([cityCode isEqualToString:@"101190401"])return @"苏州";
    if([cityCode isEqualToString:@"101210901"])return @"金华";
    if([cityCode isEqualToString:@"101210701"])return @"温州";
    if([cityCode isEqualToString:@"000000000"])return @"城际高速";
    return @"北京";
}
+ (NSString *)URLDecode:(NSString*)content
{
    NSString *result = [content stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return result;
}
+ (long)getNowTime{
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    //    NSLog(@"%@",datenow);
    NSTimeInterval timeinterval = [datenow timeIntervalSince1970];
    return timeinterval;
}
+ (void)appendStringToPlist:(NSString *)str{
    NSString *stringToWrite;
    NSString* filePath = [TEPersistenceHandler getDocument:@"uerLog.plist"];
    NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    stringToWrite = [dic valueForKey:@"userLog"];
    if(!stringToWrite){
        stringToWrite = @"";
    }
    stringToWrite = [NSString stringWithFormat:@"%@%@",stringToWrite,str];
    NSLog(@"stringtowrite is %@",stringToWrite);
    NSMutableDictionary* dic2 = [[NSMutableDictionary alloc ]init];
    [dic2 setValue:stringToWrite forKey:@"userLog"];
    [dic2 writeToFile:filePath atomically:YES];
}
+ (double)getUserLocationLon{
    return [TEAppDelegate getApplicationDelegate].uploadLocation.userLocation_lon;
}
+ (double)getUserLocationLat{
    return [TEAppDelegate getApplicationDelegate].uploadLocation.userLocation_lat;
}
+ (NSString*)cityNameByLocation:(double)lon :(double)lat{
    NSString* cityname = @"beijing";
    if(lat > 39.43 && lat < 41.00 && lon > 115.42 && lon < 117.40){
        cityname = @"beijing";
    }else if(lat > 30.70 && lat < 31.83 && lon > 120.90 && lon < 121.96){
        cityname =  @"shanghai";
    }else if(lat > 22.83 && lat < 23.42 && lon > 112.88 && lon < 113.63){
        cityname =  @"guangzhou";
    }else if(lat > 22.45 && lat < 22.75 && lon > 113.80 && lon < 114.38){
        cityname =  @"guangzhou";
    }
    return cityname;
}
@end
