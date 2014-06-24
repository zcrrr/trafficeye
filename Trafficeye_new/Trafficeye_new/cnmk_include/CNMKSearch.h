//
//  CNMKSearch.h
//  cennavimapapi
//
//  Created by Lion on 12-2-13.
//  Copyright (c) 2012年 __CenNavi__. All rights reserved.
//


#import "CNMKGeometry.h"


@class CNMKSearchInternal;
@protocol CNMKSearchDelegate;

@interface CNMKSearch : NSObject {
	id<CNMKSearchDelegate> _delegate;
	int _busPolicy;
	int _routingPolicy;
}

@property (nonatomic, retain) id<CNMKSearchDelegate> delegate;
///公交检索策略
@property (nonatomic) int busPolicy;
///驾乘检索策略
@property (nonatomic) int routingPolicy;


//POI查询
//POI城市关键字查询
- (BOOL)poiSearchInCity:(NSString*)city withKey:(NSString*)key;
//POI周边查询
- (BOOL)poiSearchInCity:(NSString*)city withCenter:(CNMKGeoPoint)point radius:(NSInteger)radius types:(NSArray *)types;
//POI矩形范围查询
- (BOOL)poiSearchInCity:(NSString*)city withRect:(CNMKGeoRect)rect types:(NSArray *)types;

//公交路线查询    time格式：HH:MM
- (BOOL)busSearchInCity:(NSString *)city startPoint:(CNMKGeoPoint)startPoint endPoint:(CNMKGeoPoint)endPoint
                   time:(NSString *)time;

//驾车路线查询
- (BOOL)routingSearchStartPoint:(CNMKGeoPoint)startPoint endPoint:(CNMKGeoPoint)endPoint 
                      midPoints:(CNMKGeoPoint *)midPoints midPointCnt:(NSInteger)midPointCnt;

//POI支持城市
- (NSArray *)poiCityList;

//POI支持类型
- (NSArray *)poiTypeList;

//公交路线支持城市
- (NSArray *)busCityList;

@end


///搜索delegate，用于获取搜索结果
@protocol CNMKSearchDelegate<NSObject>
@optional
/**
 *返回坐标点所在城市
 */
- (void)onGetCity:(NSString *)city forLocation:(CNMKGeoPoint)location errorCode:(int)errorCode;

/**
 *返回POI搜索结果
 *@param poiResultList 搜索结果列表，成员类型为CNMKPoiResult
 *@param type 返回结果类型： CNMKTypePoiList,CNMKTypeAreaPoiList,CNMKAreaMultiPoiList
 *@param error 错误号，@see CNMKErrorCode
 */
- (void)onGetPoiResult:(NSArray*)result searchType:(int)type errorCode:(int)error;

/**
 *返回公交搜索结果
 *@param result 搜索结果
 *@param error 错误号，@see CNMKErrorCode
 */
- (void)onGetBusResult:(id)result errorCode:(int)error;

/**
 *返回驾乘搜索结果
 *@param result 搜索结果
 *@param error 错误号，@see CNMKErrorCode
 */
- (void)onGetRoutingResult:(id)result errorCode:(int)error;

@end
