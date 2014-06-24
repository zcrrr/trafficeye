//
//  TEBadge.h
//  Trafficeye_new
//
//  Created by 张 驰 on 13-7-31.
//  Copyright (c) 2013年 张 驰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TEBadge : NSObject

@property (nonatomic,strong) NSString* name;
@property (nonatomic,strong) NSString* condition;
@property (nonatomic,strong) NSString* image_name;

-(id)initWithData:(NSString*)name1 :(NSString*)con :(NSString*)image;

@end
