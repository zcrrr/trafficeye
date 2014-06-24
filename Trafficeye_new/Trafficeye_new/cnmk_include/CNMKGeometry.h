//
//  CNMKGeometry.h
//  cennavimapapi
//
//  Created by Lion on 12-2-12.
//  Copyright (c) 2012年 __CenNavi__. All rights reserved.
//


#import <CoreGraphics/CoreGraphics.h>
#import "CNMKTypes.h"


///屏幕坐标点
typedef struct {
    int x;	///< 横坐标
    int y;	///< 纵坐标
} CNMKScrPoint;

///屏幕坐标矩形大小
typedef struct {
    int width;	///< 宽度
    int height;	///< 高度
} CNMKScrSize;

///屏幕矩形
typedef struct {
    CNMKScrPoint origin;    ///< 屏幕左上点对应的屏幕坐标点
    CNMKScrSize size;       ///< 屏幕坐标范围
} CNMKScrRect;

/**
 *构造CNMKScrPoint对象
 *@param x 水平方向的坐标值
 *@param y 垂直方向的坐标值
 *@return 根据指定参数生成的CNMKScrPoint对象
 */
UIKIT_STATIC_INLINE CNMKScrPoint CNMKScrPointMake(int x, int y) {
    return (CNMKScrPoint){x, y};
}

UIKIT_STATIC_INLINE CGPoint CGPointFromCNMKScrPoint(CNMKScrPoint point) {
    return CGPointMake(point.x, point.y);
}

UIKIT_STATIC_INLINE CNMKScrPoint CNMKScrPointFromCGPoint(CGPoint point) {
    return CNMKScrPointMake(point.x, point.y);
}


/**
 *构造CNMKScrSize对象
 *@param width 宽度
 *@param height 高度
 *@return 根据指定参数生成的CNMKScrSize对象
 */
UIKIT_STATIC_INLINE CNMKScrSize CNMKScrSizeMake(int width, int height) {
    return (CNMKScrSize){width, height};
}

/**
 *构造CNMKScrRect对象
 *@param x 矩形左上顶点的x坐标值
 *@param y 矩形左上顶点的y坐标值
 *@param width 矩形宽度
 *@param height 矩形高度
 *@return 根据指定参数生成的CNMKScrRect对象
 */
UIKIT_STATIC_INLINE CNMKScrRect CNMKScrRectMake(int x, int y, int width, int height) {
    return (CNMKScrRect){ CNMKScrPointMake(x, y), CNMKScrSizeMake(width, height)};
}

UIKIT_STATIC_INLINE CNMKScrRect CNMKScrRectFromCGRect(CGRect rect) {
    return (CNMKScrRect){ CNMKScrPointMake(rect.origin.x, rect.origin.y), CNMKScrSizeMake(rect.size.width, rect.size.height)};
}

UIKIT_STATIC_INLINE CGRect CGRectFromCNMKScrRect(CNMKScrRect rect) {
    return CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
}

/**
 *判断矩形相交
 *@param rect1 矩形1
 *@param rect2 矩形2
 *@return 矩形2是否与矩形1相交
 */
UIKIT_STATIC_INLINE BOOL CNMKScrRectIntersects(CNMKScrRect rect1, CNMKScrRect rect2) {
    return !((rect2.origin.x + rect2.size.width) < rect1.origin.x 
             || rect2.origin.x > (rect1.origin.x + rect1.size.width) 
             || (rect2.origin.y + rect2.size.height) < rect1.origin.y  
             || rect2.origin.y > (rect1.origin.y + rect1.size.height));
}



///表示一个经纬度坐标点
typedef struct {
	double longitude;       ///< 经度
	double latitude;		///< 纬度
} CNMKGeoPoint;

///屏幕坐标矩形大小
typedef struct {
    double width;	///< 宽度
    double height;	///< 高度
} CNMKGeoSize;

///屏幕矩形
typedef struct {
    CNMKGeoPoint origin;    ///< 屏幕左上点对应的屏幕坐标点
    CNMKGeoSize size;       ///< 屏幕坐标范围
} CNMKGeoRect;

/**
 *构造CNMKGeoPoint对象
 *@param x 水平方向的坐标值
 *@param y 垂直方向的坐标值
 *@return 根据指定参数生成的CNMKGeoPoint对象
 */
UIKIT_STATIC_INLINE CNMKGeoPoint CNMKGeoPointMake(double longitude, double latitude) {
    return (CNMKGeoPoint){longitude, latitude};
}

UIKIT_STATIC_INLINE CNMKGeoPoint CNMKGeoPointFromCLLocationCoordinate2D(CLLocationCoordinate2D point) {
    return CNMKGeoPointMake(point.longitude, point.latitude);
}

UIKIT_STATIC_INLINE CLLocationCoordinate2D CLLocationCoordinate2DFromCNMKGeoPoint(CNMKGeoPoint point) {
    return CLLocationCoordinate2DMake(point.latitude, point.longitude);
}

/**
 *构造CNMKGeoSize对象
 *@param width 宽度
 *@param height 高度
 *@return 根据指定参数生成的CNMKGeoSize对象
 */
UIKIT_STATIC_INLINE CNMKGeoSize CNMKGeoSizeMake(double width, double height) {
    return (CNMKGeoSize){width, height};
}

/**
 *构造CNMKGeoRect对象
 *@param x 矩形左上顶点的x坐标值
 *@param y 矩形左上顶点的y坐标值
 *@param width 矩形宽度
 *@param height 矩形高度
 *@return 根据指定参数生成的CNMKGeoRect对象
 */
UIKIT_STATIC_INLINE CNMKGeoRect CNMKGeoRectMake(double longitude, double latitude, double width, double height) {
    return (CNMKGeoRect){ CNMKGeoPointMake(longitude, latitude), CNMKGeoSizeMake(width, height)};
}


/**
 *判断矩形相交
 *@param rect1 矩形1
 *@param rect2 矩形2
 *@return 矩形2是否与矩形1相交
 */
UIKIT_STATIC_INLINE BOOL CNMKGeoRectIntersects(CNMKGeoRect rect1, CNMKGeoRect rect2) {
    return !((rect2.origin.longitude + rect2.size.width) < rect1.origin.longitude 
             || rect2.origin.longitude > (rect1.origin.longitude + rect1.size.width) 
             || (rect2.origin.latitude + rect2.size.height) < rect1.origin.latitude  
             || rect2.origin.latitude > (rect1.origin.latitude + rect1.size.height));
}



//地理坐标点转换为世界坐标系屏幕坐标点
UIKIT_EXTERN CNMKScrPoint ScrPointForGeoPoint(CNMKGeoPoint geoPoint, int zoom);

//世界坐标系屏幕坐标点转换为地理坐标点 
UIKIT_EXTERN CNMKGeoPoint GeoPointForScrPoint(CNMKScrPoint scrPoint, int zoom);


//地理坐标矩形转换为世界坐标系屏幕坐标矩形
UIKIT_EXTERN CNMKScrRect ScrRectForGeoRect(CNMKGeoRect geoRect, int zoom);

//世界坐标系屏幕坐标矩形转换为地理坐标矩形 
UIKIT_EXTERN CNMKGeoRect GeoRectForScrRect(CNMKScrRect scrRect, int zoom);


