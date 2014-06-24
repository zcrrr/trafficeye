//
//  CenNaviFeatureController.h
//
//  Created by Don Hao on 1/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MCDefaultFeatureController.h"
#import <AVFoundation/AVFoundation.h>
#import "CenNaviHmiProvider.h"
#import "MainStateView.h"
#import "AreaListStateView.h"
#import "AreaStateView.h"
#import "ASIHTTPRequest.h"
#import "CenNaviCache.h"
#import <CoreLocation/CoreLocation.h>

@interface CenNaviFeatureController : MCDefaultFeatureController <IDTableDelegate,CLLocationManagerDelegate>
{
    BOOL _playImmediately;
}

@property (nonatomic, retain) CenNaviHmiProvider* hmiProvider;
@property (nonatomic, retain) MainStateView* mainStateView;
@property (nonatomic, retain) AreaListStateView* areaListStateView;
@property (nonatomic, retain) AreaStateView* areaStateView;
@property (nonatomic, retain) IDApplication *application;
@property (nonatomic, assign) IDVehicleBrand brand;
@property (nonatomic, assign) IDVehicleHmiType rhmiType;
@property (nonatomic, assign) BOOL enableSound;
@property (nonatomic, assign) float gpsLatitude;
@property (nonatomic, assign) float gpsLongitude;
@property (nonatomic, assign) float gpsLatitudeFromMobile;
@property (nonatomic, assign) float gpsLongitudeFromMobile;
@property (nonatomic, assign) int speed;
@property (nonatomic, assign) int speedFromIphone;
@property (nonatomic, assign) int speedFromDir;
@property (nonatomic, assign) int direction;

@property (nonatomic, retain) AVAudioPlayer* avAudioPlayer;
@property (nonatomic, assign) BOOL isForward;
@property (nonatomic, assign) float carHeading;
@property (nonatomic, assign) int selectedAreaIndex;
@property (nonatomic, assign) int currentMapType;

@property (strong, nonatomic) ASIHTTPRequest* requestMainCity;
@property (strong, nonatomic) ASIHTTPRequest* requestAheadMap;
@property (strong, nonatomic) ASIHTTPRequest* requestAreaMap;
@property (strong, nonatomic) ASIHTTPRequest* requestRouteList;
@property (strong, nonatomic) ASIHTTPRequest* requestSound;
@property (strong, nonatomic) CenNaviCache* cennaviCache;
@property (strong, nonatomic) NSMutableArray* routeList;
@property (strong, nonatomic) NSTimer* timerCityMap;
@property (strong, nonatomic) NSTimer* timerAheadMap;
@property (strong, nonatomic) NSTimer* timerAreaMap;
@property (strong, nonatomic) TrafficMap* oneCityMap;//存储一个临时的citymap数据
@property (strong, nonatomic) TrafficMap* oneAheadMap;//存储一个临时的aheadmap数据
@property (strong, nonatomic) TrafficMap* oneAreaMap;//存储一个临时的areaMap数据
@property (strong, nonatomic) NSString *cityName;//城市
@property (nonatomic, assign) int indexBeforeArea;//记录点击商圈按钮之前是在citymap还是在aheadmap
@property (nonatomic, assign) float latWhenRequest;
@property (nonatomic, assign) float lonWhenRequest;

//GPS
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *userLocation;

//记录最后一次请求成功的图片，用于请求失败时使用
@property (strong, nonatomic) UIImage *cityOverviewImage;
@property (nonatomic) long lastOverViewTime;
@property (strong, nonatomic) UIImage *aheadMapImage;
@property (nonatomic) long lastAheadTime;
@property (strong, nonatomic) NSMutableDictionary *areaImageDic;
@property (strong, nonatomic) NSMutableDictionary *lastAreaTimeDic;
@property (nonatomic) int language;
@property (strong, nonatomic) NSString *timestampAhead;
@property (strong, nonatomic) NSString *graphic_idAhead;
@property (assign, nonatomic) float ahead_loc_x;
@property (assign, nonatomic) float ahead_loc_y;
@property (assign, nonatomic) BOOL isRequestAhead;


//新的前方图请求
@property(strong, nonatomic) NSTimer* timerAhead;

- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees :(UIImage*)oldImage;
- (CGImageRef)CGImageRotatedByAngle:(CGImageRef)imgRef angle:(CGFloat)angle;
@end
