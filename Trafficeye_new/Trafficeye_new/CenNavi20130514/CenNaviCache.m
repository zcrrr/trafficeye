//
//  CenNaviCache.m
//  CenNavi
//
//  Created by Lin Renton on 13-3-20.
//
//

#import "CenNaviCache.h"

@implementation CenNaviCache
@synthesize cityMap;
@synthesize areaMapDic;
@synthesize routeList;

static CenNaviCache* cennaviCache = nil;

+ (CenNaviCache*)getCacheInstance{
    if (cennaviCache == nil)
    {
        cennaviCache = [[self alloc]init];
    }
    return cennaviCache;
}
- (void)updateCityMapInfo:(NSString *)mapid :(UIImage *)image :(long)time :(int)refreshTime :(NSString *)text{
    if(self.cityMap == nil){
        self.cityMap = [[TrafficMap alloc]init];
    }
    self.cityMap.mapId = mapid;
    self.cityMap.image = image;
    self.cityMap.time = time;
    self.cityMap.refreshTime = refreshTime;
    self.cityMap.text = text;
}

- (void)updateAreaMapInfo:(NSString *)mapid :(UIImage *)image :(long)time :(int)refreshTime :(NSString *)text{
    if(self.areaMapDic == nil){
        self.areaMapDic = [[NSMutableDictionary alloc]init];
    }
    TrafficMap* trafficmap = [[TrafficMap alloc]init];
    trafficmap.mapId = mapid;
    trafficmap.image = image;
    trafficmap.time = time;
    trafficmap.refreshTime = refreshTime;
    trafficmap.text = text;
    [self.areaMapDic setValue:trafficmap forKey:mapid];
}

- (TrafficMap*)getCityMap{
    if(self.cityMap != nil){
        //判断是否过期
        if([self getNowTime] - self.cityMap.time > self.cityMap.refreshTime){//过期
            self.cityMap = nil;
        }else{
            return self.cityMap;
        }
    }
    return nil;
}


- (TrafficMap*)getAreaMapById:(NSString *)mapid{
    TrafficMap *trafficMap = [self.areaMapDic objectForKey:mapid];
    if(trafficMap != nil){
        //判断是否过期
        if([self getNowTime] - trafficMap.time > trafficMap.refreshTime){//过期
            trafficMap = nil;
        }else{
            return trafficMap;
        }
    }
    return nil;
}
- (long)getNowTime{
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSLog(@"%@",datenow);
    NSTimeInterval timeinterval = [datenow timeIntervalSince1970];
    return timeinterval;
}

- (void)clearCityMapInfo{
    self.cityMap = nil;
}

- (void)clearOneAreaMapInfo:(NSString *)mapid{
    [self.areaMapDic setValue:nil forKey:mapid];
}
@end
