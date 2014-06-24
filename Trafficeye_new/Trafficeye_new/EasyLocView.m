//
//  EasyLocView.m
//  TrafficEye_Clean
//
//  Created by zc on 13-5-23.
//
//

#import "EasyLocView.h"

@implementation EasyLocView

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
-(id)init
{
    if (self = [super init])
    {
        
    }
    return self;
}


-(void)updateAnnotationView
{
    [super updateAnnotationView];
    
    CGRect frame = [self frame];
    CGRect bounds = [self bounds];
    //坐标置换为view的坐标
    float x_fix = -25;
    float y_fix = -25;
    frame.origin.x += x_fix;
    frame.origin.y += y_fix;
    [self addSubview:self.imageView_annotation];
    [self.imageView_annotation setFrame:bounds];
    [self setFrame:frame];
}

-(void)appear
{
    [super appear];
    if ([self animatesDrop]) {
        _animatesDrop = NO;
    }
}

@end
