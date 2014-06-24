//
//  NSString+Calculate.m
//  Trafficeye_new
//
//  Created by zc on 13-9-5.
//  Copyright (c) 2013年 张 驰. All rights reserved.
//

#import "NSString+Calculate.h"

@implementation NSString (Calculate)

-(int)calculateTextNumber
{
    NSString* textA = self;
	float number = 0.0;
	int index = 0;
	for (index = 0; index < [textA length]; index++) {
		
		NSString *character = [textA substringWithRange:NSMakeRange(index, 1)];
		
		if ([character lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3) {
			number++;
		} else {
			number = number+0.5;
		}
	}
	return ceil(number * 2);
}

@end
