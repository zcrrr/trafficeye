//
//  TEPolylineWithSpeed.m
//  Trafficeye_new
//
//  Created by zc on 13-9-22.
//  Copyright (c) 2013年 张 驰. All rights reserved.
//

#import "TEPolylineViewWithSpeed.h"

@implementation TEPolylineViewWithSpeed


- (void)drawRect:(CGRect)rect
{
    if (![_overlay isKindOfClass:[CNMKPolyline class]]) {
        return;
    }
    CNMKPolyline *polyline = _overlay;
    if (polyline.pointCount < 2) {
        return;
    }
    
#ifdef MYDEBUG
    //    NSLog(@"start drawing");
    //    NSDate* date_start =[NSDate date];
#endif
    // 得到绘制上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, self.frame);
    
    // 坐标点转换,真实坐标->屏幕坐标
    CNMKScrPoint *scrPoints = (CNMKScrPoint *)malloc(sizeof(CNMKScrPoint) * polyline.pointCount);
    memset(scrPoints, 0, sizeof(CNMKScrPoint) * polyline.pointCount);
    for (int pointIdx = 0; pointIdx < polyline.pointCount; pointIdx++) {
        scrPoints[pointIdx] = ScrPointForGeoPoint(polyline.points[pointIdx], [self zoomLevel]);
    }
    
    int pointCnt = polyline.pointCount;
    //...NSLog(@"pointCount==%d",polyline.pointCount);
    
    // 图形类型设置
    CGContextSetLineWidth(context, _lineWidth + 10);
    CGContextSetLineCap(context, _lineCap);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    //绘制底部的白色边
    // 绘制图形
    CGContextMoveToPoint(context, scrPoints[0].x, scrPoints[0].y);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    for (int iPointIdx = 1; iPointIdx < pointCnt; iPointIdx++) {
        CGContextAddLineToPoint(context, scrPoints[iPointIdx].x, scrPoints[iPointIdx].y);
    }
    CGContextStrokePath(context);
    
    //绘制有色的线条
    //tobedone 得根据速度来填颜色
    CGContextMoveToPoint(context, scrPoints[0].x, scrPoints[0].y);
    CGContextSetLineWidth(context, _lineWidth + 6);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetStrokeColorWithColor(context, self.strokeColor.CGColor);
    for (int iPointIdx = 1; iPointIdx < pointCnt; iPointIdx++) {
        CGContextAddLineToPoint(context, scrPoints[iPointIdx].x, scrPoints[iPointIdx].y);
    }
    CGContextStrokePath(context);
    
    const float PI = 3.141592653;
    const float distance_limit = 15;//必须越过 distance_limit 像素才绘线
    const float distance_betweenNextTrace = 7;
    const float distance_toDrawArrow = 7;//取末端5象素距离左右的点来确定方向（5象素似乎就可以视为一条线或者拐弯了,主要是使箭头方向比较正确）,其实降噪后这种情况会好一点.注意这个距离是两点之间的直线距离
    const float rate_arrow = 1;//上面的长度乘以一个系数
    const float rate = 3.0 / 4;//最后两点间的距离乘以一个系数来控制箭头间的间隔
    for (int i = 0; i < pointCnt - 1;)
    {
        int start_idx = i;
        int end_idx = i + 1;
        int last_idx = i;//上一个点，用来计算距离
        float distance_total = 0;
        
        CNMKScrPoint startPoint = scrPoints[start_idx];
        CNMKScrPoint lastPoint = scrPoints[last_idx];
        CNMKScrPoint endPoint = scrPoints[end_idx];
        float delta_x;
        float delta_y;
        float distance_rate_Of_lastTwoPoint = 0;//最后两点间的距离
        //取一串点，进行绘制
        do {
            //绘箭头
            startPoint = scrPoints[start_idx];
            lastPoint = scrPoints[last_idx];
            endPoint = scrPoints[end_idx];
            
            float delta_x_temp = (endPoint.x - lastPoint.x);
            float delta_y_temp = (endPoint.y - lastPoint.y);
            float distance = sqrtf(pow((delta_x_temp),2) + pow((delta_y_temp),2));
            distance_rate_Of_lastTwoPoint = distance * rate;
            distance_total += distance;
            last_idx = end_idx;
            end_idx += 1;
        }while(distance_total < distance_limit && end_idx < pointCnt - 1);
        
        //取箭头末端足够长的一段来确定箭头方向
        int temp_idx = last_idx;
        float distance_forDirection = 0;
        while (distance_toDrawArrow * rate_arrow > distance_forDirection && temp_idx > start_idx)
        {
            temp_idx--;
            CNMKScrPoint point_selected = scrPoints[temp_idx];
            CNMKScrPoint point_last = scrPoints[last_idx];
            delta_x = (point_last.x - point_selected.x);
            delta_y = (point_last.y - point_selected.y);
            distance_forDirection = sqrtf(pow((delta_x),2) + pow((delta_y),2));
        }
        
        i = end_idx;
        
        if (pointCnt - 1 <= end_idx && distance_total < distance_limit && 0 != start_idx)
        {
            break;
        }
        
#define use_interval
        
#ifdef use_interval
        //为了保证一定的间隔，取下一个点,考虑进上一次最后两点间的距离乘以rate
#ifdef MYDEBUG
        //            NSLog(@"寻找下一个起始点开始");
        //            NSLog(@"起始为%d", i);
#endif
        int start_idx_ = i;
        int end_idx_ = i + 1;
        int last_idx_ = i;
        CNMKScrPoint startPoint_ = scrPoints[start_idx_];
        CNMKScrPoint lastPoint_ = scrPoints[last_idx_];
        CNMKScrPoint endPoint_ = scrPoints[end_idx_];
        float distance_total_ = distance_rate_Of_lastTwoPoint;
        
        while(distance_total_ < distance_betweenNextTrace && end_idx_ < pointCnt - 1)
        {
            //绘箭头
            startPoint_ = scrPoints[start_idx_];
            lastPoint_ = scrPoints[last_idx_];
            endPoint_ = scrPoints[end_idx_];
            
            float delta_x = (endPoint_.x - lastPoint_.x);
            float delta_y = (endPoint_.y - lastPoint_.y);
            float distance = sqrtf(pow((delta_x),2) + pow((delta_y),2));
            distance_total_ += distance;
            last_idx_ = end_idx_;
            end_idx_ += 1;
        }
        
        i = end_idx_;
#ifdef MYDEBUG
        //        NSLog(@"寻找下一个点结束");
        //        NSLog(@"下一个点为%d", i);
#endif
#endif
        CNMKScrPoint middlePoint;
        middlePoint.x = (int)((double)lastPoint.x + ((double)endPoint.x - (double)lastPoint.x)* rate);
        middlePoint.y = (int)((double)lastPoint.y + ((double)endPoint.y - (double)lastPoint.y)* rate);
        
        if (0 == delta_y && 0 == delta_x)
        {
            continue;
        }
        //与x轴正方向夹角
        float angle_move = 0;
        if (0 == delta_x)
        {
            if (0 <= delta_y)
            {
                angle_move = PI / 2;
            }
            else {
                angle_move = - PI / 2;
            }
        }
        else if (0 == delta_y)
        {
            if (0 <= delta_x)
            {
                angle_move = 0;
            }
            else {
                angle_move = PI;
            }
        }
        else {
            angle_move = atanf(delta_y / delta_x);
            if (0 > delta_x)
            {
                angle_move = PI + angle_move;
            }
        }
        //逆时针旋转角度
        float angle_rotate = PI * 3 / 2 + angle_move;// 2 * PI - (PI / 2 - angle_move)
        //箭头的角度（一半）
        float angle = PI / 6;
        const float length = 6;//箭头边的长度
        //右边的点的坐标
        float x_origin_right = length * sin(angle);
        float y_origin_right = -length * cos(angle);
        //左边的点的坐标
        float x_origin_left = -length * sin(angle);
        float y_origin_left = -length * cos(angle);
        
        //得到新的箭头的两个顶点
        CNMKScrPoint topPoint = middlePoint;
        CNMKScrPoint rightPoint;
        rightPoint.x = (int)((float)topPoint.x + (x_origin_right * cos(angle_rotate) - y_origin_right * sin(angle_rotate)) + 0.5);
        rightPoint.y = (int)(float)topPoint.y + (x_origin_right * sin(angle_rotate) + y_origin_right * cos(angle_rotate) + 0.5);
        
        CNMKScrPoint leftPoint;
        leftPoint.x = (int)((float)topPoint.x + (x_origin_left * cos(angle_rotate) - y_origin_left * sin(angle_rotate)) + 0.5);
        leftPoint.y = (int)((float)topPoint.y + (x_origin_left * sin(angle_rotate) + y_origin_left * cos(angle_rotate)) + 0.5);
        
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextSetLineWidth(context, 1);
        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
        //画边，不填，查看方向
        //        CGContextMoveToPoint(context, topPoint.x, topPoint.y);
        //        CGContextAddLineToPoint(context, rightPoint.x, rightPoint.y);
        //        CGContextAddLineToPoint(context, topPoint.x, topPoint.y);
        //        CGContextAddLineToPoint(context, leftPoint.x, leftPoint.y);
        //        CGContextStrokePath(context);
        //画实心的三角
        CGContextSetAllowsAntialiasing(context, YES);
        CGContextMoveToPoint(context, topPoint.x, topPoint.y);
        CGContextAddLineToPoint(context, rightPoint.x, rightPoint.y);
        CGContextAddLineToPoint(context, leftPoint.x, leftPoint.y);
        CGContextAddLineToPoint(context, topPoint.x, topPoint.y);
        CGContextDrawPath(context, kCGPathFillStroke);
        
        CGContextSetLineWidth(context, 2);
        CGContextMoveToPoint(context, startPoint.x, startPoint.y);
        for (int j = start_idx; j < last_idx; j++)
        {
#ifdef MYDEBUG
            //            NSLog(@"绘轨迹 起点为%d 终点为%d", start_idx, last_idx);
#endif
            CNMKScrPoint nextPoint = scrPoints[j];
            CGContextAddLineToPoint(context, nextPoint.x, nextPoint.y);
        }
        CGContextAddLineToPoint(context, topPoint.x, topPoint.y);
        CGContextStrokePath(context);
    }
    
    //测试用:绘所有的点
    //#define kDrawPoints
#ifdef kDrawPoints
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    for (int i = 0; i <= pointCnt - 1;i ++)
    {
        CGRect rect = CGRectMake(scrPoints[i].x, scrPoints[i].y, 2, 2);
        CGContextAddEllipseInRect(context, rect);
        CGContextDrawPath(context, kCGPathFillStroke);
    }
#endif
    // 释放点集内存
    if (scrPoints) {
        free(scrPoints);
    }
    
#ifdef MYDEBUG
    //    NSDate* date_end =[NSDate date];
    //    NSLog(@"一次绘制耗时 %f", [date_end timeIntervalSinceDate:date_start]);
#endif
}

@end
