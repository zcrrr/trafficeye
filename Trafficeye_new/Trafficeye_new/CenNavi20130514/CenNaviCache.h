//
//  CenNaviCache.h
//  CenNavi
//
//  Created by Lin Renton on 13-3-20.
//
//

#import <Foundation/Foundation.h>
#import "TrafficMap.h"

@interface CenNaviCache : NSObject

@property (strong, nonatomic) TrafficMap* cityMap;//城市全图
@property (strong, nonatomic) NSMutableDictionary* areaMapDic;//商圈图的字典

@property (strong, nonatomic) NSArray* routeList;//道路列表，一般只需要下载一次

+ (CenNaviCache*)getCacheInstance;//采用单例，只有一个cache

- (void)updateCityMapInfo:(NSString*) mapid : (UIImage*) image : (long) time : (int) refreshTime : (NSString*) text;//更新全域图相关数据
- (void)updateAreaMapInfo:(NSString*) mapid : (UIImage*) image : (long) time : (int) refreshTime : (NSString*) text;//更新全域图相关数据

- (TrafficMap*)getCityMap;
- (TrafficMap*)getAreaMapById:(NSString*) mapid;

- (void)clearCityMapInfo;
- (void)clearOneAreaMapInfo:(NSString*) mapid;

@end
