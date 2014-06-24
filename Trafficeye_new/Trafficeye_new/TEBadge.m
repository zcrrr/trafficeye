//
//  TEBadge.m
//  Trafficeye_new
//
//  Created by 张 驰 on 13-7-31.
//  Copyright (c) 2013年 张 驰. All rights reserved.
//

#import "TEBadge.h"

@implementation TEBadge
@synthesize name;
@synthesize condition;
@synthesize image_name;

- (id)initWithData:(NSString *)name1 :(NSString *)con :(NSString *)image{
    if (self=[super init]) {
        self.name = name1;
        self.condition = con;
        self.image_name = image;
    }
    return self;
}
@end
