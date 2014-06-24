//
//  Obj_Lib_CityInfo.h
//  LibProject_SimplifiedDiagram
//
//  Created by Renton Lin on 12-6-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//@class Obj_Lib_StreetInfo;

@interface Obj_Lib_CityInfo : NSObject
{
    NSString* _str_cityCode;
    NSString* _str_cityName;
    NSString* _str_mainMapID;
    
    NSMutableArray* _arr_streets;
}

@property (nonatomic, retain) NSString* str_cityCode;
@property (nonatomic, retain) NSString* str_cityName;
@property (nonatomic, retain) NSString* str_mainMapID;
@property (nonatomic, readonly) NSMutableArray* arr_streets;

//从NSData中获取所有的CityInfo;
+(NSArray*)generateCityInfoArrayWithData:(NSData*)data;

//这种解析文件的方式太2，弃用
//-(id)initWithString:(NSString*)string;

//生成道路列表
- (void)generateStreetArray;


@end
