//
//  TEPersistenceHandler.h
//  Trafficeye_new
//
//  Created by zc on 13-9-3.
//  Copyright (c) 2013年 张 驰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TEPersistenceHandler : NSObject

//获取plist path
+ (NSString *)getDocument:(NSString *)fileName;
//存储到plist
+ (void)saveToPlist:(NSString *)fileName :(id)arrayOrDic;

@end
