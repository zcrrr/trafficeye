//
//  TEBusStationAnnoView.h
//  Trafficeye_new
//
//  Created by zc on 14-5-13.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import "CNMKAnnotationView.h"

@interface TEBusStationAnnoView : CNMKAnnotationView
@property (assign, nonatomic) int index;
@property (nonatomic, strong) UIImageView* imageView_annotation;

@end
