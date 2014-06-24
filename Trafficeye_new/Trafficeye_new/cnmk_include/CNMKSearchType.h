//
//  CNMKSearchType.h
//  cennavimapapi
//
//  Created by Lion on 12-2-14.
//  Copyright (c) 2012年 __CenNavi__. All rights reserved.
//

#import "CNMKGeometry.h"

//查询类型
enum {
    CNMKSearchTypePoi = 0,          ///<POI检索
    CNMKSearchTypePoiTypeList,      ///<POI检索类型：POI类型
    CNMKSearchTypePoiCityList,      ///<POI检索类型：支持城市列表
    CNMKSearchTypePoiCity,          ///<POI检索类型：城市查询
    CNMKSearchTypePoiArea,          ///<POI检索类型：周边查询
    CNMKSearchTypePoiRect,          ///<POI检索类型：矩形范围查询
    CNMKSearchTypeBus = 10,         ///<公交换乘检索
    CNMKSearchTypeBusCityList,      ///<公交换乘检索：支持城市列表
    CNMKSearchTypeBusTime,          ///<公交换乘策略常量：时间优先
    CNMKSearchTypeBusTransfer,      ///<公交换乘策略常量：最少换乘
    CNMKSearchTypeBusSubway,        ///<公交换乘策略常量：地铁优先
    CNMKSearchTypeBusWalk,          ///<公交换乘策略常量：最小步行距离
    CNMKSearchTypeRouting = 20,     ///<驾车路线检索
    CNMKSearchTypeRoutingTime,      ///<驾车路线策略常量：时间优先
    CNMKSearchTypeRoutingDist,      ///<驾车路线策略常量：距离优先
    CNMKSearchTypeRoutingEco,       ///<驾车路线策略常量：经济模式
    CNMKSearchTypeRoutingCost,      ///<驾车路线策略常量：费用优先
};



///POI查询：支持城市列表
@interface CNMKPoiCityList : NSObject {
@private
    NSInteger       acnt;           //城市总数
    NSDictionary    *area;          //key:城市代码  value:城市名称
}

@property (nonatomic)           NSInteger acnt;             //城市总数
@property (nonatomic, retain)   NSDictionary *area;         //key:城市代码  value:城市名称

@end

///POI查询：POI信息
@interface CNMKPoiInfo : NSObject {
@private
    NSInteger       pid;            //记录唯一编码
    NSString        *name;          //记录名称
    CNMKGeoPoint    coordinate;     //坐标
    NSString        *addr;          //地址信息
    NSString        *ctlg;          //分类代码
    NSString        *tel;           //电话号码
    NSInteger       dist;           //距离中心点的距离（周边查询要求返回查询信息时有效）
    NSString        *desc;          //其他描述
}

@property (nonatomic)       NSInteger       pid;            //记录唯一编码
@property (nonatomic, copy) NSString        *name;          //记录名称
@property (nonatomic)       CNMKGeoPoint    coordinate;     //坐标
@property (nonatomic, copy) NSString        *addr;          //地址信息
@property (nonatomic, copy) NSString        *ctlg;          //分类代码
@property (nonatomic, copy) NSString        *tel;           //电话号码
@property (nonatomic)       NSInteger       dist;           //距离中心点的距离（周边查询要求返回查询信息时有效）
@property (nonatomic, copy) NSString        *desc;          //其他描述

@end

///POI查询结果
@interface CNMKPoiResult : NSObject {
@private
    NSInteger       acnt;           //当页记录数量
    NSInteger       totalpage;      //搜索结果总页数
    NSArray         *pois;          //记录列表
}

@property (nonatomic)           NSInteger       acnt;           //当页记录数量
@property (nonatomic)           NSInteger       totalpage;      //搜索结果总页数
@property (nonatomic, retain)   NSArray         *pois;          //记录列表

@end



///公交换乘方案查询：公交线路
@interface CNMKBusLine : NSObject {
@private
    NSString        *linename;      //线路名称
    NSInteger       stopcnt;        //要乘坐的站点数（不包括第一站）
    NSInteger       swdist;         //到上车站点的步行距离（单位：米）
    NSString        *swdir;         //到上车站点的方向
    NSInteger       usid;           //上车站点ID
    NSString        *usname;        //上车站点名称
    CNMKGeoPoint    sp;             //上车站点坐标
    NSInteger       dsid;           //下车站点ID
    NSString        *dsname;        //下车站点名称
    CNMKGeoPoint    ep;             //下车站点坐标
    NSInteger       clistcnt;       //坐标个数
    CNMKGeoPoint    *clist;         //坐标列
}

@property (nonatomic, copy) NSString        *linename;      //线路名称
@property (nonatomic)       NSInteger       stopcnt;        //要乘坐的站点数（不包括第一站）
@property (nonatomic)       NSInteger       swdist;         //到上车站点的步行距离（单位：米）
@property (nonatomic, copy) NSString        *swdir;         //到上车站点的方向
@property (nonatomic)       NSInteger       usid;           //上车站点ID
@property (nonatomic, copy) NSString        *usname;        //上车站点名称
@property (nonatomic)       CNMKGeoPoint    sp;             //上车站点坐标
@property (nonatomic)       NSInteger       dsid;           //下车站点ID
@property (nonatomic, copy) NSString        *dsname;        //下车站点名称
@property (nonatomic)       CNMKGeoPoint    ep;             //下车站点坐标
@property (nonatomic)       NSInteger       clistcnt;       //坐标个数
@property (nonatomic)       CNMKGeoPoint    *clist;         //坐标列

@end

///公交换乘方案查询：公交换乘推荐路线
@interface CNMKBusRecommendLine : NSObject {
@private
    NSInteger       brldist;        //推荐路线的总里程
    NSInteger       linecnt;        //推荐路线所含的线路数
    NSArray         *lines;         //每条的线路信息
    NSInteger       ewdist;         //最后一个公交站点到目的地的距离
    NSString        *ewdir;         //最后一个公交站点到目的地的方向，距离为0时为空，否则为八方向
}

@property (nonatomic)           NSInteger       brldist;        //推荐路线的总里程
@property (nonatomic)           NSInteger       linecnt;        //推荐路线所含的线路数
@property (nonatomic, retain)   NSArray         *lines;         //每条的线路信息
@property (nonatomic)           NSInteger       ewdist;         //最后一个公交站点到目的地的距离
@property (nonatomic, copy)     NSString        *ewdir;         //最后一个公交站点到目的地的方向，距离为0时为空，否则为八方向

@end

///公交换乘方案查询结果
@interface CNMKBusResult : NSObject {
@private
    NSInteger       brlcnt; //公交换乘推荐线路数
    NSArray         *brls;  //推荐的每条路线
    
    CNMKGeoPoint    sp;     //起始点
    CNMKGeoPoint    ep;     //终止点
}

@property (nonatomic)           NSInteger       brlcnt;         //公交换乘推荐线路数
@property (nonatomic, retain)   NSArray         *brls;          //推荐的每条路线
@property (nonatomic)           CNMKGeoPoint    sp;             //起始点
@property (nonatomic)           CNMKGeoPoint    ep;             //终止点

@end



///驾车路线方案查询：分段信息
@interface CNMKRoutingSegmt : NSObject {
@private
    NSInteger       dist;           //分段长度
    NSString        *name;          //道路名称
    NSString        *dir;           //行驶方向
    NSString        *action;        //导航动作
    NSInteger       clistcnt;       //坐标个数
    CNMKGeoPoint    *clist;         //坐标列
}

@property (nonatomic)       NSInteger       dist;           //分段长度
@property (nonatomic, copy) NSString        *name;          //道路名称
@property (nonatomic, copy) NSString        *dir;           //行驶方向
@property (nonatomic, copy) NSString        *action;        //导航动作
@property (nonatomic)       NSInteger       clistcnt;       //坐标个数
@property (nonatomic)       CNMKGeoPoint    *clist;         //坐标列

@end

///驾车路线方案查询结果
@interface CNMKRoutingResult : NSObject {
@private
    CNMKGeoPoint        sp;         //起点坐标
    CNMKGeoPoint        ep;         //终点坐标
    NSInteger           distsum;    //总里程
    NSInteger           segcnt;     //分段数目
    NSArray             *segmts;     //分段信息
}

@property (nonatomic)           CNMKGeoPoint        sp;         //起点坐标
@property (nonatomic)           CNMKGeoPoint        ep;         //终点坐标
@property (nonatomic)           NSInteger           distsum;    //总里程
@property (nonatomic)           NSInteger           segcnt;     //分段数目
@property (nonatomic, retain)   NSArray             *segmts;     //分段信息

@end
