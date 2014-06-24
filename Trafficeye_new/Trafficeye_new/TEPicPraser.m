//
//  TEPicPraser.m
//  Trafficeye_new
//
//  Created by zc on 13-11-20.
//  Copyright (c) 2013年 张 驰. All rights reserved.
//

#import "TEPicPraser.h"
#import "XMLReader.h"
#import "Obj_Lib_CityInfo.h"

@implementation TEPicPraser
@synthesize citylist;

- (void)praseCityXML{
    NSString* path = [[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:@"citylist.xml"];
    NSData* data_info = [NSData dataWithContentsOfFile:path];
    if (nil == data_info){
        NSLog(@"城市列表读取失败");
        return;
    }
    self.citylist = [[NSMutableArray alloc]init];
    NSDictionary* dic_result = nil;
    dic_result = [XMLReader dictionaryForXMLData:data_info];
    
    id id_result = [dic_result valueForKey:@"result"];
    id id_cityInfo = [id_result valueForKey:@"cityInfo"];
    for (int i = 0 ; i < [id_cityInfo count]; i++)
    {
        id id_oneCityInfo = [id_cityInfo objectAtIndex:i];
        Obj_Lib_CityInfo* obj_cityInfo = [[Obj_Lib_CityInfo alloc]init];
        obj_cityInfo.str_cityCode = [id_oneCityInfo valueForKey:@"cityCode"];
        obj_cityInfo.str_cityName = [id_oneCityInfo valueForKey:@"cityName"];
        obj_cityInfo.str_mainMapID = [id_oneCityInfo valueForKey:@"simpleMap"];
        [self.citylist  addObject:obj_cityInfo];
    }
    for (int i = 0; i < self.citylist .count; i++)
    {
        id id_oneCityInfo = [self.citylist  objectAtIndex:i];
        if ([id_oneCityInfo isKindOfClass:[Obj_Lib_CityInfo class]])
        {
            Obj_Lib_CityInfo* obj_cityInfo = id_oneCityInfo;
            [obj_cityInfo generateStreetArray];
        }
    }
    NSLog(@"");
}

@end
