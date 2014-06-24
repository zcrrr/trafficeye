//
//  TEBusBubbleView.h
//  Trafficeye_new
//
//  Created by zc on 14-5-13.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import "CNMKAnnotationView.h"

@interface TEBusBubbleView : CNMKAnnotationView
@property (strong, nonatomic) NSString* text1;
@property (strong, nonatomic) NSString* text2;
@property (nonatomic, strong) UIImageView* imageView_annotation;

@end
