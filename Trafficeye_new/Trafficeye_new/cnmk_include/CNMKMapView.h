//
//  CNMKMapView.h
//  cennavimapapi
//
//  Created by Lion on 12-2-12.
//  Copyright (c) 2012年 __CenNavi__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CNMKTypes.h"
#import "CNMKGeometry.h"
#import "CNMKOverlay.h"
#import "CNMKOverlayView.h"
#import "CNMKAnnotation.h"
#import "CNMKAnnotationView.h"

#import "CNMKSearchType.h"

@class CNMKMapViewInternal;
@class CNMKOverlayView;
@protocol CNMKMapViewDelegate;
@protocol CNMKOverlay;

@class CNMKMapViewInternal;

@interface CNMKMapView : UIView
{
@private
    CNMKMapViewInternal *_internal;	
}


/// 地图View的Delegate
@property (nonatomic, assign) id<CNMKMapViewDelegate> delegate;

/// 当前地图类型，可设定为普通模式或实时路况模式
@property (nonatomic) CNMKMapType mapType;

/// 出租车图层是否打开
@property (nonatomic) BOOL taxiOn;

/// 当前地图的经纬度范围，设定的该范围可能会被调整为适合地图窗口显示的范围
@property (nonatomic) CNMKGeoRect region;

/**
 *设定当前地图的显示范围
 *@param region 要设定的地图范围，用经纬度的方式表示
 *@param animated 是否采用动画效果
 */
- (void)setRegion:(CNMKGeoRect)region animated:(BOOL)animated;

/// 当前地图的中心点，改变该值时，地图的比例尺级别不会发生变化
@property (nonatomic) CNMKGeoPoint centerCoordinate;

/**
 *设定地图中心点坐标
 *@param coordinate 要设定的地图中心点坐标，用经纬度表示
 *@param animated 是否采用动画效果
 */
- (void)setCenterCoordinate:(CNMKGeoPoint)coordinate animated:(BOOL)animated;

/// 地图比例尺级别，在手机上当前可使用的级别为3-18级
@property (nonatomic) int zoomLevel;

/**
 *放大一级比例尺
 *@return 是否成功
 */
- (BOOL)zoomIn;

/**
 *缩小一级比例尺
 *@return 是否成功
 */
- (BOOL)zoomOut;


///当前地图范围，采用直角坐标系表示，向右向下增长
@property (nonatomic, readonly) CNMKScrRect visibleMapRect;


///设定地图View能否支持用户多点缩放
@property(nonatomic, getter=isZoomEnabled) BOOL zoomEnabled;
///设定地图View能否支持用户移动地图
@property(nonatomic, getter=isScrollEnabled) BOOL scrollEnabled;

/// 设定是否显示定位图层
@property (nonatomic) BOOL showsUserLocation;

/// 当前用户位置，返回坐标为加密坐标
@property (nonatomic, readonly) CNMKLocation *userLocation;

/// 返回定位坐标点是否在当前地图可视区域内
@property (nonatomic, readonly, getter=isUserLocationVisible) BOOL userLocationVisible;


@end


#pragma mark Annotation

@interface CNMKMapView (Annotation)

/**
 *向地图窗口添加标注，需要实现CNMKMapViewDelegate的-mapView:viewForAnnotation:函数来生成标注对应的View
 *@param annotation 要添加的标注
 */
- (void)addAnnotation:(id <CNMKAnnotationOverlay>)annotation;

/**
 *向地图窗口添加一组标注，需要实现CNMKMapViewDelegate的-mapView:viewForAnnotation:函数来生成标注对应的View
 *@param annotations 要添加的标注数组
 */
- (void)addAnnotations:(NSArray *)annotations;

/**
 *移除标注
 *@param annotation 要移除的标注
 */
- (void)removeAnnotation:(id <CNMKAnnotationOverlay>)annotation;

/**
 *移除一组标注
 *@param annotation 要移除的标注数组
 */
- (void)removeAnnotations:(NSArray *)annotations;

/// 当前地图View的已经添加的标注数组
@property (nonatomic, readonly) NSArray *annotations;

/**
 *查找指定标注对应的View，如果该标注尚未显示，返回nil
 *@param annotation 指定的标注
 *@return 指定标注对应的View
 */
- (CNMKAnnotationView *)viewForAnnotation:(id <CNMKAnnotationOverlay>)annotation;


/**
 *选中指定的标注，本版暂不支持animate效果
 *@param annotation 指定的标注
 *@param animated 本版暂不支持
 */
- (void)selectAnnotation:(id <CNMKAnnotationOverlay>)annotation animated:(BOOL)animated;

/**
 *取消指定的标注的选中状态，本版暂不支持animate效果
 *@param annotation 指定的标注
 *@param animated 本版暂不支持
 */
- (void)deselectAnnotation:(id <CNMKAnnotationOverlay>)annotation animated:(BOOL)animated;

@end


#pragma mark Overlay

@interface CNMKMapView (Overlay)

/**
 *向地图窗口添加Overlay，需要实现CNMKMapViewDelegate的-mapView:viewForOverlay:函数来生成标注对应的View
 *@param overlay 要添加的overlay
 */
- (void)addOverlay:(id <CNMKOverlay>)overlay;

/**
 *向地图窗口添加一组Overlay，需要实现CNMKMapViewDelegate的-mapView:viewForOverlay:函数来生成标注对应的View
 *@param overlays 要添加的overlay数组
 */
- (void)addOverlays:(NSArray *)overlays;

/**
 *移除Overlay
 *@param overlay 要移除的overlay
 */
- (void)removeOverlay:(id <CNMKOverlay>)overlay;

/**
 *移除一组Overlay
 *@param overlays 要移除的overlay数组
 */
- (void)removeOverlays:(NSArray *)overlays;


/// 当前mapView中已经添加的Overlay数组
@property (nonatomic, readonly) NSArray *overlays;

/**
 *查找指定overlay对应的View，如果该View尚未创建，返回nil
 *@param overlay 指定的overlay
 *@return 指定overlay对应的View
 */
- (CNMKOverlayView *)viewForOverlay:(id <CNMKOverlay>)overlay;

@end


#pragma mark Search Overlay

@interface CNMKMapView (SearchOverlay)

- (BOOL)setBusResult:(CNMKBusResult *)result showPlan:(int)brlIdx;
- (void)removeBusResult;

- (BOOL)setRoutingResult:(CNMKRoutingResult *)result;
- (void)removeRoutingResult;

@end


#pragma mark Convert

@interface CNMKMapView (Convert)

/**
 *将经纬度坐标转换为View坐标
 *@param coordinate 待转换的经纬度坐标
 *@param view 指定相对的View
 *@return 转换后的View坐标
 */
- (CGPoint)convertCoordinate:(CNMKGeoPoint)coordinate toPointToView:(UIView *)view;

/**
 *将View坐标转换成经纬度坐标
 *@param point 待转换的View坐标
 *@param view point坐标所在的view
 *@return 转换后的经纬度坐标
 */
- (CNMKGeoPoint)convertPoint:(CGPoint)point toCoordinateFromView:(UIView *)view;

/**
 *将经纬度矩形区域转换为View矩形区域
 *@param region 待转换的经纬度矩形
 *@param view 指定相对的View
 *@return 转换后的View矩形区域
 */
- (CGRect)convertRegion:(CNMKGeoRect)region toRectToView:(UIView *)view;

/**
 *将View矩形区域转换成经纬度矩形区域
 *@param rect 待转换的View矩形区域
 *@param view rect坐标所在的view
 *@return 转换后的经纬度矩形区域
 */
- (CNMKGeoRect)convertRect:(CGRect)rect toRegionFromView:(UIView *)view;

/**
 *将直角地理坐标矩形区域转换为View矩形区域
 *@param mapRect 待转换的直角地理坐标矩形
 *@param view 指定相对的View
 *@return 转换后的View矩形区域
 */
- (CGRect)convertMapRect:(CNMKScrRect)mapRect toRectToView:(UIView *)view;

/**
 *将View矩形区域转换成直角地理坐标矩形区域
 *@param rect 待转换的View矩形区域
 *@param view rect坐标所在的view
 *@return 转换后的直角地理坐标矩形区域
 */
- (CNMKScrRect)convertRect:(CGRect)rect toMapRectFromView:(UIView *)view;


@end



/// MapView的Delegate，mapView通过此类来通知用户对应的事件
@protocol CNMKMapViewDelegate <NSObject>
@optional

/**
 *地图区域即将改变时会调用此接口
 *@param mapview 地图View
 *@param animated 是否动画
 */
//- (void)mapView:(CNMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated;

/**
 *地图区域改变完成后会调用此接口
 *@param mapview 地图View
 *@param animated 是否动画
 */
//- (void)mapView:(CNMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated;

/**
 *根据anntation生成对应的View
 *@param mapView 地图View
 *@param annotation 指定的标注
 *@return 生成的标注View
 */
- (CNMKAnnotationView *)mapView:(CNMKMapView *)mapView viewForAnnotation:(id <CNMKAnnotationOverlay>)annotation;

/**
 *当mapView新添加annotation views时，调用此接口
 *@param mapView 地图View
 *@param views 新添加的annotation views
 */
- (void)mapView:(CNMKMapView *)mapView didAddAnnotationViews:(NSArray *)views;

/**
 *当选中一个annotation views时，调用此接口
 *@param mapView 地图View
 *@param views 选中的annotation views
 */
- (void)mapView:(CNMKMapView *)mapView didSelectAnnotationView:(CNMKAnnotationView *)view;

/**
 *当取消选中一个annotation views时，调用此接口
 *@param mapView 地图View
 *@param views 取消选中的annotation views
 */
- (void)mapView:(CNMKMapView *)mapView didDeselectAnnotationView:(CNMKAnnotationView *)view;

/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)mapViewWillStartLocatingUser:(CNMKMapView *)mapView;

/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)mapViewDidStopLocatingUser:(CNMKMapView *)mapView;

/**
 *用户位置更新后，会调用此函数
 *@param mapView 地图View
 *@param userLocation 新的用户位置
 */
- (void)mapView:(CNMKMapView *)mapView didUpdateUserLocation:(CNMKLocation *)userLocation;

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)mapView:(CNMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error;


/**
 *当点击annotation view弹出的泡泡时，调用此接口
 *@param mapView 地图View
 *@param view 泡泡所属的annotation view
 */
- (void)mapView:(CNMKMapView *)mapView annotationViewForBubble:(CNMKAnnotationView *)view;

/**
 *根据overlay生成对应的View
 *@param mapView 地图View
 *@param overlay 指定的overlay
 *@return 生成的覆盖物View
 */
- (CNMKOverlayView *)mapView:(CNMKMapView *)mapView viewForOverlay:(id <CNMKOverlay>)overlay;

/**
 *当mapView新添加overlay views时，调用此接口
 *@param mapView 地图View
 *@param overlayViews 新添加的overlay views
 */
- (void)mapView:(CNMKMapView *)mapView didAddOverlayViews:(NSArray *)overlayViews;



/**
 *地图移动相关Delegate方法
 */

#pragma mark - map move

/**
 *地图移动
 */
- (void)mapViewDidScroll:(CNMKMapView *)mapView;

/**
 *开始拖拽地图
 */
- (void)mapViewWillBeginDragging:(CNMKMapView *)mapView;

/**
 *结束拖拽地图
 */
- (void)mapViewDidEndDragging:(CNMKMapView *)mapView willDecelerate:(BOOL)decelerate;

/**
 *开始减速缓冲
 */
- (void)mapViewWillBeginDecelerating:(CNMKMapView *)mapView;

/**
 *结束减速缓冲
 */
- (void)mapViewDidEndDecelerating:(CNMKMapView *)mapView;

/**
 *比例尺变化
 */
- (void)mapViewDidZooming:(CNMKMapView *)mapView;

/**
 *开始缩放
 */
- (void)mapViewWillBeginZooming:(CNMKMapView *)mapView;


@end


