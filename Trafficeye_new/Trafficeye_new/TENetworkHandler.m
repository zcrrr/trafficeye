//
//  TENetworkHandler.m
//  NetworkDemo
//
//  Created by 张 驰 on 13-7-24.
//  Copyright (c) 2013年 张 驰. All rights reserved.
//  所有的请求都通过这个类处理，包括发起请求，接受数据，解析数据，解析好的数据通过dic或者array回传，原理通过自定义的delegate
//

#import "TENetworkHandler.h"
#import "ASIHTTPRequest.h"
#import "SBJson.h"
#import "TEPersistenceHandler.h"
#import "TERewardViewController.h"
#import "ASIDataCompressor.h"
#import "TEUserLevelHandler.h"

@implementation TENetworkHandler
@synthesize networkQueue;
@synthesize delegate_login;
@synthesize delegate_register;
@synthesize delegate_autoLogin;
@synthesize delegate_userAvatarUpload;
@synthesize delegate_userUpdateUserInfo;
@synthesize delegate_userPointsDetail;
@synthesize delegate_userdistanceDetail;
@synthesize delegate_userEventDetail;
@synthesize delegate_userForgetPassword;
@synthesize delegate_userEditPassword;
@synthesize delegate_reportEvent;
@synthesize delegate_getTrack;
@synthesize delegate_getEvent;
@synthesize delegate_eventDetail;
@synthesize delegate_option;
@synthesize delegate_taxiIndex;
@synthesize delegate_taxiEasy;
@synthesize delegate_taxiLongPress;
@synthesize delegate_snsLogin;
@synthesize delegate_uploadUserSetting;
@synthesize delegate_limitNum;
@synthesize delegate_snsShare;
@synthesize delegate_downloadUserSetting;
@synthesize delegate_uploadLocation;
@synthesize delegate_registerPush;
@synthesize delegate_pushSetting;
@synthesize delegate_lookupFriends;
@synthesize delegate_bingding;
@synthesize delegate_invitation;
@synthesize delegate_messageCount;
@synthesize delegate_uploadRecord;
@synthesize delegate_logout;
@synthesize delegate_newShareSNS;
@synthesize delegate_ordercar;
@synthesize delegate_announcement;
@synthesize delegate_checkUser;
@synthesize delegate_findPoi;
@synthesize delegate_routeDrive;
@synthesize delegate_routeWalk;

@synthesize loginRequest;
@synthesize registerRequest;
@synthesize autoLoginRequest;
@synthesize userAvatarUploadRequest;
@synthesize userUpdateUserInfoRequest;
@synthesize userPointsDetailRequest;
@synthesize userDistanceDetailRequest;
@synthesize userEventDetailRequest;
@synthesize userForgetPasswordRequest;
@synthesize userEditPasswordRequest;
@synthesize reportEventRequest;
@synthesize getTrackRequest;
@synthesize getEventRequest;
@synthesize eventDetailRequest;
@synthesize optionRequest;
@synthesize taxiIndexRequest;
@synthesize taxiEasyRequest;
@synthesize taxiLongPressRequest;
@synthesize snsLoginRequest;
@synthesize uploadUserSettingRequest;
@synthesize limitNumRequest;
@synthesize snsShareRequest;
@synthesize downloadUserSettingRequest;
@synthesize uploadLocationRequest;
@synthesize registerPushRequest;
@synthesize pushSettingRequest;
@synthesize lookupFriendsRequest;
@synthesize bindingRequest;
@synthesize invitationRequest;
@synthesize messageCountRequest;
@synthesize uploadRecordRequest;
@synthesize logoutRequest;
@synthesize ShareSNSNewRequest;
@synthesize ordercarRequest;
@synthesize announcementRequest;
@synthesize checkUserRequest;
@synthesize findPoiRequest;
@synthesize routeDriveRequest;
@synthesize routeWalkRequest;
@synthesize myRewardDic;


@synthesize target;
//@synthesize handler;

//-----------公交--------------
@synthesize delegate_oneLineDetail;
@synthesize delegate_oneLineInfo;
@synthesize delegate_smartTip;

@synthesize oneLineDetailRequest;
@synthesize oneLineInfoRequest;
@synthesize smartTipRequest;


- (void)startQueue{
    //    self.handler = self;//持有自己的引用，这样就不会被释放,在delegate里面有了强引用，这里可以注释了
    [self setNetworkQueue:[ASINetworkQueue queue]];
    [[self networkQueue] setDelegate:self];
    [[self networkQueue] setRequestDidFinishSelector:@selector(requestFinishedByQueue:)];
    [[self networkQueue] setRequestDidFailSelector:@selector(requestFailedByQueue:)];
    [[self networkQueue] setQueueDidFinishSelector:@selector(queueFinished:)];
    [[self networkQueue] setShouldCancelAllRequestsOnFailure:NO ];//取消一个请求不会取消队列中的所有请求
    [self networkQueue].maxConcurrentOperationCount = 3;//同时最多进行3个请求
    [[self networkQueue] go];
}
- (void)popupRewardWindow{
    TERewardViewController* rewardVC = [[TERewardViewController alloc]init];
    rewardVC.reward_dic = self.myRewardDic;
    rewardVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    UIViewController* rootViewController =  [[UIApplication sharedApplication] keyWindow].rootViewController;
    rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
    [rootViewController presentViewController:rewardVC animated:YES completion:^(void){NSLog(@"rewardvc");}];
}
#pragma mark -NetworkQueue
- (void)requestFinishedByQueue:(ASIHTTPRequest *)request{
    NSLog(@"requestfinishedbyqueue");
    NSString *responseString = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    NSLog(@"---服务器返回结果是%@",responseString);
//    responseString = @"{\"state\":{\"code\":\"0\",\"desc\":\"用户注册成功,客户端与用户绑定成功！\",\"extra\":29358},\"reward\":{\"badge\":[{\"id\":1,\"name\":\"新人徽章\"}],\"points\":[{\"point\":10,\"title\":\"注册账号\"},{\"point\":1,\"title\":\"每日登录奖励\"}],\"total_points\":11,\"total_miles\":0,\"total_goldCoins\":0,\"total_trackMiles\":0,\"badge_num\":1,\"event_num\":0}}";
    
    //解析结果返回信息
    SBJsonParser *jsonParser = [[SBJsonParser alloc]init];
    id result = [jsonParser objectWithString:responseString];
    //如果有userInfo,则更新userInfo
    NSMutableDictionary* userInfoDic = [result objectForKey:@"userInfo"];
    if(userInfoDic&&[[userInfoDic allKeys]count]>0){
        [TEAppDelegate getApplicationDelegate].userInfoDictionary = userInfoDic;
    }
    //如果有奖励，弹框
    NSMutableDictionary* rewardDic = [result objectForKey:@"reward"];
    int keycount = [[rewardDic allKeys] count];
    if(rewardDic&&keycount>0&&request.tag != TAG_NEW_SHARE_SNS){
        self.myRewardDic = rewardDic;
        //查看是否升级：
        int isupgrade = [[rewardDic objectForKey:@"isUpgrade"]intValue];
        if(isupgrade == 1){
            int level = [[[TEAppDelegate getApplicationDelegate].userInfoDictionary objectForKey:@"level"] intValue];
            [self.myRewardDic setObject:[NSString stringWithFormat:@"%i",level] forKey:@"level"];
        }
        [self performSelector:@selector(popupRewardWindow) withObject:nil afterDelay:0.5];
    }
    
    switch (request.tag) {
        case TAG_LOGIN_WITH_ACOUNT_PASSWORD:
        {
            NSDictionary* stateDic = [result objectForKey:@"state"];
            
            int code = [[stateDic objectForKey:@"code"] intValue];
            if(code == 0){
                [self.delegate_login loginDidSuccess:rewardDic];
            }else{//登录失败，返回错误描述
                NSString* failedDes = [stateDic objectForKey:@"desc"];
                [self.delegate_login loginDidFailed:failedDes];
            }
            break;
        }
        case TAG_REGISTER:
        {
            NSDictionary* stateDic = [result objectForKey:@"state"];
            NSString* code = [stateDic objectForKey:@"code"];
            if([code isEqualToString:@"0"]){
                [self.delegate_register registerDidSuccess:rewardDic];
            }else{//登录失败，返回错误描述
                NSString* failedDes = [stateDic objectForKey:@"desc"];
                [self.delegate_register registerDidFailed:failedDes];
            }
            break;
        }
        case TAG_AUTOLOGIN:
        {
            NSDictionary* stateDic = [result objectForKey:@"state"];
           int code = [[stateDic objectForKey:@"code"] intValue];
            if(code == 0){
                [self.delegate_autoLogin autoLoginDidSuccess:rewardDic];
            }else{
                NSString* failedDes = [stateDic objectForKey:@"desc"];
                [self.delegate_autoLogin autoLoginDidFailed:failedDes];
            }
            break;
        }
        case TAG_USER_UPLOAD_AVATAR:
        {
            NSDictionary* stateDic = [result objectForKey:@"state"];
            int code = [[stateDic objectForKey:@"code"] intValue];
            if(code == 0){
                [self.delegate_userAvatarUpload userAvatarUploadDidSuccess:rewardDic];
            }else{
                NSString* failedDes = [stateDic objectForKey:@"desc"];
                [self.delegate_userAvatarUpload userAvatarUploadDidFailed:failedDes];
            }
            break;
        }
        case TAG_USER_UPDATE_USERINFO:
        {
            NSDictionary* stateDic = [result objectForKey:@"state"];
            NSString* code = [stateDic objectForKey:@"code"];
            if([code isEqualToString:@"0"]){
                [self.delegate_userUpdateUserInfo userUpdateUserInfoDidSuccess:rewardDic];
            }else{
                NSString* failedDes = [stateDic objectForKey:@"desc"];
                [self.delegate_userUpdateUserInfo userUpdateUserInfoDidFailed:failedDes];
            }
            break;
        }
        case TAG_USER_POINTS_DETAIL:
        {
            NSArray *arrayList = [result objectForKey:@"pointList"];
            NSString *num = [result objectForKey:@"totleNum"];
            NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
            [dic setObject:arrayList forKey:@"array"];
            [dic setObject:num forKey:@"totleNum"];
            [self.delegate_userPointsDetail userPointsDetailDidSuccess:dic];
            break;
        }
        case TAG_USER_DISTANCE_DETAIL:
        {
            NSArray *arrayList = [result objectForKey:@"pointList"];
            NSString *num = [result objectForKey:@"totleNum"];
            NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
            [dic setObject:arrayList forKey:@"array"];
            [dic setObject:num forKey:@"totleNum"];
            [self.delegate_userdistanceDetail userDistanceDetailDidSuccess:dic];
            break;
        }
        case TAG_USER_EVENT_DETAIL:
        {
            NSArray *arrayList = [result objectForKey:@"pointList"];
            NSString *num = [result objectForKey:@"totleNum"];
            NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
            [dic setObject:arrayList forKey:@"array"];
            [dic setObject:num forKey:@"totleNum"];
            [self.delegate_userEventDetail userEventDetailDidSuccess:dic];
            break;
        }
        case TAG_USER_EDIT_PASSWORD:
        {
            NSDictionary* stateDic = [result objectForKey:@"state"];            
            NSString* code = [stateDic objectForKey:@"code"];
            if([code isEqualToString:@"0"]){
                [self.delegate_userEditPassword userEditPasswordDidSuccess:nil];
            }else{
                NSString* failedDes = [stateDic objectForKey:@"desc"];
                [self.delegate_userEditPassword userEditPasswordDidFailed:failedDes];
            }
            break;
        }
        case TAG_USER_FORGET_PASSWORD:
        {
            NSString* code = [result objectForKey:@"code"];
            if([code isEqualToString:@"0"]){
                [self.delegate_userForgetPassword userForgetPasswordDidSuccess:nil];
            }else{
                NSString* failedDes = [result objectForKey:@"desc"];
                [self.delegate_userForgetPassword userForgetPasswordDidFailed:failedDes];
            }
            break;
        }
        case TAG_REPORT_EVENT:
        {
            NSDictionary* stateDic = [result objectForKey:@"state"];
            
            int code = [[stateDic objectForKey:@"code"] intValue];
            if(code == 0){
                [self.delegate_reportEvent reportEventDidSuccess:rewardDic];
            }else{
                NSString* failedDes = [stateDic objectForKey:@"desc"];
                [self.delegate_reportEvent reportEventDidFailed:failedDes];
            }
            break;
        }
        case TAG_GET_TRACK:
        {
            NSDictionary* stateDic = [result objectForKey:@"state"];
            NSArray* trackList = [result objectForKey:@"tracks"];
            NSString* code = [stateDic objectForKey:@"code"];
            if([code isEqualToString:@"0"]){
                [self.delegate_getTrack getTrackDidSuccess:trackList];
            }else{
                NSString* failedDes = [stateDic objectForKey:@"desc"];
                [self.delegate_getTrack getTrackDidFailed:failedDes];
            }
            break;
        }
        case TAG_GET_EVENT:
        {
            NSDictionary* stateDic = [result objectForKey:@"state"];
            NSArray* eventList = [result objectForKey:@"events"];
            NSString* code = [stateDic objectForKey:@"code"];
            if([code isEqualToString:@"0"]){
                [self.delegate_getEvent getEventDidSuccess:eventList];
            }else{
                NSString* failedDes = [stateDic objectForKey:@"desc"];
                [self.delegate_getEvent getEventDidFailed:failedDes];
            }
            break;
        }
        case TAG_EVENT_DETAIL:
        {
            [self.delegate_eventDetail eventDetailDidSuccess:result];
            break;
        }
        case TAG_OPTION:
        {
            NSDictionary* stateDic = [result objectForKey:@"state"];            
            NSString* code = [stateDic objectForKey:@"code"];
            if([code isEqualToString:@"0"]){
                [self.delegate_option optionDidSuccess:rewardDic];
            }else{
                NSString* failedDes = [stateDic objectForKey:@"desc"];
                [self.delegate_option optionDidFailed:failedDes];
            }
            break;
        }
        case TAG_TAXI_INDEX:
        {
            [self.delegate_taxiIndex taxiIndexDidSuccess:result];
            break;
        }
        case TAG_TAXI_EASY:
        {
            [self.delegate_taxiEasy taxiEasyDidSuccess:result];
            break;
        }
        case TAG_TAXI_LONG_PRESS:
        {
            [self.delegate_taxiLongPress taxiLongPressDidSuccess:result];
            break;
        }
        case TAG_SNS_LOGIN:
        {
            [self.delegate_snsLogin snsLoginDidSuccess:result];
            break;
        }
        case TAG_UPLOAD_SETTING:
        {
            [self.delegate_uploadUserSetting uploadUserSettingDidSuccess:result];
            break;
        }
        case TAG_LIMITNUM:
        {
            [self.delegate_limitNum limitNumDidSuccess:responseString];
            break;
        }
        case TAG_SNS_SHARE:
        {
            break;
        }
        case TAG_DOWNLOAD_SETTING:
        {
            NSArray* arrayTemp = [result objectForKey:@"setting"];
            if([arrayTemp count] > 0){
                for(int i = 0;i<[arrayTemp count];i++){
                    NSDictionary* dicTemp = [arrayTemp objectAtIndex:i];
                    NSString* type = [dicTemp objectForKey:@"type"];
                    if([type isEqualToString:@"transform"]){
                        NSString* routes = [dicTemp objectForKey:@"favroads"];
                        NSArray* routesArray = [jsonParser objectWithString:routes];
                        NSString* filePath = [TEPersistenceHandler getDocument:@"favPic.plist"];
                        [routesArray writeToFile:filePath atomically:YES];
                    }else if([type isEqualToString:@"firstPage"]){
                        NSString* firstPage = [dicTemp objectForKey:@"favroads"];
                        if([firstPage isEqualToString:@"5"]){
                            firstPage = @"3";
                        }else if([firstPage isEqualToString:@"7"]){
                            firstPage = @"2";
                        }
                        NSLog(@"firstPage is %@",firstPage);
                        NSMutableDictionary* dic = [[NSMutableDictionary alloc ]init];
                        
                        [dic setValue:firstPage forKey:@"homePageIndex"];
                        //TODO：需要持久化
                        NSString* filePath = [TEPersistenceHandler getDocument:@"homePage.plist"];
                        [dic writeToFile:filePath atomically:YES];
                        
                    }
                    else if([type isEqualToString:@"infoCity"]){
                        NSString* newsCity = [dicTemp objectForKey:@"favroads"];
                        NSLog(@"newsCity is %@",newsCity);
                        NSMutableDictionary* dic = [[NSMutableDictionary alloc ]init];
                        NSString* intStr = newsCity;
                        [dic setValue:intStr forKey:@"newsCity"];
                        //TODO：需要持久化
                        NSString* filePath = [TEPersistenceHandler getDocument:@"newsCitySetting.plist"];
                        [dic writeToFile:filePath atomically:YES];
                    }
                }
            }
            [self.delegate_uploadUserSetting uploadUserSettingDidSuccess:result];
            break;
        }
        case TAG_UPLOAD_LOCATION:
        {
            break;
        }
        case TAG_REGISTER_PUSH:
        {
            [self.delegate_registerPush registerPushDidSuccess:result];
            NSString *code = [result objectForKey:@"code"];
            if([code isEqualToString:@"1"]){
                NSMutableDictionary* dic = [[NSMutableDictionary alloc ]init];
                [dic setValue:@"YES" forKey:@"pushFlag"];
                [dic setValue:[TEAppDelegate getApplicationDelegate].pid forKey:@"pid"];
                //TODO：需要持久化
                NSString* filePath = [TEPersistenceHandler getDocument:@"pushInit.plist"];
                [dic writeToFile:filePath atomically:YES];
            }
            break;
        }
        
        case TAG_PUSH_SETTING:
        {
            [self.delegate_pushSetting pushSettingDidSuccess:result];
            
            break;
        }
        case TAG_LOOKUP_FRIENDS:
        {
            [self.delegate_lookupFriends lookupFriendsDidSuccess:responseString];
            break;
        }
        case TAG_BINDING:
        {
            [self.delegate_bingding bindingDidSuccess:responseString];
            break;
        }
        case TAG_INVITATION:
        {
            [self.delegate_invitation invitationDidSuccess:responseString];
            break;
        }
        case TAG_MESSAGE_COUNT:
        {
            [self.delegate_messageCount messageCountDidSuccess:result];
            break;
        }
        case TAG_UPLOAD_RECORD:
        {
            //上报成功用户记录后将记录用户记录的字符串置空
            NSString* filePath = [TEPersistenceHandler getDocument:@"uerLog.plist"];
            NSMutableDictionary* dic2 = [[NSMutableDictionary alloc ]init];
            [dic2 setValue:@"" forKey:@"userLog"];
            [dic2 writeToFile:filePath atomically:YES];
            break;
        }
        case TAG_NEW_SHARE_SNS:
        {
//            responseString = @"{\"state\":{\"code\":\"0\",\"desc\":\"用户注册成功,客户端与用户绑定成功！\",\"extra\":29358},\"reward\":{\"badge\":[{\"id\":1,\"name\":\"新人徽章\"}],\"points\":[{\"point\":10,\"title\":\"注册账号\"},{\"point\":1,\"title\":\"每日登录奖励\"},{\"point\":1,\"title\":\"每日登录奖励\"},{\"point\":1,\"title\":\"每日登录奖励\"},{\"point\":1,\"title\":\"每日登录奖励\"},{\"point\":1,\"title\":\"每日登录奖励\"},{\"point\":1,\"title\":\"每日登录奖励\"},{\"point\":1,\"title\":\"每日登录奖励\"},{\"point\":1,\"title\":\"每日登录奖励\"},{\"point\":1,\"title\":\"每日登录奖励\"},{\"point\":1,\"title\":\"每日登录奖励\"},{\"point\":1,\"title\":\"每日登录奖励\"},{\"point\":1,\"title\":\"每日登录奖励\"},{\"point\":1,\"title\":\"每日登录奖励\"},{\"point\":1,\"title\":\"每日登录奖励\"},{\"point\":1,\"title\":\"每日登录奖励\"},{\"point\":1,\"title\":\"每日登录奖励\"},{\"point\":1,\"title\":\"每日登录奖励\"},{\"point\":1,\"title\":\"每日登录奖励\"},{\"point\":1,\"title\":\"每日登录奖励\"},{\"point\":1,\"title\":\"每日登录奖励\"},{\"point\":1,\"title\":\"每日登录奖励\"},{\"point\":1,\"title\":\"每日登录奖励\"},{\"point\":1,\"title\":\"每日登录奖励\"},{\"point\":1,\"title\":\"每日登录奖励\"}],\"total_points\":11,\"total_miles\":0,\"total_goldCoins\":0,\"total_trackMiles\":0,\"badge_num\":1,\"event_num\":0}}";
            if(rewardDic&&keycount>0){
                self.myRewardDic = rewardDic;
                //查看是否升级：
                int isupgrade = [[rewardDic objectForKey:@"isUpgrade"]intValue];
                if(isupgrade == 1){
                    int level = [[[TEAppDelegate getApplicationDelegate].userInfoDictionary objectForKey:@"level"] intValue];
                    [self.myRewardDic setObject:[NSString stringWithFormat:@"%i",level] forKey:@"level"];
                }
                [self performSelector:@selector(popupRewardWindow) withObject:nil afterDelay:4];
            }
            break;
        }
        case TAG_SMART_TIP:
        {
            NSArray* datalist = [[[result objectForKey:@"response"] objectForKey:@"result"]objectForKey:@"infoList"];
            [self.delegate_smartTip smartTipDidSuccess:datalist];
            break;
        }
        case TAG_ONE_LINE_INFO:
        {
            [self.delegate_oneLineInfo oneLineInfoDidSuccess:result];
            break;
        }
        case TAG_ONE_LINE_DETAIL:
        {
            [self.delegate_oneLineDetail oneLineDetailDidSuccess:result];
            break;
        }
        case TAG_ANNOUNCEMENT:
        {
            if(!result)return;
            NSString* content = [result objectForKey:@"content"];
            NSLog(@"content is %@",content);
            int button_num = [[result objectForKey:@"button"]intValue];
            NSLog(@"button_num is %i",button_num);
            self.target = [[result objectForKey:@"target"]intValue];
            NSLog(@"targetis %i",target);
            UIAlertView *alertView;
            if(button_num == 1){
                alertView = [[UIAlertView alloc]initWithTitle:@"" message:content delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            }else{
                alertView = [[UIAlertView alloc]initWithTitle:@"" message:content delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            }
            alertView.delegate=self;
            [alertView show];
            break;
        }
        case TAG_CHECK_USER:
        {
            [self.delegate_checkUser checkUserDidSuccess:result];
            break;
        }
        case TAG_FIND_POI:
        {
            [self.delegate_findPoi findPoiDidSuccess:result];
            break;
        }
        case TAG_ORDER_CAR:
        {
            [self.delegate_ordercar OrdercarDidSuccess:responseString];
        }
        case TAG_ROUTE_DRIVE:
        {
            [self.delegate_routeDrive routeDriveDidSuccess:result];
            break;
        }
        case TAG_ROUTE_WALK:
        {
            [self.delegate_routeWalk routeWalkDidSuccess:result];
            break;
        }
        default:
            break;
    }
}
- (void)requestFailedByQueue:(ASIHTTPRequest *)request{
    NSLog(@"requestFailedByQueue %@",[request.error description]);
    switch (request.tag) {
        case TAG_LOGIN_WITH_ACOUNT_PASSWORD:
        {
            //解析结果返回信息
            [self.delegate_login loginDidFailed:@"请检查网络"];
            break;
        }
        case TAG_REGISTER:
        {
            //解析结果返回信息
            [self.delegate_register registerDidFailed:@"请检查网络"];
            break;
        }
        case TAG_AUTOLOGIN:
        {
            //解析结果返回信息
            [self.delegate_autoLogin autoLoginDidFailed:@"请检查网络"];
            break;
        }
        case TAG_USER_UPLOAD_AVATAR:
        {
            //解析结果返回信息
            [self.delegate_userAvatarUpload userAvatarUploadDidFailed:@"请检查网络"];
            break;
        }
        case TAG_USER_UPDATE_USERINFO:
        {
            //解析结果返回信息
            [self.delegate_userUpdateUserInfo userUpdateUserInfoDidFailed:@"请检查网络"];
            break;
        }
        case TAG_USER_POINTS_DETAIL:
        {
            //解析结果返回信息
            [self.delegate_userPointsDetail userPointsDetailDidFailed:@"请检查网络"];
            break;
        }
        case TAG_USER_DISTANCE_DETAIL:
        {
            //解析结果返回信息
            [self.delegate_userdistanceDetail userDistanceDetailDidFailed:@"请检查网络"];
            break;
        }
        case TAG_USER_EVENT_DETAIL:
        {
            //解析结果返回信息
            [self.delegate_userEventDetail userEventDetailDidFailed:@"请检查网络"];
            break;
        }
        case TAG_USER_EDIT_PASSWORD:
        {
            //解析结果返回信息
            [self.delegate_userEditPassword userEditPasswordDidFailed:@"请检查网络"];
            break;
        }
        case TAG_USER_FORGET_PASSWORD:
        {
            //解析结果返回信息
            [self.delegate_userForgetPassword userForgetPasswordDidFailed:@"请检查网络"];
            break;
        }
        case TAG_REPORT_EVENT:
        {
            //解析结果返回信息
            [self.delegate_reportEvent reportEventDidFailed:@"请检查网络"];
            break;
        }
        case TAG_GET_TRACK:
        {
            //解析结果返回信息
            [self.delegate_getTrack getTrackDidFailed:@"请检查网络"];
            break;
        }
        case TAG_GET_EVENT:
        {
            //解析结果返回信息
            [self.delegate_getEvent getEventDidFailed:@"请检查网络"];
            break;
        }
        case TAG_EVENT_DETAIL:
        {
            //解析结果返回信息
            [self.delegate_eventDetail eventDetailDidFailed:@"请检查网络"];
            break;
        }
        case TAG_OPTION:
        {
            //解析结果返回信息
            [self.delegate_option optionDidFailed:@"请检查网络"];
            break;
        }
        case TAG_TAXI_INDEX:
        {
            //解析结果返回信息
            [self.delegate_taxiIndex taxiIndexDidFailed:@"请检查网络"];
            break;
        }
        case TAG_TAXI_EASY:
        {
            //解析结果返回信息
            [self.delegate_taxiEasy taxiEasyDidFailed:@"请检查网络"];
            break;
        }
        case TAG_TAXI_LONG_PRESS:
        {
            //解析结果返回信息
            [self.delegate_taxiLongPress taxiLongPressDidFailed:@"请检查网络"];
            break;
        }
        case TAG_SNS_LOGIN:
        {
            //解析结果返回信息
            [self.delegate_snsLogin snsLoginDidFailed:@"请检查网络"];
            break;
        }
        case TAG_UPLOAD_SETTING:
        {
            //解析结果返回信息
            [self.delegate_uploadUserSetting uploadUserSettingDidFailed:@"请检查网络"];
            break;
        }
        case TAG_LIMITNUM:
        {
            //解析结果返回信息
            [self.delegate_limitNum limitNumDidFailed:@"请检查网络"];
            break;
        }
        case TAG_SNS_SHARE:
        {
            //解析结果返回信息
            [self.delegate_snsShare snsShareDidFailed:@"请检查网络"];
            break;
        }
        case TAG_DOWNLOAD_SETTING:
        {
            //解析结果返回信息
            [self.delegate_downloadUserSetting downloadUserSettingDidFailed:@"请检查网络"];
            break;
        }
        case TAG_UPLOAD_LOCATION:
        {
            //解析结果返回信息
            [self.delegate_uploadLocation uploadLocationDidFailed:@"请检查网络"];
            break;
        }
        case TAG_REGISTER_PUSH:
        {
            //解析结果返回信息
            [self.delegate_registerPush registerPushDidFailed:@"请检查网络"];
            break;
        }
        case TAG_PUSH_SETTING:
        {
            //解析结果返回信息
            [self.delegate_pushSetting pushSettingDidFailed:@"请检查网络"];
            break;
        }
        case TAG_LOOKUP_FRIENDS:
        {
            //解析结果返回信息
            [self.delegate_lookupFriends lookupFriendsDidFailed:@"请检查网络"];
            break;
        }
        case TAG_BINDING:
        {
            //解析结果返回信息
            [self.delegate_bingding bindingDidFailed:@"请检查网络"];
            break;
        }
        case TAG_INVITATION:
        {
            //解析结果返回信息
            [self.delegate_invitation invitationDidFailed:@"请检查网络"];
            break;
        }
        case TAG_MESSAGE_COUNT:
        {
            //解析结果返回信息
            [self.delegate_messageCount messageCountDidFailed:@"请检查网络"];
            break;
        }
        case TAG_UPLOAD_RECORD:
        {
            //解析结果返回信息
            [self.delegate_uploadRecord uploadRecordDidFailed:@"请检查网络"];
            break;
        }
        case TAG_NEW_SHARE_SNS:
        {
            //解析结果返回信息
            [self.delegate_newShareSNS ShareSNSNewDidFailed:@"请检查网络"];
            break;
        }
        case TAG_CHECK_USER:{
            [self.delegate_checkUser checkUserDidFailed];
        }
        case TAG_ROUTE_DRIVE:{
            [self.delegate_routeDrive routeDriveDidFailed:@""];
        }
        case TAG_ROUTE_WALK:{
            [self.delegate_routeWalk routeWalkDidFailed:@""];
        }
        default:
            break;
    }
}
- (void)queueFinished:(ASIHTTPRequest *)request{
    NSLog(@"queueFinished");
}
#pragma -mark 自定义
//获取用户信息保存在plist
- (void)saveUserInfo:(NSDictionary*)dic{
    NSMutableDictionary* userInfoDicToSave = [[NSMutableDictionary alloc]init];
    NSString* id = [dic objectForKey:@"id"];
    NSString* username = [dic objectForKey:@"username"];
    NSString* email = [dic objectForKey:@"email"];
    NSString* points = [dic objectForKey:@"points"];
    NSString* gender = [dic objectForKey:@"gender"];
    NSString* avatar = [dic objectForKey:@"avatar"];
    NSString* drive_miles = [dic objectForKey:@"drive_miles"];
    NSString* mobile_num = [dic objectForKey:@"mobile_num"];
    NSString* birth_date = [dic objectForKey:@"birth_date"];
    NSString* track_miles = [dic objectForKey:@"track_miles"];
    NSString* event_num = [dic objectForKey:@"event_num"];
    NSString* group_name = [dic objectForKey:@"group_name"];
    NSArray* has_badges = [dic objectForKey:@"has_badges_id"];
    NSString* filePath = [TEPersistenceHandler getDocument:@"userInfo.plist"];
    if(![TEUtil isStringNULL:id])[userInfoDicToSave setObject:id forKey:@"id"];
    if(![TEUtil isStringNULL:username])[userInfoDicToSave setObject:username forKey:@"username"];
    if(![TEUtil isStringNULL:email])[userInfoDicToSave setObject:email forKey:@"email"];
    if(![TEUtil isStringNULL:points])[userInfoDicToSave setObject:points forKey:@"points"];
    if(![TEUtil isStringNULL:gender])[userInfoDicToSave setObject:gender forKey:@"gender"];
    if(![TEUtil isStringNULL:avatar])[userInfoDicToSave setObject:avatar forKey:@"avatar"];
    if(![TEUtil isStringNULL:drive_miles])[userInfoDicToSave setObject:drive_miles forKey:@"drive_miles"];
    if(![TEUtil isStringNULL:mobile_num])[userInfoDicToSave setObject:mobile_num forKey:@"mobile_num"];
    if(![TEUtil isStringNULL:birth_date])[userInfoDicToSave setObject:birth_date forKey:@"birth_date"];
    if(![TEUtil isStringNULL:track_miles])[userInfoDicToSave setObject:track_miles forKey:@"track_miles"];
    if(![TEUtil isStringNULL:event_num])[userInfoDicToSave setObject:event_num forKey:@"event_num"];
    if(![TEUtil isStringNULL:group_name])[userInfoDicToSave setObject:group_name forKey:@"group_name"];
    if(has_badges)[userInfoDicToSave setObject:has_badges forKey:@"has_badges"];
    [userInfoDicToSave writeToFile:filePath atomically:YES];
}

#pragma -mark 各种执行请求的实现
//登录
- (void)doRequest_login:(NSDictionary*)params{
    NSString* urlStr = [NSString stringWithFormat:@"%@/user/v4/login?email=%@&passwd=%@&ua=%@&pid=%@&type=local",ENDPOINTS,[params objectForKey:@"email"],[params objectForKey:@"passwd"],[TEAppDelegate getApplicationDelegate].userAgent,[TEAppDelegate getApplicationDelegate].pid];
    NSLog(@"手动登录url is %@",urlStr);
    NSLog(@"参数是%@",params);
    NSURL* url = [NSURL URLWithString:urlStr];
    self.loginRequest =  [ASIHTTPRequest requestWithURL:url];
    self.loginRequest.tag = TAG_LOGIN_WITH_ACOUNT_PASSWORD;
    [self.loginRequest setNumberOfTimesToRetryOnTimeout:3];
    [[self networkQueue]addOperation:self.loginRequest];
}
//注册
- (void)doRequest_register:(NSDictionary *)params{
    NSString* urlStr = [NSString stringWithFormat:@"%@/user/v3/register",ENDPOINTS];
    NSURL* url = [NSURL URLWithString:urlStr];
    self.registerRequest =  [ASIFormDataRequest requestWithURL:url];
    self.registerRequest.tag = TAG_REGISTER;
    [self.registerRequest setNumberOfTimesToRetryOnTimeout:3];
    [self.registerRequest addRequestHeader:@"X-PID" value:[TEAppDelegate getApplicationDelegate].pid];
    [self.registerRequest addRequestHeader:@"User-Agent" value:[TEAppDelegate getApplicationDelegate].userAgent];
    [self.registerRequest setPostValue:[params objectForKey:@"email"] forKey:@"email"];
    [self.registerRequest setPostValue:[params objectForKey:@"passwd"] forKey:@"passwd"];
    [self.registerRequest setPostValue:[params objectForKey:@"username"] forKey:@"username"];
    [[self networkQueue]addOperation:self.registerRequest];
}
//自动登录
- (void)doRequest_autoLogin{
    NSString* urlStr = [NSString stringWithFormat:@"%@/user/v4/autoLogin",ENDPOINTS];
    NSLog(@"自动登录url = %@",urlStr);
    NSURL* url = [NSURL URLWithString:urlStr];
    self.autoLoginRequest =  [ASIFormDataRequest requestWithURL:url];
    self.autoLoginRequest.tag = TAG_AUTOLOGIN;
    [self.autoLoginRequest setNumberOfTimesToRetryOnTimeout:3];
    [self.autoLoginRequest setPostValue:[TEAppDelegate getApplicationDelegate].pid forKey:@"pid"];
    [self.autoLoginRequest setPostValue:[TEAppDelegate getApplicationDelegate].userAgent forKey:@"ua"];
    [[self networkQueue]addOperation:self.autoLoginRequest];
}
//用户上传头像
- (void)doRequest_userAvatarUpload:(NSDictionary *)params{
    NSString* urlStr = [NSString stringWithFormat:@"%@/user/v4/updateAvatar",ENDPOINTS];
    NSURL* url = [NSURL URLWithString:urlStr];
    NSLog(@"更新头像url is %@",url);
    NSString* uid = [[TEAppDelegate getApplicationDelegate] getUid];
    self.userAvatarUploadRequest =  [ASIFormDataRequest requestWithURL:url];
    self.userAvatarUploadRequest.tag = TAG_USER_UPLOAD_AVATAR;
    [self.userAvatarUploadRequest setNumberOfTimesToRetryOnTimeout:3];
    [self.userAvatarUploadRequest setPostValue:uid forKey:@"uid"];
    [self.userAvatarUploadRequest setPostValue:[TEAppDelegate getApplicationDelegate].pid forKey:@"pid"];
    [self.userAvatarUploadRequest setPostValue:[TEAppDelegate getApplicationDelegate].userAgent forKey:@"ua"];
    [self.userAvatarUploadRequest addData:[params objectForKey:@"avatar"] forKey:@"avatar"];
    [[self networkQueue]addOperation:self.userAvatarUploadRequest];
}
//用户修改个人资料
- (void)doRequest_userUpdateUserInfo:(NSDictionary *)params{
    NSString* urlStr = [NSString stringWithFormat:@"%@/user/v3/update",ENDPOINTS];
    NSURL* url = [NSURL URLWithString:urlStr];
    self.userUpdateUserInfoRequest =  [ASIFormDataRequest requestWithURL:url];
    self.userUpdateUserInfoRequest.tag = TAG_USER_UPDATE_USERINFO;
    [self.userUpdateUserInfoRequest setNumberOfTimesToRetryOnTimeout:3];
    [self.userUpdateUserInfoRequest addRequestHeader:@"X-PID" value:[TEAppDelegate getApplicationDelegate].pid];
    [self.userUpdateUserInfoRequest addRequestHeader:@"User-Agent" value:[TEAppDelegate getApplicationDelegate].userAgent];
    [self.userUpdateUserInfoRequest setPostValue:[params objectForKey:@"nickname"] forKey:@"nickname"];
    [self.userUpdateUserInfoRequest setPostValue:[params objectForKey:@"real_name"] forKey:@"real_name"];
    [self.userUpdateUserInfoRequest setPostValue:[params objectForKey:@"mobile_num"] forKey:@"mobile_num"];
    [self.userUpdateUserInfoRequest setPostValue:[params objectForKey:@"gender"] forKey:@"gender"];
    [self.userUpdateUserInfoRequest setPostValue:[params objectForKey:@"birthday"] forKey:@"birthday"];
    [[self networkQueue]addOperation:self.userUpdateUserInfoRequest];
}
//积分详情
- (void)doRequest_userPointsDetail:(NSDictionary *)params{
    NSString* str_url = [NSString stringWithFormat:@"%@/user/v3/find/pointList",ENDPOINTS];
    NSURL* url = [NSURL URLWithString:str_url];
    self.userPointsDetailRequest =  [ASIFormDataRequest requestWithURL:url];
    self.userPointsDetailRequest.tag = TAG_USER_POINTS_DETAIL;
    [self.userPointsDetailRequest setNumberOfTimesToRetryOnTimeout:3];
    [self.userPointsDetailRequest setTimeOutSeconds:15];
    [self.userPointsDetailRequest addRequestHeader:@"X-PID" value:[TEAppDelegate getApplicationDelegate].pid];
    [self.userPointsDetailRequest addRequestHeader:@"User-Agent" value:[TEAppDelegate getApplicationDelegate].userAgent];
    [self.userPointsDetailRequest setPostValue:[params objectForKey:@"begin"] forKey:@"begin"];
    NSString* uid = [[TEAppDelegate getApplicationDelegate] getUid];
    NSLog(@"uid is %@",uid);
    [self.userPointsDetailRequest setPostValue:uid forKey:@"uid"];
    [self.userPointsDetailRequest setPostValue:@"all" forKey:@"type"];
    [[self networkQueue]addOperation:self.userPointsDetailRequest];
}
//积分详情
- (void)doRequest_userDistanceDetail:(NSDictionary *)params{
    NSString* str_url = [NSString stringWithFormat:@"%@/user/v3/find/pointList",ENDPOINTS];
    NSURL* url = [NSURL URLWithString:str_url];
    self.userDistanceDetailRequest =  [ASIFormDataRequest requestWithURL:url];
    self.userDistanceDetailRequest.tag = TAG_USER_DISTANCE_DETAIL;
    [self.userDistanceDetailRequest setNumberOfTimesToRetryOnTimeout:3];
    [self.userPointsDetailRequest setTimeOutSeconds:15];
    [self.userDistanceDetailRequest addRequestHeader:@"X-PID" value:[TEAppDelegate getApplicationDelegate].pid];
    [self.userDistanceDetailRequest addRequestHeader:@"User-Agent" value:[TEAppDelegate getApplicationDelegate].userAgent];
    [self.userDistanceDetailRequest setPostValue:[params objectForKey:@"begin"] forKey:@"begin"];
    NSString* uid = [[TEAppDelegate getApplicationDelegate] getUid];
    NSLog(@"uid is %@",uid);
    [self.userDistanceDetailRequest setPostValue:uid forKey:@"uid"];
    [self.userDistanceDetailRequest setPostValue:@"miles" forKey:@"type"];
    [[self networkQueue]addOperation:self.userDistanceDetailRequest];
}
//事件详情
- (void)doRequest_userEventDetail:(NSDictionary *)params{
    NSString* str_url = [NSString stringWithFormat:@"%@/user/v3/find/pointList",ENDPOINTS];
    NSURL* url = [NSURL URLWithString:str_url];
    self.userEventDetailRequest =  [ASIFormDataRequest requestWithURL:url];
    self.userEventDetailRequest.tag = TAG_USER_EVENT_DETAIL;
    [self.userEventDetailRequest setNumberOfTimesToRetryOnTimeout:3];
    [self.userPointsDetailRequest setTimeOutSeconds:15];
    [self.userEventDetailRequest addRequestHeader:@"X-PID" value:[TEAppDelegate getApplicationDelegate].pid];
    [self.userEventDetailRequest addRequestHeader:@"User-Agent" value:[TEAppDelegate getApplicationDelegate].userAgent];
    [self.userEventDetailRequest setPostValue:[params objectForKey:@"begin"] forKey:@"begin"];
    NSString* uid = [[TEAppDelegate getApplicationDelegate] getUid];
    NSLog(@"uid is %@",uid);
    [self.userEventDetailRequest setPostValue:uid forKey:@"uid"];
    [self.userEventDetailRequest setPostValue:@"report_event" forKey:@"type"];
    [[self networkQueue]addOperation:self.userEventDetailRequest];
}
//修改密码
- (void)doRequest_userEditPassword:(NSDictionary *)params{
    NSString* str_url = [NSString stringWithFormat:@"%@/user/v3/update/passwd",ENDPOINTS];
    NSURL* url = [NSURL URLWithString:str_url];
    self.userEditPasswordRequest =  [ASIFormDataRequest requestWithURL:url];
    self.userEditPasswordRequest.tag = TAG_USER_EDIT_PASSWORD;
    [self.userEditPasswordRequest setNumberOfTimesToRetryOnTimeout:3];
    [self.userPointsDetailRequest setTimeOutSeconds:15];
    [self.userEditPasswordRequest addRequestHeader:@"X-PID" value:[TEAppDelegate getApplicationDelegate].pid];
    [self.userEditPasswordRequest addRequestHeader:@"User-Agent" value:[TEAppDelegate getApplicationDelegate].userAgent];
    [self.userEditPasswordRequest setPostValue:[params objectForKey:@"oldpasswd"] forKey:@"oldpasswd"];
    [self.userEditPasswordRequest setPostValue:[params objectForKey:@"newpasswd"] forKey:@"newpasswd"];
    [[self networkQueue]addOperation:self.userEditPasswordRequest];
}
//忘记密码
- (void)doRequest_userForgetPassword:(NSDictionary *)params{
    NSString* str_url = [NSString stringWithFormat:@"%@/user/v3/find/passwd",ENDPOINTS];
    NSURL* url = [NSURL URLWithString:str_url];
    self.userForgetPasswordRequest =  [ASIFormDataRequest requestWithURL:url];
    self.userForgetPasswordRequest.tag = TAG_USER_FORGET_PASSWORD;
    [self.userForgetPasswordRequest setNumberOfTimesToRetryOnTimeout:3];
    [self.userPointsDetailRequest setTimeOutSeconds:15];
    [self.userForgetPasswordRequest addRequestHeader:@"X-PID" value:[TEAppDelegate getApplicationDelegate].pid];
    [self.userForgetPasswordRequest addRequestHeader:@"User-Agent" value:[TEAppDelegate getApplicationDelegate].userAgent];
    [self.userForgetPasswordRequest setPostValue:[params objectForKey:@"email"] forKey:@"email"];
    [[self networkQueue]addOperation:self.userForgetPasswordRequest];
}
//上报事件
- (void)doRequest_reportEvent:(NSDictionary*)params :(UIImage*)eventImage{
    NSString* str_url = [NSString stringWithFormat:@"%@/api/v4/uploadEvent/",ENDPOINTS];
    NSLog(@"上报事件str_url is %@",str_url);
    NSLog(@"上报事件参数：%@",params);
    NSURL* url = [NSURL URLWithString:str_url];
    self.reportEventRequest =  [ASIFormDataRequest requestWithURL:url];
    self.reportEventRequest.tag = TAG_REPORT_EVENT;
    [self.reportEventRequest setNumberOfTimesToRetryOnTimeout:3];
    [self.reportEventRequest setPostValue:[TEAppDelegate getApplicationDelegate].pid forKey:@"pid"];
    [self.reportEventRequest setPostValue:[TEAppDelegate getApplicationDelegate].userAgent forKey:@"ua"];
    for (id oneKey in [params allKeys]){
        [self.reportEventRequest setPostValue:[params objectForKey:oneKey] forKey:oneKey];
    }
    NSData* data_image;
    if(eventImage){
        data_image = UIImageJPEGRepresentation(eventImage, 0.2);
    }else{
        data_image = nil;
    }
    [self.reportEventRequest addData:data_image forKey:@"media"];
    [self.reportEventRequest buildRequestHeaders];
    [[self networkQueue]addOperation:self.reportEventRequest];
}
//请求轨迹
- (void)doRequest_getTrackWithLatitude:(double)latitude Longitude:(double)longitude Level:(int)zoomLevel{
    NSString* str_url = [NSString stringWithFormat:@"%@/sns/v3/track?lng=%f&lat=%f&lev=%d",
                         ENDPOINTS,
                         longitude,
                         latitude,
                         zoomLevel];
    NSLog(@"url is %@",str_url);
    NSURL* url = [NSURL URLWithString:str_url];
    self.getTrackRequest =  [ASIHTTPRequest requestWithURL:url];
    self.getTrackRequest.tag = TAG_GET_TRACK;
    [self.getTrackRequest setNumberOfTimesToRetryOnTimeout:3];
    [self.getTrackRequest addRequestHeader:@"X-PID" value:[TEAppDelegate getApplicationDelegate].pid];
    [self.getTrackRequest addRequestHeader:@"User-Agent" value:[TEAppDelegate getApplicationDelegate].userAgent];
    [[self networkQueue]addOperation:self.getTrackRequest];
}
//请求轨迹
- (void)doRequest_getEventWithLatitude:(double)latitude Longitude:(double)longitude Level:(int)zoomLevel{
    NSString* str_url = [NSString stringWithFormat:@"%@/sns/v3/event?lng=%f&lat=%f&lev=%d&ver=2",
                         ENDPOINTS,
                         longitude,
                         latitude,
                         zoomLevel];
    NSLog(@"请求事件url is %@",str_url);
    NSURL* url = [NSURL URLWithString:str_url];
    self.getEventRequest =  [ASIFormDataRequest requestWithURL:url];
    self.getEventRequest.tag = TAG_GET_EVENT;
    [self.getEventRequest setNumberOfTimesToRetryOnTimeout:3];
    [self.getEventRequest addRequestHeader:@"X-PID" value:[TEAppDelegate getApplicationDelegate].pid];
    [self.getEventRequest addRequestHeader:@"User-Agent" value:[TEAppDelegate getApplicationDelegate].userAgent];
    [[self networkQueue]addOperation:self.getEventRequest];
}
//事件详情
- (void)doRequest_eventDetail:(int)eventid :(NSString*)type{
    NSString* str_url = [NSString stringWithFormat:@"%@/sns/v3/findObject",ENDPOINTS];
    NSURL* url = [NSURL URLWithString:str_url];
    self.eventDetailRequest =  [ASIFormDataRequest requestWithURL:url];
    self.eventDetailRequest.tag = TAG_EVENT_DETAIL;
    [self.eventDetailRequest setNumberOfTimesToRetryOnTimeout:3];
    [self.eventDetailRequest setTimeOutSeconds:15];
    [self.eventDetailRequest addRequestHeader:@"X-PID" value:[TEAppDelegate getApplicationDelegate].pid];
    [self.eventDetailRequest addRequestHeader:@"User-Agent" value:[TEAppDelegate getApplicationDelegate].userAgent];
    NSString* uid = [[TEAppDelegate getApplicationDelegate] getUid];
    NSLog(@"uid is %@",uid);
    [self.eventDetailRequest setPostValue:uid forKey:@"uid"];
    [self.eventDetailRequest setPostValue:type forKey:@"objectType"];
    [self.eventDetailRequest setPostValue:[NSString stringWithFormat: @"%d", eventid] forKey:@"objectId"];
    [[self networkQueue]addOperation:self.eventDetailRequest];
}
//投票
- (void)doRequest_Option:(NSDictionary*)params{
    NSString* str_url = [NSString stringWithFormat:@"%@/sns/v3/optionObject",ENDPOINTS];
    NSURL* url = [NSURL URLWithString:str_url];
    self.optionRequest =  [ASIFormDataRequest requestWithURL:url];
    self.optionRequest.tag = TAG_OPTION;
    [self.optionRequest setNumberOfTimesToRetryOnTimeout:3];
    [self.optionRequest setTimeOutSeconds:15];
    [self.optionRequest addRequestHeader:@"X-PID" value:[TEAppDelegate getApplicationDelegate].pid];
    [self.optionRequest addRequestHeader:@"User-Agent" value:[TEAppDelegate getApplicationDelegate].userAgent];
    NSString* uid = [[TEAppDelegate getApplicationDelegate] getUid];
    NSLog(@"uid is %@",uid);
    [self.optionRequest setPostValue:[params objectForKey:@"objectId"] forKey:@"objectId"];
    [self.optionRequest setPostValue:[params objectForKey:@"uid"] forKey:@"uid"];
    [self.optionRequest setPostValue:[params objectForKey:@"objectType"] forKey:@"objectType"];
    [self.optionRequest setPostValue:[params objectForKey:@"optionType"] forKey:@"optionType"];
    [[self networkQueue]addOperation:self.optionRequest];
}
//打车指数
- (void)doRequest_taxiIndex:(double)latitude longitude:(double)longitude{
    NSString* str_url = [NSString stringWithFormat:@"http://taxi.trafficeye.cn/TaxiIndex/tq?action=1&lon=%f&lat=%f&catalog=1", longitude, latitude];
    NSURL* url = [NSURL URLWithString:str_url];
    self.taxiIndexRequest = [ASIHTTPRequest requestWithURL:url];
    self.taxiIndexRequest.tag = TAG_TAXI_INDEX;
    [self.taxiIndexRequest setNumberOfTimesToRetryOnTimeout:3];
    [self.taxiIndexRequest setTimeOutSeconds:15];
    [self.taxiIndexRequest addRequestHeader:@"X-PID" value:[TEAppDelegate getApplicationDelegate].pid];
    [self.taxiIndexRequest addRequestHeader:@"User-Agent" value:[TEAppDelegate getApplicationDelegate].userAgent];
    [[self networkQueue]addOperation:self.taxiIndexRequest];
}
//容易打车位置
- (void)doRequest_taxiEasy:(double)latitude longitude:(double)longitude{
    NSString* str_url = [NSString stringWithFormat:@"http://taxi.trafficeye.cn/TaxiIndex/tq?action=4&lon=%f&lat=%f&radius=0.018&catalog=1", longitude, latitude];
    NSURL* url = [NSURL URLWithString:str_url];
    self.taxiEasyRequest = [ASIHTTPRequest requestWithURL:url];
    self.taxiEasyRequest.tag = TAG_TAXI_EASY;
    [self.taxiEasyRequest setNumberOfTimesToRetryOnTimeout:3];
    [self.taxiEasyRequest setTimeOutSeconds:15];
    [self.taxiEasyRequest addRequestHeader:@"X-PID" value:[TEAppDelegate getApplicationDelegate].pid];
    [self.taxiEasyRequest addRequestHeader:@"User-Agent" value:[TEAppDelegate getApplicationDelegate].userAgent];
    [[self networkQueue]addOperation:self.taxiEasyRequest];
}
//打车长按
- (void)doRequest_taxiLongPress:(double)latitude longitude:(double)longitude{
    NSString* str_url = [NSString stringWithFormat:@"http://taxi.trafficeye.cn/TaxiIndex/tq?action=1&lon=%f&lat=%f&catalog=1", longitude, latitude];
    NSURL* url = [NSURL URLWithString:str_url];
    self.taxiLongPressRequest = [ASIHTTPRequest requestWithURL:url];
    self.taxiLongPressRequest.tag = TAG_TAXI_LONG_PRESS;
    [self.taxiLongPressRequest setNumberOfTimesToRetryOnTimeout:3];
    [self.taxiLongPressRequest setTimeOutSeconds:15];
    [self.taxiLongPressRequest addRequestHeader:@"X-PID" value:[TEAppDelegate getApplicationDelegate].pid];
    [self.taxiLongPressRequest addRequestHeader:@"User-Agent" value:[TEAppDelegate getApplicationDelegate].userAgent];
    [[self networkQueue]addOperation:self.taxiLongPressRequest];
}

//sns登录
- (void)doRequest_snsLogin:(NSDictionary*)params{
    NSString* str_url = [NSString stringWithFormat:@"%@/user/v3/unitLogin?format=json",ENDPOINTS];
    NSURL* url = [NSURL URLWithString:str_url];
    self.snsLoginRequest =  [ASIFormDataRequest requestWithURL:url];
    self.snsLoginRequest.tag = TAG_SNS_LOGIN;
    [self.snsLoginRequest setNumberOfTimesToRetryOnTimeout:3];
    [self.snsLoginRequest setTimeOutSeconds:15];
    [self.snsLoginRequest addRequestHeader:@"X-PID" value:[TEAppDelegate getApplicationDelegate].pid];
    [self.snsLoginRequest addRequestHeader:@"User-Agent" value:[TEAppDelegate getApplicationDelegate].userAgent];
    [self.snsLoginRequest setPostValue:[params objectForKey:@"media_type"] forKey:@"media_type"];
    [self.snsLoginRequest setPostValue:[params objectForKey:@"unitId"] forKey:@"unitId"];
    [self.snsLoginRequest setPostValue:[params objectForKey:@"birthday"] forKey:@"birthday"];
    [self.snsLoginRequest setPostValue:[params objectForKey:@"sex"] forKey:@"sex"];
    [self.snsLoginRequest setPostValue:[params objectForKey:@"username"] forKey:@"username"];
    [self.snsLoginRequest setPostValue:[params objectForKey:@"headurl"] forKey:@"headurl"];
    [[self networkQueue]addOperation:self.snsLoginRequest];
}
//上传个人设置
- (void)doRequest_uploadUserSetting:(NSString*)type :(NSString*)settingStr{
    NSString* str_url = [NSString stringWithFormat:@"%@/api2/v3/favroadsNew/?format=json",ENDPOINTS];
    NSURL* url = [NSURL URLWithString:str_url];
    self.uploadUserSettingRequest =  [ASIFormDataRequest requestWithURL:url];
    self.uploadUserSettingRequest.tag = TAG_UPLOAD_SETTING;
    [self.uploadUserSettingRequest setNumberOfTimesToRetryOnTimeout:3];
    [self.uploadUserSettingRequest setTimeOutSeconds:15];
    [self.uploadUserSettingRequest addRequestHeader:@"X-PID" value:[TEAppDelegate getApplicationDelegate].pid];
    [self.uploadUserSettingRequest addRequestHeader:@"User-Agent" value:[TEAppDelegate getApplicationDelegate].userAgent];
    [self.uploadUserSettingRequest setPostValue:type forKey:@"type"];
    [self.uploadUserSettingRequest setPostValue:settingStr forKey:@"favroads"];
    [[self networkQueue]addOperation:self.uploadUserSettingRequest];
}
- (void)doRequest_limitNum{
    NSString* str_url = [NSString stringWithFormat:@"%@/api2/v2/limitNum/",ENDPOINTS];
    NSLog(@"限行号url是%@",str_url);
    NSURL* url = [NSURL URLWithString:str_url];
    self.limitNumRequest =  [ASIHTTPRequest requestWithURL:url];
    self.limitNumRequest.tag = TAG_LIMITNUM;
    [self.limitNumRequest setNumberOfTimesToRetryOnTimeout:3];
    [self.limitNumRequest setTimeOutSeconds:15];
    [self.limitNumRequest addRequestHeader:@"X-PID" value:[TEAppDelegate getApplicationDelegate].pid];
    [self.limitNumRequest addRequestHeader:@"User-Agent" value:[TEAppDelegate getApplicationDelegate].userAgent];
    [[self networkQueue]addOperation:self.limitNumRequest];
}
//sns平台分享成功后通知服务器
- (void)doRequest_snsShare:(NSString*)type{
    NSString* str_url = [NSString stringWithFormat:@"%@/sns/v3/share?type=%@&ref=0",ENDPOINTS,type];
    NSURL* url = [NSURL URLWithString:str_url];
    self.snsShareRequest =  [ASIHTTPRequest requestWithURL:url];
    self.snsShareRequest.tag = TAG_SNS_SHARE;
    [self.snsShareRequest setNumberOfTimesToRetryOnTimeout:3];
    [self.snsShareRequest setTimeOutSeconds:15];
    [self.snsShareRequest addRequestHeader:@"X-PID" value:[TEAppDelegate getApplicationDelegate].pid];
    [self.snsShareRequest addRequestHeader:@"User-Agent" value:[TEAppDelegate getApplicationDelegate].userAgent];
    [[self networkQueue]addOperation:self.snsShareRequest];
}
//下载用户设置
- (void)doRequest_downloadUserSetting{
    NSString* str_url = [NSString stringWithFormat:@"%@/api2/v3/favroadsNew/?type=all",ENDPOINTS];
    NSURL* url = [NSURL URLWithString:str_url];
    self.downloadUserSettingRequest =  [ASIHTTPRequest requestWithURL:url];
    self.downloadUserSettingRequest.tag = TAG_DOWNLOAD_SETTING;
    [self.downloadUserSettingRequest setNumberOfTimesToRetryOnTimeout:3];
    [self.downloadUserSettingRequest setTimeOutSeconds:15];
    [self.downloadUserSettingRequest addRequestHeader:@"X-PID" value:[TEAppDelegate getApplicationDelegate].pid];
    [self.downloadUserSettingRequest addRequestHeader:@"User-Agent" value:[TEAppDelegate getApplicationDelegate].userAgent];
    [[self networkQueue]addOperation:self.downloadUserSettingRequest];
}
//上报数据
- (void)doRequest_uploadLocation:(NSString*)uploadString{
    NSString* str_url = [NSString stringWithFormat:@"%@/api/v4/flowdata/",ENDPOINTS];
    NSURL* url = [NSURL URLWithString:str_url];
    self.uploadLocationRequest =  [ASIFormDataRequest requestWithURL:url];
    self.uploadLocationRequest.tag = TAG_UPLOAD_LOCATION;
    [self.uploadLocationRequest setNumberOfTimesToRetryOnTimeout:3];
    [self.uploadLocationRequest setTimeOutSeconds:15];
    [self.uploadLocationRequest addRequestHeader:@"pid" value:[TEAppDelegate getApplicationDelegate].pid];
//    [self.uploadLocationRequest addRequestHeader:@"ua" value:[TEAppDelegate getApplicationDelegate].userAgent];
    NSData* unzipData = [uploadString dataUsingEncoding:NSUTF8StringEncoding];
    NSData* zippedData = [ASIDataCompressor compressData:unzipData error:nil];
    [self.uploadLocationRequest appendPostData:zippedData];
    [[self networkQueue]addOperation:self.uploadLocationRequest];
}
//注册推送信息
- (void)doRequest_registerPush:(NSString*)token :(NSString*)cityName{
    NSString* str_url = [NSString stringWithFormat:@"%@/api2/v3/pushDeviceInfo",ENDPOINTS];
    NSURL* url = [NSURL URLWithString:str_url];
    self.registerPushRequest =  [ASIFormDataRequest requestWithURL:url];
    self.registerPushRequest.tag = TAG_REGISTER_PUSH;
    [self.registerPushRequest setNumberOfTimesToRetryOnTimeout:3];
    [self.registerPushRequest setTimeOutSeconds:15];
    [self.registerPushRequest addRequestHeader:@"X-PID" value:[TEAppDelegate getApplicationDelegate].pid];
    [self.registerPushRequest addRequestHeader:@"User-Agent" value:[TEAppDelegate getApplicationDelegate].userAgent];
    [self.registerPushRequest setPostValue:cityName forKey:@"city"];
    [self.registerPushRequest setPostValue:@"2" forKey:@"isPushed"];
    [self.registerPushRequest setPostValue:token forKey:@"channelID"];
    [self.registerPushRequest setPostValue:@"5" forKey:@"osType"];
    [self.registerPushRequest setPostValue:CLIENT_VERSION forKey:@"version"];
    [self.registerPushRequest setPostValue:@"" forKey:@"uid"];
    [self.registerPushRequest setPostValue:@"json" forKey:@"format"];
    [[self networkQueue]addOperation:self.registerPushRequest];
}
- (void)doRequest_pushSetting:(NSString*)isPush :(NSString*)cityName{
    NSString* str_url = [NSString stringWithFormat:@"%@/api2/v3/updatePushDeviceInfo",ENDPOINTS];
    NSURL* url = [NSURL URLWithString:str_url];
    self.pushSettingRequest =  [ASIFormDataRequest requestWithURL:url];
    self.pushSettingRequest.tag = TAG_PUSH_SETTING;
    [self.pushSettingRequest setNumberOfTimesToRetryOnTimeout:3];
    [self.pushSettingRequest setTimeOutSeconds:15];
    [self.pushSettingRequest addRequestHeader:@"X-PID" value:[TEAppDelegate getApplicationDelegate].pid];
    [self.pushSettingRequest addRequestHeader:@"User-Agent" value:[TEAppDelegate getApplicationDelegate].userAgent];
    [self.pushSettingRequest setPostValue:cityName forKey:@"city"];
    [self.pushSettingRequest setPostValue:@"2" forKey:@"isPushed"];
    [self.pushSettingRequest setPostValue:@"json" forKey:@"format"];
    [[self networkQueue]addOperation:self.pushSettingRequest];
}
- (void)doRequest_lookupFriends:(NSDictionary*)params{
    NSString* str_url = [NSString stringWithFormat:@"%@/sns/v1/user/invatationList?uid=%@&count=%@&clientip=%@&page=%@&requesType=%@&userType=%@&token=%@&openid=%@",@"http://mobile.trafficeye.com.cn:21290/TrafficeyeCommunityService",[params objectForKey:@"uid"],[params objectForKey:@"count"],[params objectForKey:@"clientip"],[params objectForKey:@"page"],[params objectForKey:@"requestType"],[params objectForKey:@"userType"],[params objectForKey:@"token"],[params objectForKey:@"openid"]];
    NSLog(@"查找好友url是%@",str_url);
    NSURL* url = [NSURL URLWithString:str_url];
    self.lookupFriendsRequest =  [ASIHTTPRequest requestWithURL:url];
    self.lookupFriendsRequest.tag = TAG_LOOKUP_FRIENDS;
    [self.lookupFriendsRequest setNumberOfTimesToRetryOnTimeout:3];
    [self.lookupFriendsRequest setTimeOutSeconds:15];
    [self.lookupFriendsRequest addRequestHeader:@"X-PID" value:[TEAppDelegate getApplicationDelegate].pid];
    [self.lookupFriendsRequest addRequestHeader:@"User-Agent" value:[TEAppDelegate getApplicationDelegate].userAgent];
    [[self networkQueue]addOperation:self.lookupFriendsRequest];
}
- (void)doRequest_binding:(NSDictionary*)params{
    NSString* str_url = [NSString stringWithFormat:@"%@/sns/v1/user/Binding?uid=%@&clientip=%@&requesType=%@&token=%@&openId=%@",@"http://mobile.trafficeye.com.cn:21290/TrafficeyeCommunityService",[params objectForKey:@"uid"],[params objectForKey:@"clientip"],[params objectForKey:@"requestType"],[params objectForKey:@"token"],[params objectForKey:@"openid"]];
    NSLog(@"绑定url是%@",str_url);
    NSURL* url = [NSURL URLWithString:str_url];
    self.bindingRequest =  [ASIHTTPRequest requestWithURL:url];
    self.bindingRequest.tag = TAG_BINDING;
    [self.bindingRequest setNumberOfTimesToRetryOnTimeout:3];
    [self.bindingRequest setTimeOutSeconds:15];
    [self.bindingRequest addRequestHeader:@"X-PID" value:[TEAppDelegate getApplicationDelegate].pid];
    [self.bindingRequest addRequestHeader:@"User-Agent" value:[TEAppDelegate getApplicationDelegate].userAgent];
    [[self networkQueue]addOperation:self.bindingRequest];
}
- (void)doRequest_invitation:(NSDictionary*)params{
    NSString* str_url = [NSString stringWithFormat:@"%@/sns/v1/user/invatation?uid=%@&clientip=%@&requesType=%@&content=%@",@"http://mobile.trafficeye.com.cn:21290/TrafficeyeCommunityService",[params objectForKey:@"uid"],[params objectForKey:@"clientip"],[params objectForKey:@"requestType"],[params objectForKey:@"content"]];
    NSLog(@"邀请url是%@",str_url);
    NSString *encodedString=[str_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL* url = [NSURL URLWithString:encodedString];
    self.invitationRequest =  [ASIHTTPRequest requestWithURL:url];
    self.invitationRequest.tag = TAG_INVITATION;
    [self.invitationRequest setNumberOfTimesToRetryOnTimeout:3];
    [self.invitationRequest setTimeOutSeconds:15];
    [self.invitationRequest addRequestHeader:@"X-PID" value:[TEAppDelegate getApplicationDelegate].pid];
    [self.invitationRequest addRequestHeader:@"User-Agent" value:[TEAppDelegate getApplicationDelegate].userAgent];
    [[self networkQueue]addOperation:self.invitationRequest];
}
- (void)doRequest_messageCount{
    NSString* str_url = [NSString stringWithFormat:@"%@/sns/v1/findNewCount?uid=%@",ENDPOINTS_COM,[[TEAppDelegate getApplicationDelegate] getUid]];
    NSURL* url = [NSURL URLWithString:str_url];
    NSLog(@"消息url是%@",str_url);
    self.messageCountRequest =  [ASIHTTPRequest requestWithURL:url];
    self.messageCountRequest.tag = TAG_MESSAGE_COUNT;
    [self.messageCountRequest setNumberOfTimesToRetryOnTimeout:3];
    [self.messageCountRequest setTimeOutSeconds:15];
    [self.messageCountRequest addRequestHeader:@"X-PID" value:[TEAppDelegate getApplicationDelegate].pid];
    [self.messageCountRequest addRequestHeader:@"User-Agent" value:[TEAppDelegate getApplicationDelegate].userAgent];
    [[self networkQueue]addOperation:self.messageCountRequest];
}
- (void)doRequest_uploadRecord:(NSString*)uploadString{
    NSString* str_url = [NSString stringWithFormat:@"%@/api2/v3/statistics",ENDPOINTS];
    NSURL* url = [NSURL URLWithString:str_url];
    NSLog(@"url is %@",url);
    self.uploadRecordRequest =  [ASIFormDataRequest requestWithURL:url];
    self.uploadRecordRequest.tag = TAG_UPLOAD_RECORD;
    [self.uploadRecordRequest setNumberOfTimesToRetryOnTimeout:3];
    [self.uploadRecordRequest setTimeOutSeconds:15];
    [self.uploadRecordRequest addRequestHeader:@"X-PID" value:[TEAppDelegate getApplicationDelegate].pid];
    [self.uploadRecordRequest addRequestHeader:@"User-Agent" value:[TEAppDelegate getApplicationDelegate].userAgent];
    NSData* unzipData = [uploadString dataUsingEncoding:NSUTF8StringEncoding];
    NSData* zippedData = [ASIDataCompressor compressData:unzipData error:nil];
    [self.uploadRecordRequest appendPostData:zippedData];
    [[self networkQueue]addOperation:self.uploadRecordRequest];
}
- (void)doRequest_logout{
    NSString* str_url = [NSString stringWithFormat:@"%@/user/v3/logout",ENDPOINTS];
    NSURL* url = [NSURL URLWithString:str_url];
    NSLog(@"注销用户url是%@",str_url);
    self.logoutRequest =  [ASIHTTPRequest requestWithURL:url];
    self.logoutRequest.tag = TAG_LOGOUT;
    [self.logoutRequest setNumberOfTimesToRetryOnTimeout:3];
    [self.logoutRequest setTimeOutSeconds:15];
    [self.logoutRequest addRequestHeader:@"X-PID" value:[TEAppDelegate getApplicationDelegate].pid];
    [self.logoutRequest addRequestHeader:@"User-Agent" value:[TEAppDelegate getApplicationDelegate].userAgent];
    [[self networkQueue]addOperation:self.logoutRequest];
}
- (void)doRequest_newShareSNS:(NSString*) type :(NSString*)content :(UIImage *)image{
    NSString* str_url = [NSString stringWithFormat:@"%@/api/v4/share",ENDPOINTS];
    NSLog(@"新分享sns str_url is %@",str_url);
    NSLog(@"参数是type is %@",type);
    NSLog(@"参数是content is %@",content);
    
    NSURL* url = [NSURL URLWithString:str_url];
    self.ShareSNSNewRequest =  [ASIFormDataRequest requestWithURL:url];
    self.ShareSNSNewRequest.tag = TAG_NEW_SHARE_SNS;
    [self.ShareSNSNewRequest setNumberOfTimesToRetryOnTimeout:3];
    [self.ShareSNSNewRequest setPostValue:type forKey:@"type"];
    [self.ShareSNSNewRequest setPostValue:content forKey:@"content"];
    [self.ShareSNSNewRequest setPostValue:[TEAppDelegate getApplicationDelegate].pid forKey:@"pid"];
    [self.ShareSNSNewRequest setPostValue:[TEAppDelegate getApplicationDelegate].userAgent forKey:@"ua"];
    NSData* data_image;
    if(image){
        data_image = UIImageJPEGRepresentation(image, 0.2);
    }else{
        data_image = nil;
    }
    [self.ShareSNSNewRequest addData:data_image forKey:@"media"];
    [[self networkQueue]addOperation:self.ShareSNSNewRequest];
}
- (void)doRequest_ordercar:(NSString*) repStr :(NSString*) carid{
    NSString* str_url = [NSString stringWithFormat:@"%@/vehicleManage/v1/upload",ENDPOINTS];
    NSLog(@"约车url is %@",str_url);
    NSLog(@"上报的字符串%@",repStr);
    NSURL* url = [NSURL URLWithString:str_url];
    self.ordercarRequest =  [ASIFormDataRequest requestWithURL:url];
    self.ordercarRequest.tag = TAG_ORDER_CAR;
    [self.ordercarRequest setNumberOfTimesToRetryOnTimeout:3];
    [self.ordercarRequest addRequestHeader:@"uid" value:[[TEAppDelegate getApplicationDelegate] getUid]];
    [self.ordercarRequest addRequestHeader:@"id" value:carid];
    NSData* unzipData = [repStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* zippedData = [ASIDataCompressor compressData:unzipData error:nil];
    [self.ordercarRequest appendPostData:zippedData];
    [[self networkQueue]addOperation:self.ordercarRequest];
}
//------------公交--------------
- (void)doRequest_smartTip:(NSString*)keyword{
    NSString* str_url = [NSString stringWithFormat:@"http://www.trafficeye.com.cn/fkgis-gateway/TYMON_201404031055/gis/smarttips.json?adcode=110000&searchType=busline&inputstr=%@&t=1396493700164&pageCount=100",keyword];
    NSLog(@"模糊查询url是%@",str_url);
    NSString *encodedString=[str_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL* url = [NSURL URLWithString:encodedString];
    [self.smartTipRequest cancel];
    self.smartTipRequest =  [ASIHTTPRequest requestWithURL:url];
    self.smartTipRequest.tag = TAG_SMART_TIP;
    [self.smartTipRequest setNumberOfTimesToRetryOnTimeout:3];
    [self.smartTipRequest setTimeOutSeconds:15];
    [[self networkQueue]addOperation:self.smartTipRequest];
}
- (void)doRequest_oneLineInfo:(NSString*)keyword{
    NSString* str_url = [NSString stringWithFormat:@"http://www.trafficeye.com.cn/fkgis-gateway/TYMON_201404031056/gis/keyquery.json?adcode=110000&key=%@&searchtype=busline&pageNumber=1&pageCount=10&language=0&t=1396493772685",keyword];
    NSLog(@"一条线路url是%@",str_url);
    NSString *encodedString=[str_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL* url = [NSURL URLWithString:encodedString];
    [self.oneLineInfoRequest cancel];
    self.oneLineInfoRequest =  [ASIHTTPRequest requestWithURL:url];
    self.oneLineInfoRequest.tag = TAG_ONE_LINE_INFO;
    [self.oneLineInfoRequest setNumberOfTimesToRetryOnTimeout:3];
    [self.oneLineInfoRequest setTimeOutSeconds:15];
    [[self networkQueue]addOperation:self.oneLineInfoRequest];
}
- (void)doRequest_oneLineDtail:(NSString*)lineName :(NSString*)station{
    extern NSString* bus_url;
    NSString* str_url = [NSString stringWithFormat:@"%@/RealBusService/getRealBusData?bzcode=123&lineid=%@&stationid=%@&linepointflag=1&citycode=110000",bus_url,lineName,station];
    NSLog(@"一条线路详情url是%@",str_url);
    NSString *encodedString=[str_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL* url = [NSURL URLWithString:encodedString];
    [self.oneLineDetailRequest cancel];
    self.oneLineDetailRequest =  [ASIHTTPRequest requestWithURL:url];
    self.oneLineDetailRequest.tag = TAG_ONE_LINE_DETAIL;
    [self.oneLineDetailRequest setNumberOfTimesToRetryOnTimeout:3];
    [self.oneLineDetailRequest setTimeOutSeconds:15];
    [[self networkQueue]addOperation:self.oneLineDetailRequest];
}
- (void)doRequest_announcement:(int)type{
    NSString* str_url;
    if(type == 1){
        str_url = [NSString stringWithFormat:@"%@/api2/v3/Announcement?pid=%@&type=%i&uid=%@",ENDPOINTS,[TEAppDelegate getApplicationDelegate].pid,type,[[TEAppDelegate getApplicationDelegate] getUid]];
    }else{
        str_url = [NSString stringWithFormat:@"%@/api2/v3/Announcement?pid=%@&type=%i",ENDPOINTS,[TEAppDelegate getApplicationDelegate].pid,type];
    }
    
    NSLog(@"annoucement请求url是%@",str_url);
    NSURL* url = [NSURL URLWithString:str_url];
    self.announcementRequest =  [ASIHTTPRequest requestWithURL:url];
    self.announcementRequest.tag = TAG_ANNOUNCEMENT;
    [self.announcementRequest setNumberOfTimesToRetryOnTimeout:3];
    [self.announcementRequest setTimeOutSeconds:15];
    [[self networkQueue]addOperation:self.announcementRequest];
}
- (void)doRequest_checkUser{
    NSString* uid = [[TEAppDelegate getApplicationDelegate] getUid];
    NSString* str_url = [NSString stringWithFormat:@"%@/user/v4/checkUser?uid=%@",ENDPOINTS,uid];
    NSLog(@"有奖信息调查url is %@",str_url);
    NSURL* url = [NSURL URLWithString:str_url];
    self.checkUserRequest =  [ASIHTTPRequest requestWithURL:url];
    self.checkUserRequest.tag = TAG_CHECK_USER;
    [self.checkUserRequest setNumberOfTimesToRetryOnTimeout:3];
    [self.checkUserRequest setTimeOutSeconds:15];
    [[self networkQueue]addOperation:self.checkUserRequest];
}
- (void)doRequest_findPoi:(double)longitude :(double) latitude{
//    NSString* str_url = [NSString stringWithFormat:@"%@/api/carpool/v1/findPoi?point=%f,%f&pid=%@&uid=%@",ENDPOINTS,longitude,latitude,[TEAppDelegate getApplicationDelegate].pid,uid];
    NSString* str_url = [NSString stringWithFormat:@"http://api.map.baidu.com/geocoder/v2/?ak=6df513102982a7dd662557aef4604401&coordtype=gcj02ll&location=%f,%f&output=json&pois=1",latitude,longitude];
    NSLog(@"查询poiurl is %@",str_url);
    NSURL* url = [NSURL URLWithString:str_url];
    self.findPoiRequest =  [ASIHTTPRequest requestWithURL:url];
    self.findPoiRequest.tag = TAG_FIND_POI;
    [self.findPoiRequest setNumberOfTimesToRetryOnTimeout:3];
    [self.findPoiRequest setTimeOutSeconds:15];
    [[self networkQueue]addOperation:self.findPoiRequest];
}
- (void)doRequest_routeDrive:(NSString*)sLon :(NSString*) sLat :(NSString*) eLon :(NSString*) eLat{
    int slon_int = [sLon doubleValue]*460800;
    int slat_int = [sLat doubleValue]*460800;
    int eLon_int = [eLon doubleValue]*460800;
    int eLat_int = [eLat doubleValue]*460800;
    NSString* str_url = [NSString stringWithFormat:@"http://www.trafficeye.com.cn/fkgis-gateway/ere/gis/routequery/routequery.json?point=0,%i,%i,0,%i,%i&shpflag=5&costModel=1",slon_int,slat_int,eLon_int,eLat_int];
    NSLog(@"驾车url is %@",str_url);
    NSURL* url = [NSURL URLWithString:str_url];
    self.routeDriveRequest =  [ASIHTTPRequest requestWithURL:url];
    self.routeDriveRequest.tag = TAG_ROUTE_DRIVE;
    [self.routeDriveRequest setNumberOfTimesToRetryOnTimeout:3];
    [self.routeDriveRequest setTimeOutSeconds:15];
    [[self networkQueue]addOperation:self.routeDriveRequest];
}
- (void)doRequest_routeWalk:(NSString*)sLon :(NSString*) sLat :(NSString*) eLon :(NSString*) eLat{
    int slon_int = [sLon doubleValue]*460800;
    int slat_int = [sLat doubleValue]*460800;
    int eLon_int = [eLon doubleValue]*460800;
    int eLat_int = [eLat doubleValue]*460800;
    NSString* str_url = [NSString stringWithFormat:@"http://www.trafficeye.com.cn/fkgis-gateway/ere/gis/walkquery/walkquery.json?coordsequence=%i,%i,%i,%i&retflag=1",slon_int,slat_int,eLon_int,eLat_int];
    NSLog(@"步行url is %@",str_url);
    NSURL* url = [NSURL URLWithString:str_url];
    self.routeWalkRequest =  [ASIHTTPRequest requestWithURL:url];
    self.routeWalkRequest.tag = TAG_ROUTE_WALK;
    [self.routeWalkRequest setNumberOfTimesToRetryOnTimeout:3];
    [self.routeWalkRequest setTimeOutSeconds:15];
    [[self networkQueue]addOperation:self.routeWalkRequest];
}

#pragma mark - alertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex)
    {
        NSLog(@"点击第一个按钮");
        int targetpage = -1;
        switch (self.target) {
            case -1:
                break;
            case 0:
                targetpage = INDEX_PAGE_MAP;
                break;
            case 1:
                targetpage = INDEX_PAGE_SIGRA;
                break;
            case 2:
                targetpage = INDEX_PAGE_SETTING;
                break;
            case 3:
                targetpage = INDEX_PAGE_TAXI;
                break;
            case 4:
                targetpage = INDEX_PAGE_USER;
                break;
            case 5:
                targetpage = INDEX_PAGE_WEIBO;
                break;
            case 6:
                targetpage = INDEX_PAGE_NEWS;
                break;
            case 7:
                targetpage = INDEX_PAGE_INDEX;
                break;
            case 8:
                targetpage = INDEX_PAGE_SURVEY;
                break;
            default:
                break;
        }
        if(targetpage == -1)return;
        NSArray* array = [TEAppDelegate getApplicationDelegate].navControllers;
        DDMenuController *menuController = [TEAppDelegate getApplicationDelegate].menuController;
        [menuController setRootController:[array objectAtIndex:targetpage] animated:YES];
        
        
    }else if (1 == buttonIndex){
        NSLog(@"点击第二个按钮");
    }
}
////获得奖励后更新个人资料
//- (void)updateUserInfoDicByReward:(NSDictionary*)rewardDic{
//    id id_arrayBadge = [rewardDic valueForKey:@"badge"];
//    if (nil != id_arrayBadge && [NSNull null] != id_arrayBadge && [id_arrayBadge isKindOfClass:[NSArray class]]){
//        for(int i = 0;i<[id_arrayBadge count];i++){
//            NSDictionary* oneBadgeDic = [id_arrayBadge objectAtIndex:i];
//            NSNumber *num = [NSNumber numberWithInt:[[oneBadgeDic objectForKey:@"id"]intValue]];
//            [[TEAppDelegate getApplicationDelegate].hasBadges addObject:num];
//        }
//    }
//    //将积分、里程、贡献里程等更新
//    NSNumber* points = [NSNumber numberWithInt:[[rewardDic objectForKey:@"total_points"] intValue]];
//    [[TEAppDelegate getApplicationDelegate].userInfoDictionary setObject:points forKey:@"points"];
//    NSNumber* total_miles = [NSNumber numberWithInt:[[rewardDic objectForKey:@"total_miles"] intValue]];
//    [[TEAppDelegate getApplicationDelegate].userInfoDictionary setObject:total_miles forKey:@"drive_miles"];
//    NSNumber* total_trackMiles = [NSNumber numberWithInt:[[rewardDic objectForKey:@"total_trackMiles"] intValue]];
//    [[TEAppDelegate getApplicationDelegate].userInfoDictionary setObject:total_trackMiles forKey:@"track_miles"];
//    NSNumber* event_num = [NSNumber numberWithInt:[[rewardDic objectForKey:@"event_num"] intValue]];
//    [[TEAppDelegate getApplicationDelegate].userInfoDictionary setObject:event_num forKey:@"event_num"];
//}
@end
