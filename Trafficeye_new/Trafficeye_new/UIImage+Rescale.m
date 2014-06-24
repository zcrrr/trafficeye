//
//  UIImage+Rescale.m
//  Trafficeye_new
//
//  Created by zc on 13-9-6.
//  Copyright (c) 2013年 张 驰. All rights reserved.
//

#import "UIImage+Rescale.h"

@implementation UIImage (Rescale)

- (UIImage *)rescaleImageToSize:(CGSize)size {
    CGRect rect = CGRectMake(0.0, 0.0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    [self drawInRect:rect];
    UIImage *resImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resImage;
}
@end
