//
//  Obj_Lib_CityInfo.m
//  LibProject_SimplifiedDiagram
//
//  Created by Renton Lin on 12-6-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Obj_Lib_CityInfo.h"
#import "Obj_Lib_StreetInfo.h"
#import "XMLReader.h"

@implementation Obj_Lib_CityInfo
@synthesize  str_cityCode = _str_cityCode;
@synthesize  str_cityName = _str_cityName;
@synthesize  str_mainMapID = _str_mainMapID;
@synthesize arr_streets = _arr_streets;

- (id)init
{
    if (self = [super init])
    {
        
    }
    return self;
}

- (void)dealloc
{
    
}
+(NSArray*)generateCityInfoArrayWithData:(NSData*)data
{
    NSMutableArray* arr_return = [[NSMutableArray alloc]init];
    NSDictionary* dic_result = nil;
    dic_result = [XMLReader dictionaryForXMLData:data];

    id id_result = [dic_result valueForKey:@"result"];
    id id_cityInfo = [id_result valueForKey:@"cityInfo"];
    for (int i = 0 ; i < [id_cityInfo count]; i++)
    {
        id id_oneCityInfo = [id_cityInfo objectAtIndex:i];
        Obj_Lib_CityInfo* obj_cityInfo = [[Obj_Lib_CityInfo alloc]init];
        obj_cityInfo.str_cityCode = [id_oneCityInfo valueForKey:@"cityCode"];
        obj_cityInfo.str_cityName = [id_oneCityInfo valueForKey:@"cityName"];
        obj_cityInfo.str_mainMapID = [id_oneCityInfo valueForKey:@"simpleMap"];
        [arr_return addObject:obj_cityInfo];
    }
    
    return arr_return;
}

- (void)generateStreetArray
{
    if (nil != _arr_streets)
    {
        _arr_streets = nil;
    }
    _arr_streets = [[NSMutableArray alloc]initWithArray:[Obj_Lib_StreetInfo generateStreetInfoArrayWithCityCode:_str_cityCode]];
}
@end
