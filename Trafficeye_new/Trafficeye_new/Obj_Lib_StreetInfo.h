//
//  Obj_Lib_StreetInfo.h
//  Lib_SimplifiedDiagram
//
//  Created by Renton Lin on 12-6-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Obj_Lib_StreetInfo : NSObject
{
    NSString* _str_imgid;
    NSString* _str_imgname;
    NSString* _str_imgtype;
    NSMutableDictionary* _dic_sectionID_2_str_points;//sectionID 对应点的字符串
    
}
@property (nonatomic, retain) NSString* str_imgid;
@property (nonatomic, retain) NSString* str_imgname;
@property (nonatomic, retain) NSString* str_imgtype;
@property (nonatomic, readonly) NSMutableDictionary* dic_sectionID_2_str_points;

+ (NSArray*)generateStreetInfoArrayWithCityCode:(NSString*)cityCode;

//用道路ID去取文件，并解析sectionID和点的对应关系
@end
