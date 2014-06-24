//
//  TEBusBubbleView.m
//  Trafficeye_new
//
//  Created by zc on 14-5-13.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import "TEBusBubbleView.h"

@implementation TEBusBubbleView
@synthesize text1;
@synthesize text2;
@synthesize imageView_annotation;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)updateAnnotationView
{
    [super updateAnnotationView];
    if(self.tag == 1){//站点
        CGRect frame = [self frame];
        CGRect bounds = [self bounds];
        //坐标置换为view的坐标
        float x_fix = -91;
        float y_fix = -57;
        frame.origin.x += x_fix;
        frame.origin.y += y_fix;
        [self addSubview:self.imageView_annotation];
        [self.imageView_annotation setFrame:bounds];
        [self setFrame:frame];
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0 , 5 , 183, 40)];
        label.text = text1;
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:18];
        [label setAdjustsFontSizeToFitWidth:YES];
        [self.imageView_annotation addSubview:label];
    }else{//公交
        CGRect frame = [self frame];
        CGRect bounds = [self bounds];
        //坐标置换为view的坐标
        float x_fix = -105;
        float y_fix = -57;
        frame.origin.x += x_fix;
        frame.origin.y += y_fix;
        [self addSubview:self.imageView_annotation];
        [self.imageView_annotation setFrame:bounds];
        [self setFrame:frame];
        UILabel* label1 = [[UILabel alloc]initWithFrame:CGRectMake(0 , 5 , 210, 20)];
        label1.text = text1;
        label1.textColor = [UIColor blackColor];
        label1.textAlignment = NSTextAlignmentCenter;
        label1.backgroundColor = [UIColor clearColor];
        label1.font = [UIFont systemFontOfSize:16];
        [label1 setAdjustsFontSizeToFitWidth:YES];
        [self.imageView_annotation addSubview:label1];
        UILabel* label2 = [[UILabel alloc]initWithFrame:CGRectMake(0 , 25 , 210, 18)];
        label2.text = text2;
        label2.textColor = [UIColor blackColor];
        label2.textAlignment = NSTextAlignmentCenter;
        label2.backgroundColor = [UIColor clearColor];
        label2.font = [UIFont systemFontOfSize:14];
        [label2 setAdjustsFontSizeToFitWidth:YES];
        [self.imageView_annotation addSubview:label2];
    }
}

-(void)appear
{
    [super appear];
    if ([self animatesDrop]) {
        _animatesDrop = NO;
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
