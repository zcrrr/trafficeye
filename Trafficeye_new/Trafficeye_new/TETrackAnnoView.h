//
//  TETrackAnnoView.h
//  Trafficeye_new
//
//  Created by zc on 13-9-22.
//  Copyright (c) 2013年 张 驰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CNMapKit.h"

@interface TETrackAnnoView : CNMKAnnotationView

@property (nonatomic, assign) float speed;
@property (nonatomic, strong) UIImageView* imageView_annotation;
@property (nonatomic, strong) UILabel* label_speed;

@end
