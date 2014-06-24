//
//  LongPressView.m
//  TrafficEye_Clean
//
//  Created by zc on 13-5-23.
//
//

#import "LongPressView.h"

@implementation LongPressView
@synthesize imageView_annotation;
@synthesize index;
@synthesize star1;
@synthesize star2;
@synthesize star3;
@synthesize star4;
@synthesize star5;

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
    float x_fix = -80;
    float y_fix = -bounds.size.height;
    frame.origin.x += x_fix;
    frame.origin.y += y_fix;
    [self addSubview:self.imageView_annotation];
    [self.imageView_annotation setFrame:bounds];
    [self setFrame:frame];
    
    self.star1 = [[UIImageView alloc]init];
    self.star1.frame = CGRectMake(8, 25, 25, 25);
    [self.imageView_annotation addSubview:self.star1];
    self.star2 = [[UIImageView alloc]init];
    self.star2.frame = CGRectMake(38, 25, 25, 25);
    [self.imageView_annotation addSubview:self.star2];
    self.star3 = [[UIImageView alloc]init];
    self.star3.frame = CGRectMake(68, 25, 25, 25);
    [self.imageView_annotation addSubview:self.star3];
    self.star4 = [[UIImageView alloc]init];
    self.star4.frame = CGRectMake(98, 25, 25, 25);
    [self.imageView_annotation addSubview:self.star4];
    self.star5 = [[UIImageView alloc]init];
    self.star5.frame = CGRectMake(128, 25, 25, 25);
    [self.imageView_annotation addSubview:self.star5];
    [self setStarImageByIndex];
}

-(void)appear
{
    [super appear];
    if ([self animatesDrop]) {
        _animatesDrop = NO;
    }
}
- (void)setStarImageByIndex{
    switch (self.index) {
        case 0:
        {
            star1.image = [UIImage imageNamed:@"star_empty.png"];
            star2.image = [UIImage imageNamed:@"star_empty.png"];
            star3.image = [UIImage imageNamed:@"star_empty.png"];
            star4.image = [UIImage imageNamed:@"star_empty.png"];
            star5.image = [UIImage imageNamed:@"star_empty.png"];
            break;
        }
        case 5:
        {
            star1.image = [UIImage imageNamed:@"star_half.png"];
            star2.image = [UIImage imageNamed:@"star_empty.png"];
            star3.image = [UIImage imageNamed:@"star_empty.png"];
            star4.image = [UIImage imageNamed:@"star_empty.png"];
            star5.image = [UIImage imageNamed:@"star_empty.png"];
            break;
        }
        case 10:
        {
            star1.image = [UIImage imageNamed:@"star_full.png"];
            star2.image = [UIImage imageNamed:@"star_empty.png"];
            star3.image = [UIImage imageNamed:@"star_empty.png"];
            star4.image = [UIImage imageNamed:@"star_empty.png"];
            star5.image = [UIImage imageNamed:@"star_empty.png"];
            break;
        }
        case 15:
        {
            star1.image = [UIImage imageNamed:@"star_full.png"];
            star2.image = [UIImage imageNamed:@"star_half.png"];
            star3.image = [UIImage imageNamed:@"star_empty.png"];
            star4.image = [UIImage imageNamed:@"star_empty.png"];
            star5.image = [UIImage imageNamed:@"star_empty.png"];
            break;
        }
        case 20:
        {
            star1.image = [UIImage imageNamed:@"star_full.png"];
            star2.image = [UIImage imageNamed:@"star_full.png"];
            star3.image = [UIImage imageNamed:@"star_empty.png"];
            star4.image = [UIImage imageNamed:@"star_empty.png"];
            star5.image = [UIImage imageNamed:@"star_empty.png"];
            break;
        }
        case 25:
        {
            star1.image = [UIImage imageNamed:@"star_full.png"];
            star2.image = [UIImage imageNamed:@"star_full.png"];
            star3.image = [UIImage imageNamed:@"star_half.png"];
            star4.image = [UIImage imageNamed:@"star_empty.png"];
            star5.image = [UIImage imageNamed:@"star_empty.png"];
            break;
        }
        case 30:
        {
            star1.image = [UIImage imageNamed:@"star_full.png"];
            star2.image = [UIImage imageNamed:@"star_full.png"];
            star3.image = [UIImage imageNamed:@"star_full.png"];
            star4.image = [UIImage imageNamed:@"star_empty.png"];
            star5.image = [UIImage imageNamed:@"star_empty.png"];
            break;
        }
        case 35:
        {
            star1.image = [UIImage imageNamed:@"star_full.png"];
            star2.image = [UIImage imageNamed:@"star_full.png"];
            star3.image = [UIImage imageNamed:@"star_full.png"];
            star4.image = [UIImage imageNamed:@"star_half.png"];
            star5.image = [UIImage imageNamed:@"star_empty.png"];
            break;
        }
        case 40:
        {
            star1.image = [UIImage imageNamed:@"star_full.png"];
            star2.image = [UIImage imageNamed:@"star_full.png"];
            star3.image = [UIImage imageNamed:@"star_full.png"];
            star4.image = [UIImage imageNamed:@"star_full.png"];
            star5.image = [UIImage imageNamed:@"star_empty.png"];
            break;
        }
        case 45:
        {
            star1.image = [UIImage imageNamed:@"star_full.png"];
            star2.image = [UIImage imageNamed:@"star_full.png"];
            star3.image = [UIImage imageNamed:@"star_full.png"];
            star4.image = [UIImage imageNamed:@"star_full.png"];
            star5.image = [UIImage imageNamed:@"star_half.png"];
            break;
        }
        case 50:
        {
            star1.image = [UIImage imageNamed:@"star_full.png"];
            star2.image = [UIImage imageNamed:@"star_full.png"];
            star3.image = [UIImage imageNamed:@"star_full.png"];
            star4.image = [UIImage imageNamed:@"star_full.png"];
            star5.image = [UIImage imageNamed:@"star_full.png"];
            break;
        }
        default:
            break;
    }
}


@end
