//
//  TEPersistenceHandler.m
//  Trafficeye_new
//
//  Created by zc on 13-9-3.
//  Copyright (c) 2013年 张 驰. All rights reserved.
//

#import "TEPersistenceHandler.h"

@implementation TEPersistenceHandler

+(NSString*)getDocument:(NSString *)fileName
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
	NSString *document = [paths objectAtIndex:0];
	NSString *path = [document stringByAppendingPathComponent:fileName];
	return path;
}

+ (void)saveToPlist:(NSString *)fileName :(id)arrayOrDic{
    NSString* filePath = [TEPersistenceHandler getDocument:fileName];
    [arrayOrDic writeToFile:filePath atomically:YES];
}


@end
