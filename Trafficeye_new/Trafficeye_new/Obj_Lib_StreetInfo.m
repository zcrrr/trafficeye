//
//  Obj_Lib_StreetInfo.m
//  Lib_SimplifiedDiagram
//
//  Created by Renton Lin on 12-6-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Obj_Lib_StreetInfo.h"
#import "XMLReader.h"


@interface Obj_Lib_StreetInfo (private_)
+ (NSArray*)generateStreetInfoArrayFromData:(NSData*)data;
//从字符串里面生成sectionID与坐标的对应关系
- (NSDictionary*)generateDicFormString:(NSString*)string;

@end

@implementation Obj_Lib_StreetInfo(private_)

+ (NSArray*)generateStreetInfoArrayFromData:(NSData*)data
{
    NSMutableArray* arr_return = [[NSMutableArray alloc]init];
    NSDictionary* dic_result = nil;
    dic_result = [XMLReader dictionaryForXMLData:data];
    
    id id_result = [dic_result valueForKey:@"result"];
    id id_cityInfo = [id_result valueForKey:@"imgInfo"];
    if ([id_cityInfo isKindOfClass:[NSDictionary class]])
    {
        Obj_Lib_StreetInfo* obj_streetInfo = [[Obj_Lib_StreetInfo alloc]init];
        obj_streetInfo.str_imgid = [id_cityInfo valueForKey:@"imgid"];
        obj_streetInfo.str_imgname = [id_cityInfo valueForKey:@"imgname"];
        obj_streetInfo.str_imgtype = [id_cityInfo valueForKey:@"imgtype"];
        [arr_return addObject:obj_streetInfo];
    }
    else {
        for (int i = 0 ; i < [id_cityInfo count]; i++)
        {
            id id_oneCityInfo = [id_cityInfo objectAtIndex:i];
#ifdef MYDEUBG_LIB
            //        NSLog(@"%@", [id_oneCityInfo description]);  
#endif
            Obj_Lib_StreetInfo* obj_streetInfo = [[Obj_Lib_StreetInfo alloc]init];
            obj_streetInfo.str_imgid = [id_oneCityInfo valueForKey:@"imgid"];
            obj_streetInfo.str_imgname = [id_oneCityInfo valueForKey:@"imgname"];
            obj_streetInfo.str_imgtype = [id_oneCityInfo valueForKey:@"imgtype"];
            [arr_return addObject:obj_streetInfo];
        }
#ifdef MYDEUBG_LIB
        //    NSLog(@"dic_result is %@", dic_result);
        //    NSLog(@"id_resut class is %@", [[id_result class] description]);
        //    NSLog(@"id_cityInfo class is %@", [[id_cityInfo class] description]);
#endif
    }
    return arr_return;
}

- (NSDictionary*)generateDicFormString:(NSString*)string
{
#ifdef MYDEUBG_LIB
    //    NSLog(@"generateDicFromString:%@", string);
#endif
    NSMutableDictionary* dic_return = [[NSMutableDictionary alloc]init];
    
    NSArray* array_lines = [string componentsSeparatedByString:@"\n"];
    if (0 == array_lines.count || nil == array_lines)
    {
#ifdef MYDEUBG_LIB
        NSLog(@"%@ 数据有误,换行分割后数组为空", string);
#endif
        return nil;
    }
    for (int i = 0; i < array_lines.count; i++)
    {
        NSString* str_oneLine = [array_lines objectAtIndex:i];
        if (nil != str_oneLine && ![str_oneLine isEqualToString:@""])
        {
            NSArray* arr_parts = [str_oneLine componentsSeparatedByString:@","];
            int count_parts = [arr_parts count];
//            if (3 > count_parts || (0 != count_parts && 3 != count_parts && 5 != count_parts && 7 != count_parts))
            if (3 > count_parts)
            {
#ifdef MYDEUBG_LIB
//                NSLog(@"%@ 数据有误,逗号分割后数组一行个数不超过3", str_oneLine);
#endif
                continue;
            }
            NSString* str_sectionID = [arr_parts objectAtIndex:0];
            [dic_return setValue:str_oneLine forKey:str_sectionID];
        }
    }
    return dic_return;
}

@end


@implementation Obj_Lib_StreetInfo
@synthesize str_imgid = _str_imgid;
@synthesize str_imgname = _str_imgname;
@synthesize str_imgtype = _str_imgtype;
@synthesize dic_sectionID_2_str_points = _dic_sectionID_2_str_points;

- (id)init
{
#ifdef MYDEUBG_LIB
//    NSLog(@"init");
#endif
    if (self = [super init])
    {
        _dic_sectionID_2_str_points = [[NSMutableDictionary alloc]init];
    }
    return self;
}

//- (id)initWithString:(NSString*)string
//{
//#ifdef MYDEUBG_LIB
////    NSLog(@"initwithstring");
//#endif
//    if (self = [self init])//..这里用super 和 self 的区别，一个会调用父类的，一个会调用自己的？因为这是一个实例方法?
//    {
//        if (nil == string || [string isEqualToString:@""])
//        {
//#ifdef MYDEUBG_LIB
//            NSLog(@"传进来的字符串为空!");
//#endif
//            return nil;
//        }
//        _dic_sectionID_2_str_points = [[NSMutableDictionary alloc]init];
//        NSArray* arr_result = [string componentsSeparatedByString:@" "];
//        if (7 != arr_result.count)
//        {
//#ifdef MYDEUBG_LIB
//            NSLog(@"%@ 该行的项数有误", string); 
//#endif
//        }
//        else {
//            NSString* str_imgid = [arr_result objectAtIndex:1];
//            NSString* str_imgname = [arr_result objectAtIndex:2];
//            NSString* str_imgtype = [arr_result objectAtIndex:4];
//#ifdef FlagCheckData
//            if ([[str_imgid componentsSeparatedByString:@"\""] count] < 2)
//            {
//                NSLog(@"%@数据有误", string);
//            }
//#endif
//            self.str_imgid = [[str_imgid componentsSeparatedByString:@"\""] objectAtIndex:1];
//            self.str_imgname = [[str_imgname componentsSeparatedByString:@"\""] objectAtIndex:1];
//            self.str_imgtype = [[str_imgtype componentsSeparatedByString:@"\""] objectAtIndex:1];
//#ifdef MYDEUBG_LIB
//            NSLog(@"streetInfo is %@", self.description);      
//#endif
//        }
//        
//    }
//    return self;
//}
- (void)dealloc
{
}

+ (NSArray*)generateStreetInfoArrayWithCityCode:(NSString*)cityCode
{
    NSString* path = [[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.xml", cityCode]];;
    NSData* data = [NSData dataWithContentsOfFile:path];
#ifdef MYDEUBG_LIB
    if (nil == data || 0 == data.length)
    {
        NSLog(@"读取城市道路列表，返回结果为空，城市ID为:%@", cityCode);
    }
#endif
    return [self generateStreetInfoArrayFromData:data];
}


//- (NSDictionary*)generateDicSecionID_2_str_points
//{
//    NSString* path = [[Lib_SimplifiedDiagram getFilePath]stringByAppendingPathComponent:[NSString stringWithFormat:@"/map/%@.txt", self.str_imgid]];
//    NSData* data = [NSData dataWithContentsOfFile:path];
//    if (nil == data)
//    {
//        NSString* str_cache_path = [[Lib_SimplifiedDiagram getCachePath]stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@.txt", self.str_imgid]];
//        data = [NSData dataWithContentsOfFile:str_cache_path];
//        if (nil == data)
//        {
//        #ifdef MYDEUBG_LIB
//            NSLog(@"section文件路径为%@", str_cache_path);
//            NSLog(@"读取section文件出错,streetID:%@", self.str_imgid);
//        #endif
//            return nil;
//        }
//        else {
//        }
//    }  
//    
//    NSString* str_data = [[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]autorelease];
//    return [self generateDicFormString:str_data];
//}

- (NSString*)description
{
    return [NSString stringWithFormat:@"id = %@ name = %@ type = %@", self.str_imgid, self.str_imgname, self.str_imgtype];
}
@end
