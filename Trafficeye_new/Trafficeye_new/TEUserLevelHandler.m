//
//  TEUserLevelHandler.m
//  Trafficeye_new
//
//  Created by zc on 13-9-5.
//  Copyright (c) 2013年 张 驰. All rights reserved.
//

#import "TEUserLevelHandler.h"

@implementation TEUserLevelHandler
@synthesize Levels;
static  TEUserLevelHandler* myPoint2LevelManager = nil;

-(id)initWithFile
{
    if (self = [super init])
    {
        NSString* path = [[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:@"LevelVSPoint.txt"];
        NSError* error;
        error = nil;
        NSString* string = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
        if (nil != error)
        {
#ifdef MYDEBUG
            NSLog(@"Reading pointVSlevel file failed: %@", [error description]);
#endif
        }
        else
        {
            NSMutableArray* array_result = [[NSMutableArray alloc]init];
            NSArray* array_pair = [string componentsSeparatedByString:@"\r"];
            int num_pairs = [array_pair count];
            for (int i = 0; i < num_pairs; i++)
            {
                NSString* str_onePair = [array_pair objectAtIndex:i];
                //mark 这里为汉字符号，
                NSArray* array_temp = [str_onePair componentsSeparatedByString:@"，"];
                if (2 == [array_temp count])
                {
                    int front = [[array_temp objectAtIndex:0] intValue];
                    int after = [[array_temp objectAtIndex:1] intValue];
                    if (i == front)
                    {
                        NSNumber* number = [NSNumber numberWithInt:after];
                        [array_result addObject:number];
#ifdef MYDEBUG
                        //                        NSLog(@"等级i的下限积分为%d", after);
#endif
                    }
                    else
                    {
#ifdef MYDEBUG
                        NSLog(@"读取文件出错， 行号有误, 该行为%@", str_onePair);
#endif
                    }
                }
                else
                {
#ifdef MYDEBUG
                    NSLog(@"读取文件出错， 分割逗号返回结果不为2项,该行为%@", str_onePair);
#endif
                }
            }
            self.Levels = array_result;
        }
    }
    return  self;
}

+(TEUserLevelHandler*)sharedInstance
{
    if (nil == myPoint2LevelManager)
    {
        myPoint2LevelManager = [[TEUserLevelHandler alloc]initWithFile];
    }
    return myPoint2LevelManager;
}



-(int)privateGenerateLevelWithPoint:(int)point
{
    int level = 0;
    int maxLevel = 100;
    if (nil != self.Levels && maxLevel <= [self.Levels count])
    {
        if ([[self.Levels objectAtIndex:100] intValue] < point)
        {
            level = 100;
        }
        else
        {
            //tobedone 换二分
            for (int i = 0; i < [self.Levels count] - 1; i++)
            {
                int value_front = [[self.Levels objectAtIndex:i] intValue];
                int value_after = [[self.Levels objectAtIndex:i+1] intValue];
                if (value_front <= point && value_after > point)
                {
                    level = i;
                }
            }
        }
    }
    else
    {
    }
    return level;
}

+(int)generateLevelWithPoint:(int)point
{
    TEUserLevelHandler* point2level = [TEUserLevelHandler sharedInstance];
    return [point2level privateGenerateLevelWithPoint:point];
}

-(int)privateGetPointWithLevel:(int)level
{
    int point = 0;
    level = level > 100? 100:level;
    int maxLevel = 100;
    
    if ([self.Levels count] < maxLevel)
    {
#ifdef MYDEBUG
        NSLog(@"Generate level failed, the max level is lower than 100!");
#endif
    }
    else
    {
        point = [[self.Levels objectAtIndex:level] intValue];
    }
    return point;
}

-(int)privateGetNextLevelPoint:(int)level
{
    int point = 0;
    int nextLevel = level+1 > 100? 100:level+1;
    int maxLevel = 100;
    
    if ([self.Levels count] < maxLevel)
    {
#ifdef MYDEBUG
        NSLog(@"Generate level failed, the max level is lower than 100!");
#endif
        point = [[self.Levels lastObject] intValue];
    }
    else
    {
        point = [[self.Levels objectAtIndex:nextLevel] intValue];
    }
    return point;
}

+(int)getLevelPointWithLevel:(int)level
{
    int point = 0;
    TEUserLevelHandler* point2level = [TEUserLevelHandler sharedInstance];
    point = [point2level privateGetPointWithLevel:level];
    return point;
}

+(int)getNextLevelPoint:(int)level
{
    int point = 0;
    TEUserLevelHandler* point2level = [TEUserLevelHandler sharedInstance];
    point = [point2level privateGetNextLevelPoint:level];
    return point;
}



@end
