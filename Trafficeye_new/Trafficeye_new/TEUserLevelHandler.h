//
//  TEUserLevelHandler.h
//  Trafficeye_new
//
//  Created by zc on 13-9-5.
//  Copyright (c) 2013年 张 驰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TEUserLevelHandler : NSObject
@property (nonatomic, strong) NSMutableArray* Levels;

+(TEUserLevelHandler*)sharedInstance;
+(int)generateLevelWithPoint:(int)point;
+(int)getNextLevelPoint:(int)level;
+(int)getLevelPointWithLevel:(int)level;


@end
