//
//  LongPressView.h
//  TrafficEye_Clean
//
//  Created by zc on 13-5-23.
//
//

#import "CNMKAnnotationView.h"

@interface LongPressView : CNMKAnnotationView
@property (nonatomic, retain) UIImageView* imageView_annotation;
@property (nonatomic) int index;
@property (strong,nonatomic) UIImageView* star1;
@property (strong,nonatomic) UIImageView* star2;
@property (strong,nonatomic) UIImageView* star3;
@property (strong,nonatomic) UIImageView* star4;
@property (strong,nonatomic) UIImageView* star5;
@end
