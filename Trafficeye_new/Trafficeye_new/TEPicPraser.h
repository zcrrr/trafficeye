//
//  TEPicPraser.h
//  Trafficeye_new
//
//  Created by zc on 13-11-20.
//  Copyright (c) 2013年 张 驰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TEPicPraser : NSObject

@property (strong, nonatomic) NSMutableArray* citylist;

- (void)praseCityXML;

@end
