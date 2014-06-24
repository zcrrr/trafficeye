//
//  CNMKShape.h
//  cennavimapapi
//
//  Created by Lion on 12-2-19.
//  Copyright (c) 2012年 __CenNavi__. All rights reserved.
//

#import "CNMKOverlay.h"

//形状基类
@interface CNMKShape : NSObject <CNMKOverlay> {
    CNMKGeoPoint *_points;
    int _pointCount;
    BOOL _encrypted;
}

@property (nonatomic) CNMKGeoPoint *points;
@property (nonatomic) int pointCount;
@property (nonatomic) BOOL encrypted;

+ (id)shapeWithGeoPoints:(CNMKGeoPoint *)points count:(NSUInteger)count;

@end

//折线
@interface CNMKPolyline : CNMKShape
+ (id)polylineWithGeoPoints:(CNMKGeoPoint *)points count:(NSUInteger)count;

@end

//多边形
@interface CNMKPolygon : CNMKShape
+ (id)polygonWithGeoPoints:(CNMKGeoPoint *)points count:(NSUInteger)count;

@end

//圆
@interface CNMKCircle : CNMKShape {
    double _radius;
}

@property (nonatomic) double radius;
@property (nonatomic, readonly) CNMKGeoPoint centerCoordinate;

+ (id)circleWithGeoPoint:(CNMKGeoPoint)coordinate radius:(double)radius;

@end