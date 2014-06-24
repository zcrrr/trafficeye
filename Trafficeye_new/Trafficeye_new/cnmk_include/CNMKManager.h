//
//  CNMKManager.h
//  cennavimapapi
//
//  Created by Lion on 12-2-12.
//  Copyright (c) 2012年 __CenNavi__. All rights reserved.
//


///主引擎类
@interface CNMKManager : NSObject

/**
 *启动引擎
 *@param key 申请的有效key
 *@param delegate 
 */
- (BOOL)start:(NSString*)key;

/**
 *停止引擎
 */
- (BOOL)stop;

@end

