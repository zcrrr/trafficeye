//
//  TEAppDelegate.h
//  Trafficeye_new
//
//  Created by 张 驰 on 13-6-17.
//  Copyright (c) 2013年 张 驰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TENetworkHandler.h"
#import "TEBadge.h"
#import "DDMenuController.h"
#import "CNMKMapView.h"
#import "TEPicPraser.h"
#import "TEUploadLocation.h"
#import "MCMainApplicationDelegate.h"

@interface TEAppDelegate : UIResponder <UIApplicationDelegate,loginDelegate,autoLoginDelegate,limitNumDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSMutableArray* navControllers;
@property (strong, nonatomic) DDMenuController *menuController;
@property (strong, nonatomic) UINavigationController *navigationController;
//单例的一些管理类
@property (nonatomic, strong) TENetworkHandler* networkHandler;
@property (nonatomic, strong) TEPicPraser* picPraser;//xml解析类
@property (nonatomic, strong) TEUploadLocation* uploadLocation;
//定义一些全局使用的变量
@property (nonatomic, strong) NSString* userAgent;
@property (nonatomic, strong) NSString* pid;
@property (nonatomic, strong) NSMutableDictionary* badges;
@property (nonatomic, assign) int isLogin;//整个应用过程中登陆的状态，0-未登录 1-成功登陆 2-正在登陆
@property (nonatomic, strong) NSMutableDictionary* userInfoDictionary;
@property (nonatomic, strong) NSData* imageData;//保存用户头像
@property (nonatomic, strong) NSMutableArray* hasBadges;
@property (strong, nonatomic) CNMKMapView* mapview_app;
@property (strong, nonatomic) NSString* pushToken;
@property (assign, nonatomic) BOOL needRegisterPush;
@property (strong, nonatomic) MCMainApplicationDelegate *appController;
@property (assign, nonatomic) float screenHeight;



- (NSString*)getUid;
+ (TEAppDelegate*)getApplicationDelegate;
+ (NSString*)getUserInfoJSON;
- (void)setStartPage:(int)pageNO;
- (void)afterAnimation;
- (void)initVar;
- (void)tryLogin;



@end
