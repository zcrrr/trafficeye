//
//  CNMKShapeView.h
//  cennavimapapi
//
//  Created by Lion on 12-2-19.
//  Copyright (c) 2012年 __CenNavi__. All rights reserved.
//

#import "CNMKOverlayView.h"
#import "CNMKShape.h"

//形状视图基类
@interface CNMKShapeView : CNMKOverlayView {
    @package    
    UIColor *_fillColor;
    UIColor *_strokeColor;
    
    CGFloat _lineWidth;
    CGLineJoin _lineJoin;
    CGLineCap _lineCap;
    CGFloat _miterLimit;
    CGFloat _lineDashPhase;
    NSArray *_lineDashPattern;
}

/// 填充颜色
@property (retain) UIColor *fillColor;
/// 画笔颜色
@property (retain) UIColor *strokeColor;

/// 画笔宽度，默认为0
@property CGFloat lineWidth;
/// LineJoin，默认为kCGLineJoinRound
@property CGLineJoin lineJoin;
/// LineCap，默认为kCGLineCapRound
@property CGLineCap lineCap;
/// miterLimit,在样式为kCGLineJoinMiter时有效，默认为10
@property CGFloat miterLimit;
/// lineDashPhase, 默认为0
@property CGFloat lineDashPhase;
/// lineDashPattern,一个NSNumbers的数组，默认为nil
@property (copy) NSArray *lineDashPattern;

@end

//形状线视图
@interface CNMKPolylineView : CNMKShapeView

@end

//形状面视图
@interface CNMKPolygonView : CNMKShapeView

@end

//圆视图
@interface CNMKCircleView : CNMKShapeView

@end