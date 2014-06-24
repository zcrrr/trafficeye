//
//  TEAppDelegate.m
//  Trafficeye_new
//
//  Created by 张 驰 on 13-6-17.
//  Copyright (c) 2013年 张 驰. All rights reserved.
//

#import "TEMapViewController.h"
#import "TESigraViewController.h"
#import "TETrafficIndexViewController.h"
#import "TETaxiViewController.h"
#import "TETrafficWeiboViewController.h"
#import "TEUserViewController.h"
#import "TESettingViewController.h"
#import "TENewsViewController.h"
#import "sys/utsname.h"
#import "OpenUDID.h"
#import "TENetworkHandler.h"
#import "TEBadge.h"
#import "TEPersistenceHandler.h"
#import "TERewardViewController.h"
#import "CNMKManager.h"
#import "DDMenuController.h"
#import "MenuViewController.h"
#import "Toast+UIView.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import "TESetHomePageViewController.h"
#import "TEFirstAnimationViewController.h"
#import "TEUploadLocation.h"
#import "TESurveyViewController.h"
#import "TEMessageViewController.h"
#import "AlixPay.h"
#import "AlixPayResult.h"
#import "MobClick.h"
#import <AdSupport/AdSupport.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "SBJson.h"
#import "TEUserWebViewController.h"
#import "TEOrderCarViewController.h"
#import "CNQueryViewController.h"
#import "TEWebLevel1ViewController.h"

@implementation TEAppDelegate
@synthesize userAgent;
@synthesize pid;
@synthesize networkHandler;
@synthesize picPraser;
@synthesize badges;
@synthesize userInfoDictionary;
@synthesize hasBadges;
@synthesize navControllers;
@synthesize menuController;
@synthesize mapview_app;
@synthesize navigationController;
@synthesize uploadLocation;
@synthesize pushToken;
@synthesize needRegisterPush;
@synthesize appController;
@synthesize screenHeight;
@synthesize imageData;
NSString* bus_url;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [MobClick startWithAppkey:APPKEY reportPolicy:SEND_INTERVAL   channelId:nil];
    [MobClick setLogEnabled:YES];
    [MobClick updateOnlineConfig];//在线参数
    bus_url = [MobClick getConfigParams:@"bus_url"];
    NSLog(@"bus_url is %@",bus_url);
    if (bus_url == nil || ([NSNull null] == (NSNull *)bus_url)) {
        bus_url = @"http://211.151.84.15:13181";
    }
    NSLog(@"bus_url is %@",bus_url);
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    UIRemoteNotificationType types =
    (UIRemoteNotificationTypeBadge
     |UIRemoteNotificationTypeSound
     |UIRemoteNotificationTypeAlert);
    //注册消息推送
    [[UIApplication sharedApplication]registerForRemoteNotificationTypes:types];
    [ShareSDK registerApp:@"107e1f6d661a"];
    //添加新浪微博应用
    [ShareSDK connectSinaWeiboWithAppKey:@"2022960751"
                               appSecret:@"bfc3b33e66dea3e67a13d84cf6c4eed3"
                             redirectUri:@"http://sns.whalecloud.com/sina2/callback"];
    //添加腾讯微博应用
    [ShareSDK connectTencentWeiboWithAppKey:@"801327203"
                                  appSecret:@"2a3f6628d61734145b454a5435f1924d"
                                redirectUri:@"http://mobile.trafficeye.com.cn"];
    //qq空间
    [ShareSDK connectQZoneWithAppKey:@"100372961"
                           appSecret:@"c714416932fcef19fb16b7dd13366d03"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    //添加微信应用
    [ShareSDK connectWeChatWithAppId:@"wx5f53246df8e6fee0"
                           wechatCls:[WXApi class]];
    [ShareSDK ssoEnabled:YES];
    //判断如果程序是因为推送而启动
//    NSString* pushInfo = [NSString stringWithFormat:@"%@",[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]];
    if([launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]){
//        UIAlertView *alert =
//        [[UIAlertView alloc] initWithTitle:@"温馨提示"
//                                           message:pushInfo
//                                          delegate:nil
//                                 cancelButtonTitle:@"确定"
//                                 otherButtonTitles:nil];
//                [alert show];
        [self.window makeToast:[[[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey] objectForKey:@"aps"] objectForKey:@"alert"]];
    }
    
    //转向动画界面，在该界面，进行动画的同时会作一些工作。
    TEFirstAnimationViewController* firstVC = [[TEFirstAnimationViewController alloc]init];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:firstVC];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}
//动画界面执行完毕会执行
- (void)afterAnimation{
    if([[TEUtil cityNameByLocation:[TEUtil getUserLocationLon] :[TEUtil getUserLocationLat]] isEqualToString:@"beijing"]) {
        [self requestLimitNum];
    }
    [self addViewControllers];
    NSString* filePath = [TEPersistenceHandler getDocument:@"homePage.plist"];
    NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSString *homePageIndexStr = [dic valueForKey:@"homePageIndex"];
    if(homePageIndexStr == nil || [@"" isEqualToString:homePageIndexStr]){
        //没有设置过初始页面
        TESetHomePageViewController* sethomeVC = [[TESetHomePageViewController alloc]init];
        sethomeVC.FromSetting = NO;
        self.window.rootViewController = sethomeVC;
    }else{
        int pageNo = [homePageIndexStr intValue];
        NSLog(@"得到的pageno是%i",pageNo);
        [self setStartPage:pageNo];
    }
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"进入后台");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    [UIApplication sharedApplication].applicationIconBadgeNumber  =  0;
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark 自定义
- (void)setStartPage:(int)pageNO{
    int realPageNo = 2;
    switch (pageNO) {
        case 0:
            realPageNo = INDEX_PAGE_MAP;
            break;
        case 1:
            realPageNo = INDEX_PAGE_SIGRA;
            break;
        case 2:
            realPageNo = INDEX_PAGE_INDEX;
            break;
        case 3:
            realPageNo = INDEX_PAGE_WEIBO;
            break;
            
        default:
            break;
    }
    DDMenuController *rootController = [[DDMenuController alloc] initWithRootViewController:[self.navControllers objectAtIndex:realPageNo]];
    self.menuController = rootController;
    
    MenuViewController *leftController = [[MenuViewController alloc] init];
    rootController.leftViewController = leftController;
    self.window.rootViewController = rootController;
    extern int selectedIndex;
    selectedIndex = realPageNo;
    self.appController = [[MCMainApplicationDelegate alloc] init];
    [self.appController startup];
    //请求announcement
    [[TEAppDelegate getApplicationDelegate].networkHandler doRequest_announcement:0];
}
- (void)addViewControllers{
    TEMapViewController* mapVC = [[TEMapViewController alloc]init];
    UINavigationController* navigationController_map = [[UINavigationController alloc]initWithRootViewController:mapVC];

    TESigraViewController* sigraVC = [[TESigraViewController alloc]init];
    UINavigationController* navigationController_sigra = [[UINavigationController alloc]initWithRootViewController:sigraVC];
    
    TETrafficIndexViewController* trafficIndexVC = [[TETrafficIndexViewController alloc]init];
    UINavigationController* navigationController_index = [[UINavigationController alloc]initWithRootViewController:trafficIndexVC];
    
    TETaxiViewController* taxiVC = [[TETaxiViewController alloc]init];
    UINavigationController* navigationController_taxi = [[UINavigationController alloc]initWithRootViewController:taxiVC];
    
    
    
    TETrafficWeiboViewController* weiboVC = [[TETrafficWeiboViewController alloc]init];
    UINavigationController* navigationController_weibo = [[UINavigationController alloc]initWithRootViewController:weiboVC];
    
    
    TEUserWebViewController* userVC = [[TEUserWebViewController alloc]init];
    UINavigationController* navigationController_user = [[UINavigationController alloc]initWithRootViewController:userVC];
    
    TENewsViewController* newsVC = [[TENewsViewController alloc]init];
    UINavigationController* navigationController_news = [[UINavigationController alloc]initWithRootViewController:newsVC];
    
    TESettingViewController* settingVC = [[TESettingViewController alloc]init];
    UINavigationController* navigationController_setting = [[UINavigationController alloc]initWithRootViewController:settingVC];
    
    TESurveyViewController* surveyVC = [[TESurveyViewController alloc]init];
    UINavigationController* navigationController_survey = [[UINavigationController alloc]initWithRootViewController:surveyVC];
    
    TEMessageViewController* messageVC = [[TEMessageViewController alloc]init];
    UINavigationController* navigationController_message = [[UINavigationController alloc]initWithRootViewController:messageVC];
    
    TEOrderCarViewController*ordercarVC = [[TEOrderCarViewController alloc]init];
    UINavigationController* navigationController_order = [[UINavigationController alloc]initWithRootViewController:ordercarVC];
    
    CNQueryViewController* busQueryVC = [[CNQueryViewController alloc]init];
    UINavigationController* navigationController_bus = [[UINavigationController alloc]initWithRootViewController:busQueryVC];
    
    TEWebLevel1ViewController* sharecarVC = [[TEWebLevel1ViewController alloc]init];
    sharecarVC.entryHTML = @"pcar_index";
    UINavigationController* navigationController_sharecar = [[UINavigationController alloc]initWithRootViewController:sharecarVC];
    
    self.navControllers = [[NSMutableArray alloc]initWithObjects:navigationController_map,navigationController_sigra,navigationController_index,navigationController_taxi,navigationController_bus,navigationController_sharecar,navigationController_survey,navigationController_news,navigationController_weibo,navigationController_setting,navigationController_message,navigationController_user,navigationController_order,nil];
}
- (void)initVar{
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    self.screenHeight = size.height;
    NSLog(@"screenHeight is %f",self.screenHeight);
    self.userAgent = [NSString stringWithFormat:@"I_%@,i_%@",[[UIDevice currentDevice] systemVersion],CLIENT_VERSION];
    self.pid = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSLog(@"useragent is %@,pid is %@",self.userAgent,self.pid);
    self.networkHandler = [[TENetworkHandler alloc]init];
    [self.networkHandler startQueue];//开启队列
    self.picPraser = [[TEPicPraser alloc]init];
    [self.picPraser praseCityXML];
    self.uploadLocation = [[TEUploadLocation alloc]init];
    
    
    
    CNMKManager *manager = [[CNMKManager alloc] init];
    [manager start:@"Basic Y2VubmF2aVRlc3Q6Y2VubmF2aVRlc3Q="];
    self.mapview_app = [[CNMKMapView alloc]init];
    [self.mapview_app setShowsUserLocation:YES];
    
    //初始化badge,key就是badge的id
    self.badges = [[NSMutableDictionary alloc]init];
    [self.badges setObject:[[TEBadge alloc]initWithData:@"身份徽章" :@"注册账号" :@"badge_register"] forKey:@"1"];
    [self.badges setObject:[[TEBadge alloc]initWithData:@"荣誉公民" :@"个人资料完整度100%" :@"badge_register_complete"] forKey:@"2"];
    [self.badges setObject:[[TEBadge alloc]initWithData:@"积极分子" :@"连续七日登录" :@"badge_login_7days"] forKey:@"3"];
    [self.badges setObject:[[TEBadge alloc]initWithData:@"一鸣惊人" :@"第一次分享微博" :@"badge_weibo_first"] forKey:@"4"];
    [self.badges setObject:[[TEBadge alloc]initWithData:@"友情岁月" :@"微博分享时@好友" :@"badge_unknown"] forKey:@"5"];
    [self.badges setObject:[[TEBadge alloc]initWithData:@"微博潮人" :@"新浪与腾讯微博各分享一次" :@"badge_weibo_sina_qq"] forKey:@"6"];
    [self.badges setObject:[[TEBadge alloc]initWithData:@"新手上路" :@"累计行驶3km" :@"badge_milage_3km"] forKey:@"7"];
    [self.badges setObject:[[TEBadge alloc]initWithData:@"公路骑士" :@"累计行驶100km" :@"badge_milage_100km"] forKey:@"8"];
    [self.badges setObject:[[TEBadge alloc]initWithData:@"公路侠" :@"累计行驶500km" :@"badge_milage_500km"] forKey:@"9"];
    [self.badges setObject:[[TEBadge alloc]initWithData:@"路况台" :@"连续三天分享微博" :@"badge_unknown"] forKey:@"10"];
    [self.badges setObject:[[TEBadge alloc]initWithData:@"急速先锋" :@"平均时速50公里以上" :@"badge_unknown"] forKey:@"11"];
    [self.badges setObject:[[TEBadge alloc]initWithData:@"黄金甲" :@"验证邮箱" :@"badge_unknown"] forKey:@"12"];
    [self.badges setObject:[[TEBadge alloc]initWithData:@"狂人分子" :@"连续21日登录" :@"badge_login_21days"] forKey:@"13"];
    [self.badges setObject:[[TEBadge alloc]initWithData:@"轻车熟路" :@"累计行驶50km" :@"badge_milage_50km"] forKey:@"14"];
    [self.badges setObject:[[TEBadge alloc]initWithData:@"超级骑士" :@"累计行驶1000km" :@"badge_milage_1000km"] forKey:@"15"];
    [self.badges setObject:[[TEBadge alloc]initWithData:@"超能侠" :@"累计行驶10000km" :@"badge_milage_10000km"] forKey:@"16"];
    [self.badges setObject:[[TEBadge alloc]initWithData:@"上报1事件" :@"首次上报交通事件" :@"badge_event_1"] forKey:@"17"];
    [self.badges setObject:[[TEBadge alloc]initWithData:@"上报200事件" :@"上报200件交通事件" :@"badge_event_200"] forKey:@"18"];
    [self.badges setObject:[[TEBadge alloc]initWithData:@"上报100事件" :@"上报100件交通事件" :@"badge_event_100"] forKey:@"19"];
    [self.badges setObject:[[TEBadge alloc]initWithData:@"上报50事件" :@"上报50件交通事件" :@"badge_event_50"] forKey:@"20"];
    [self.badges setObject:[[TEBadge alloc]initWithData:@"上报20事件" :@"上报20件交通事件" :@"badge_event_20"] forKey:@"21"];
    [self.badges setObject:[[TEBadge alloc]initWithData:@"上报10事件" :@"上报10件交通事件" :@"badge_event_10"] forKey:@"22"];
    [self.badges setObject:[[TEBadge alloc]initWithData:@"上报5事件" :@"上报5件交通事件" :@"badge_event_5"] forKey:@"23"];
    [self.badges setObject:[[TEBadge alloc]initWithData:@"贡献5000km" :@"路况贡献5000km" :@"badge_track_5000km"] forKey:@"24"];
    [self.badges setObject:[[TEBadge alloc]initWithData:@"贡献1000km" :@"路况贡献1000km" :@"badge_track_1000km"] forKey:@"25"];
    [self.badges setObject:[[TEBadge alloc]initWithData:@"贡献500km" :@"路况贡献500km" :@"badge_track_500km"] forKey:@"26"];
    [self.badges setObject:[[TEBadge alloc]initWithData:@"贡献100km" :@"路况贡献100km" :@"badge_track_100km"] forKey:@"27"];
    [self.badges setObject:[[TEBadge alloc]initWithData:@"贡献50km" :@"路况贡献50km" :@"badge_track_50km"] forKey:@"28"];
    [self.badges setObject:[[TEBadge alloc]initWithData:@"贡献10km" :@"路况贡献10km" :@"badge_track_10km"] forKey:@"29"];
    [self.badges setObject:[[TEBadge alloc]initWithData:@"贡献3km" :@"路况贡献3km" :@"badge_track_3km"] forKey:@"30"];
    [self.badges setObject:[[TEBadge alloc]initWithData:@"行驶10km" :@"累计行驶10km" :@"badge_milage_10km"] forKey:@"31"];
    [self.badges setObject:[[TEBadge alloc]initWithData:@"行驶5000km" :@"累计行驶5000km" :@"badge_milage_5000km"] forKey:@"32"];
    self.hasBadges = [[NSMutableArray alloc]init];
    //开启定位，用于上报用户位置
    [self.uploadLocation startUploadLocation];
    //上传用户记录
    NSString* filePath = [TEPersistenceHandler getDocument:@"uerLog.plist"];
    NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    if(dic){
        NSString *stringToUpload = [dic valueForKey:@"userLog"];
        [self.networkHandler doRequest_uploadRecord:stringToUpload];
    }
    
}
- (NSString*)deviceString
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    return @"unknown";
}
- (void)requestLimitNum{
    [TEAppDelegate getApplicationDelegate].networkHandler.delegate_limitNum = self;
    [[TEAppDelegate getApplicationDelegate].networkHandler doRequest_limitNum];
}
//刚进入程序尝试登陆
- (void)tryLogin{
    NSString* filePath = [TEPersistenceHandler getDocument:@"userLogin.plist"];
    NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    if(dic){
        NSString* needLogin = [dic objectForKey:@"needLogin"];
        if(needLogin){
            if([needLogin isEqualToString:@"0"]){
                //不需要登陆
            }else if([needLogin isEqualToString:@"1"]){
                NSString* email = [dic objectForKey:@"email"];
                NSString* passwd = [dic objectForKey:@"passwd"];
                if(email&&passwd){//账号和密码都存在，调用手动登录
                    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
                    [params setValue:email forKey:@"email"];
                    [params setValue:passwd forKey:@"passwd"];
                    [TEAppDelegate getApplicationDelegate].networkHandler.delegate_login = self;
                    [[TEAppDelegate getApplicationDelegate].networkHandler doRequest_login:params];
                    self.isLogin = 2;//表示正在登录
                }else{
                    //调用自动登陆
                    [self doAutoLogin];
                }
            }
        }
    }else {
        //自动登陆接口
        [self doAutoLogin];
    }
}
- (void)doAutoLogin{
    [TEAppDelegate getApplicationDelegate].networkHandler.delegate_autoLogin = self;
    [[TEAppDelegate getApplicationDelegate].networkHandler doRequest_autoLogin];
    self.isLogin = 2;
}
+ (TEAppDelegate*)getApplicationDelegate{
    return (TEAppDelegate*)[[UIApplication sharedApplication] delegate];
}
- (NSString*)getUid{
    if(self.isLogin == 1&&self.userInfoDictionary){
        NSString* uid = [NSString stringWithFormat:@"%@",[self.userInfoDictionary objectForKey:@"uid"]];
        return uid;
    }else{
        return @"0";
    }
}
#pragma mark -loginDelegate
- (void)loginDidSuccess:rewardDic{
    NSLog(@"loginDidSuccess");
    self.isLogin = 1;
    [[TEAppDelegate getApplicationDelegate].networkHandler doRequest_announcement:1];
    //通知用户界面转到个人信息界面
    NSString* NOTIFICATION_AUTOLOGIN_DONE = @"notification_autologin_done";
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_AUTOLOGIN_DONE object:nil];
    NSLog(@"zc_notification");
}
- (void)loginDidFailed:(NSString*)mes{
    NSLog(@"loginDidFailed:%@",mes);
    self.isLogin = 0;
    UIAlertView* alert =[[UIAlertView alloc] initWithTitle:nil message:mes delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    NSString* NOTIFICATION_TURNTO_USERINFO = @"notification_turnto_userinfo";
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TURNTO_USERINFO object:nil];
}
#pragma mark -limit num Delegate
- (void)limitNumDidSuccess:(NSString *)limitStr{
    [self.window makeToast:[NSString stringWithFormat:@"今日限行:%@",limitStr]];
}
- (void)limitNumDidFailed:(NSString *)mes{
    
}

#pragma mark -autoLoginDelegate
- (void)autoLoginDidSuccess:rewardDic{
    NSLog(@"autoLoginDidSuccess");
    self.isLogin = 1;
    [[TEAppDelegate getApplicationDelegate].networkHandler doRequest_announcement:1];
    //通知用户界面转到个人信息界面
    NSString* NOTIFICATION_AUTOLOGIN_DONE = @"notification_autologin_done";
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_AUTOLOGIN_DONE object:nil];
    //通知左边菜单界面，更新用户头像和用户名
    NSString* NOTIFICATION_SETUSERINFO = @"NOTIFICATION_SETUSERINFO";
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SETUSERINFO object:nil];
}
- (void)autoLoginDidFailed:(NSString*)mes{
    NSLog(@"autoLoginDidFailed:%@",mes);
    self.isLogin = 0;
//    UIAlertView* alert =[[UIAlertView alloc] initWithTitle:@"登录失败" message:mes delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [alert show];
    NSString* NOTIFICATION_TURNTO_USERINFO = @"notification_turnto_userinfo";
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TURNTO_USERINFO object:nil];
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    [self.appController mcMainHandleOpenURL:url];
    return [ShareSDK handleOpenURL:url wxDelegate:nil];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSString *urlString = [url relativeString];
    NSLog(@"urlstring2 is %@",urlString);
    if([urlString hasPrefix:@"trafficeye"]){
        [self parseURL:url application:application];
        return YES;
    }else{
        return [ShareSDK handleOpenURL:url
                     sourceApplication:sourceApplication
                            annotation:annotation
                            wxDelegate:nil];
    }
    
}
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"DeviceToken: {%@}",deviceToken);
    NSString* filePath = [TEPersistenceHandler getDocument:@"pushInit.plist"];
    NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    if(!dic){
        NSString *token = [NSString stringWithFormat:@"%@",deviceToken];
        NSString *token1 = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *token2 = [token1 stringByReplacingOccurrencesOfString:@"<" withString:@""];
        NSString *token3 = [token2 stringByReplacingOccurrencesOfString:@">" withString:@""];
        self.pushToken = token3;
        self.needRegisterPush = YES;
    }else{
        NSString* registered_pid = [dic objectForKey:@"pid"];
        if(![registered_pid isEqualToString:self.pid]){
            NSString *token = [NSString stringWithFormat:@"%@",deviceToken];
            NSString *token1 = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSString *token2 = [token1 stringByReplacingOccurrencesOfString:@"<" withString:@""];
            NSString *token3 = [token2 stringByReplacingOccurrencesOfString:@">" withString:@""];
            self.pushToken = token3;
            self.needRegisterPush = YES;
        }
    }
}
//注册消息推送失败
- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Register Remote Notifications error:{%@}",[error localizedDescription]);
}
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"Receive remote notification : %@",userInfo);
    [self.window makeToast:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]];
}
- (void)parseURL:(NSURL *)url application:(UIApplication *)application {
    NSLog(@"parseURL");
	AlixPay *alixpay = [AlixPay shared];
	AlixPayResult *result = [alixpay handleOpenURL:url];
	if (result) {
		//是否支付成功
		if (9000 == result.statusCode) {
            NSLog(@"pay success");
            NSString* NOTIFICATION_GO_RESULT = @"GORESULT";
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GO_RESULT object:nil];
		}
		//如果支付失败,可以通过result.statusCode查询错误码
		else {
            NSLog(@"pay faild");
			UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
																 message:@"支付失败"
																delegate:nil
													   cancelButtonTitle:@"确定"
													   otherButtonTitles:nil];
			[alertView show];
		}
		
	}
}
+ (NSString*)getUserInfoJSON{
    NSString* userInfoJSON = @"";
    if([TEAppDelegate getApplicationDelegate].isLogin == 1){
        SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
        userInfoJSON = [jsonWriter stringWithObject:[TEAppDelegate getApplicationDelegate].userInfoDictionary];
    }
    return userInfoJSON;
}
@end
