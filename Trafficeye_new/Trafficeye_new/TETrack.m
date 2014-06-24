//
//  TETrack.m
//  Trafficeye_new
//
//  Created by zc on 13-9-22.
//  Copyright (c) 2013年 张 驰. All rights reserved.
//

#import "TETrack.h"
#import "TEGeoPoint.h"

@implementation TETrack
@synthesize index;
@synthesize trackid;
@synthesize userID;
@synthesize username;
@synthesize avatar;
@synthesize speed;
@synthesize minute;
@synthesize pointsList;

- (void)initPointsList:(NSString *)pointsStr{
    self.pointsList = [[NSMutableArray alloc]init];
    NSArray* arr_pair = [pointsStr componentsSeparatedByString:@","];
    NSString* pair_first = [arr_pair objectAtIndex:0];
    NSArray* point_first = [pair_first componentsSeparatedByString:@" "];
    TEGeoPoint* firstPoint = [[TEGeoPoint alloc]init];
    firstPoint.longitude = [[point_first objectAtIndex:0] intValue] * 1.0 / 1000000;
    firstPoint.latitude = [[point_first objectAtIndex:1] intValue] * 1.0 / 1000000;
    [self.pointsList addObject:firstPoint];
    TEGeoPoint* lastPoint = firstPoint;
    int i = 1;
    for (i = 1;i<[arr_pair count];i++){
        NSString* pair_this = [arr_pair objectAtIndex:i];
        NSArray* point_this = [pair_this componentsSeparatedByString:@" "];
        
        TEGeoPoint* onePoint = [[TEGeoPoint alloc]init];
        if (2 != [point_this count])
        {
            break;
        }
        onePoint.longitude = [[point_this objectAtIndex:0] intValue] * 1.0 / 1000000 + lastPoint.longitude;
        onePoint.latitude = [[point_this objectAtIndex:1] intValue] * 1.0 / 1000000 + lastPoint.latitude;
        [self.pointsList addObject:onePoint];
        lastPoint = onePoint;
    }
}
@end
