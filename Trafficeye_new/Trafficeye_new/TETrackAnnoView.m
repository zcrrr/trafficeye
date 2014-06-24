//
//  TETrackAnnoView.m
//  Trafficeye_new
//
//  Created by zc on 13-9-22.
//  Copyright (c) 2013年 张 驰. All rights reserved.
//

#import "TETrackAnnoView.h"

@implementation TETrackAnnoView
@synthesize speed;
@synthesize imageView_annotation;
@synthesize label_speed;

-(void)updateAnnotationView
{
    [super updateAnnotationView];
    
    CGRect frame = [self frame];
    CGRect bounds = [self bounds];
    //坐标置换为view的坐标
    float x_fix = -12;
    float y_fix = -bounds.size.height;
    frame.origin.x += x_fix;
    frame.origin.y += y_fix;
    [self addSubview:self.imageView_annotation];
    [self.imageView_annotation setFrame:bounds];
    [self setFrame:frame];
    if(self.tag == 1050){
        
    }else{
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(-5 , 8 , 38, 13)];
        self.label_speed = label;
        self.label_speed.text = [NSString stringWithFormat:@"%d", (int)self.speed];
        self.label_speed.textColor = [UIColor whiteColor];
        self.label_speed.textAlignment = NSTextAlignmentCenter;
        self.label_speed.backgroundColor = [UIColor clearColor];
        [self.label_speed setAdjustsFontSizeToFitWidth:YES];
        [self.imageView_annotation addSubview:self.label_speed];
        UILabel* label_string = [[UILabel alloc]initWithFrame:CGRectMake(-5 , 20 , 38, 9)];
        label_string.text = @" kmh";
        label_string.textAlignment = NSTextAlignmentCenter;
        label_string.backgroundColor = [UIColor clearColor];
        label_string.textColor = [UIColor whiteColor];
        label_string.font = [UIFont systemFontOfSize:10];
        [self.imageView_annotation addSubview:label_string];
        
    }
}

-(void)appear
{
    [super appear];
    if ([self animatesDrop]) {
        _animatesDrop = NO;
    }
}

@end
