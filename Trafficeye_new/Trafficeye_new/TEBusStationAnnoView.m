//
//  TEBusStationAnnoView.m
//  Trafficeye_new
//
//  Created by zc on 14-5-13.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import "TEBusStationAnnoView.h"

@implementation TEBusStationAnnoView
@synthesize index;
@synthesize imageView_annotation;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)updateAnnotationView
{
    [super updateAnnotationView];
    if(self.tag == 1999){//展示点
        CGRect frame = [self frame];
        CGRect bounds = [self bounds];
        //坐标置换为view的坐标
        float x_fix = -11;
        float y_fix = -22;
        frame.origin.x += x_fix;
        frame.origin.y += y_fix;
        [self addSubview:self.imageView_annotation];
        [self.imageView_annotation setFrame:bounds];
        [self setFrame:frame];
    }else if(self.tag == 2345){//起点or终点
        CGRect frame = [self frame];
        CGRect bounds = [self bounds];
        //坐标置换为view的坐标
        float x_fix = -11;
        float y_fix = -32;
        frame.origin.x += x_fix;
        frame.origin.y += y_fix;
        [self addSubview:self.imageView_annotation];
        [self.imageView_annotation setFrame:bounds];
        [self setFrame:frame];
    }else{
        CGRect frame = [self frame];
        CGRect bounds = [self bounds];
        //坐标置换为view的坐标
        float x_fix = -11;
        float y_fix = -11;
        frame.origin.x += x_fix;
        frame.origin.y += y_fix;
        [self addSubview:self.imageView_annotation];
        [self.imageView_annotation setFrame:bounds];
        [self setFrame:frame];
        if(self.tag == 1234){//bus图标不需要加数字
            
        }else{
            UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(4 , 4 , 14, 14)];
            label.text = [NSString stringWithFormat:@"%d", self.index];
            label.textColor = [UIColor blueColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = [UIColor clearColor];
            [label setAdjustsFontSizeToFitWidth:YES];
            [self.imageView_annotation addSubview:label];
        }
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
