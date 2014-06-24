//
//  TENetworkHandler.h
//  NetworkDemo
//
//  Created by 张 驰 on 13-7-24.
//  Copyright (c) 2013年 张 驰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASINetworkQueue.h"
#import "ASIFormDataRequest.h"
@protocol loginDelegate <NSObject>
//登录接口成功或者失败的协议，如果失败了会有原因mes
- (void)loginDidSuccess:(NSDictionary*)rewardDic;
- (void)loginDidFailed:(NSString*)mes;
@end
@protocol registerDelegate <NSObject>
//登录接口成功或者失败的协议，如果失败了会有原因mes
- (void)registerDidSuccess:(NSDictionary*)rewardDic;
- (void)registerDidFailed:(NSString*)mes;
@end
@protocol autoLoginDelegate <NSObject>
//自动登录协议
- (void)autoLoginDidSuccess:(NSDictionary*)rewardDic;
- (void)autoLoginDidFailed:(NSString*)mes;
@end
@protocol UserAvatarUploadDelegate <NSObject>
//用户上传头像协议
- (void)userAvatarUploadDidSuccess:(NSDictionary*)rewardDic;
- (void)userAvatarUploadDidFailed:(NSString*)mes;
@end
@protocol UserUpdateUserInfoDelegate <NSObject>
//用户修改个人资料
- (void)userUpdateUserInfoDidSuccess:(NSDictionary*)rewardDic;
- (void)userUpdateUserInfoDidFailed:(NSString*)mes;
@end
@protocol UserPointsDetailDelegate <NSObject>
//请求积分详情
- (void)userPointsDetailDidSuccess:(NSDictionary*)dic;
- (void)userPointsDetailDidFailed:(NSString*)mes;
@end
@protocol UserDistanceDetailDelegate <NSObject>
//请求里程详情
- (void)userDistanceDetailDidSuccess:(NSDictionary*)dic;
- (void)userDistanceDetailDidFailed:(NSString*)mes;
@end
@protocol UserEventDetailDelegate <NSObject>
//请求事件详情
- (void)userEventDetailDidSuccess:(NSDictionary*)dic;
- (void)userEventDetailDidFailed:(NSString*)mes;
@end
@protocol UserForgetPasswordDelegate <NSObject>
//忘记密码
- (void)userForgetPasswordDidSuccess:(NSDictionary*)dic;
- (void)userForgetPasswordDidFailed:(NSString*)mes;
@end
@protocol UserEditPasswordDelegate <NSObject>
//修改密码
- (void)userEditPasswordDidSuccess:(NSDictionary*)dic;
- (void)userEditPasswordDidFailed:(NSString*)mes;
@end
@protocol ReportEventDelegate <NSObject>
//上报事件
- (void)reportEventDidSuccess:(NSDictionary*)rewardDic;
- (void)reportEventDidFailed:(NSString*)mes;
@end
@protocol getTrackDelegate <NSObject>
//请求轨迹
- (void)getTrackDidSuccess:(NSArray*)array;
- (void)getTrackDidFailed:(NSString*)mes;
@end
@protocol getEventDelegate <NSObject>
- (void)getEventDidSuccess:(NSArray*)array;
- (void)getEventDidFailed:(NSString*)mes;
@end
@protocol eventDetailDelegate <NSObject>
- (void)eventDetailDidSuccess:(NSDictionary*)dic;
- (void)eventDetailDidFailed:(NSString*)mes;
@end
@protocol optionDelegate <NSObject>
- (void)optionDidSuccess:(NSDictionary*)dic;
- (void)optionDidFailed:(NSString*)mes;
@end
@protocol taxiIndexDelegate <NSObject>
- (void)taxiIndexDidSuccess:(NSDictionary*)dic;
- (void)taxiIndexDidFailed:(NSString*)mes;
@end
@protocol taxiEasyDelegate <NSObject>
- (void)taxiEasyDidSuccess:(NSDictionary*)dic;
- (void)taxiEasyDidFailed:(NSString*)mes;
@end
@protocol taxiLongPressDelegate <NSObject>
- (void)taxiLongPressDidSuccess:(NSDictionary*)dic;
- (void)taxiLongPressDidFailed:(NSString*)mes;
@end
@protocol snsLoginDelegate <NSObject>
- (void)snsLoginDidSuccess:(NSDictionary*)dic;
- (void)snsLoginDidFailed:(NSString*)mes;
@end
@protocol uploadUserSettingDelegate <NSObject>
- (void)uploadUserSettingDidSuccess:(NSDictionary*)dic;
- (void)uploadUserSettingDidFailed:(NSString*)mes;
@end
@protocol limitNumDelegate <NSObject>
- (void)limitNumDidSuccess:(NSString*)limitStr;
- (void)limitNumDidFailed:(NSString*)mes;
@end
@protocol snsShareDelegate <NSObject>
- (void)snsShareDidSuccess:(NSDictionary*)dic;
- (void)snsShareDidFailed:(NSString*)mes;
@end
@protocol downloadUserSettingDelegate <NSObject>
- (void)downloadUserSettingDidSuccess:(NSDictionary*)dic;
- (void)downloadUserSettingDidFailed:(NSString*)mes;
@end
@protocol uploadLocationDelegate <NSObject>
- (void)uploadLocationDidSuccess:(NSDictionary*)dic;
- (void)uploadLocationDidFailed:(NSString*)mes;
@end
@protocol registerPushDelegate <NSObject>
- (void)registerPushDidSuccess:(NSDictionary*)dic;
- (void)registerPushDidFailed:(NSString*)mes;
@end
//设置推送城市
@protocol pushSettingDelegate <NSObject>
- (void)pushSettingDidSuccess:(NSDictionary*)dic;
- (void)pushSettingDidFailed:(NSString*)mes;
@end
//社区查找好友
@protocol lookupFriendsDelegate <NSObject>
- (void)lookupFriendsDidSuccess:(NSString*)result;
- (void)lookupFriendsDidFailed:(NSString*)mes;
@end
//社区绑定
@protocol bindingDelegate <NSObject>
- (void)bindingDidSuccess:(NSString*)result;
- (void)bindingDidFailed:(NSString*)mes;
@end
//社区邀请
@protocol invitationDelegate <NSObject>
- (void)invitationDidSuccess:(NSString*)result;
- (void)invitationDidFailed:(NSString*)mes;
@end
//社区查询消息数量
@protocol messageCountDelegate <NSObject>
- (void)messageCountDidSuccess:(NSDictionary*)dic;
- (void)messageCountDidFailed:(NSString*)mes;
@end
//上报用户使用记录
@protocol uploadRecordDelegate <NSObject>
- (void)uploadRecordDidSuccess:(NSDictionary*)dic;
- (void)uploadRecordDidFailed:(NSString*)mes;
@end
//注销用户
@protocol logoutDelegate <NSObject>
- (void)logoutDidSuccess:(NSDictionary*)dic;
- (void)logoutDidFailed:(NSString*)mes;
@end

//新的微博通知接口，分享之后可以同步到时间线
@protocol shareSNSNewDelegate <NSObject>
- (void)ShareSNSNewDidSuccess:(NSDictionary*)dic;
- (void)ShareSNSNewDidFailed:(NSString*)mes;
@end

//新的微博通知接口，分享之后可以同步到时间线
@protocol OrdercarDelegate <NSObject>
- (void)OrdercarDidSuccess:(NSString*)result;
- (void)OrdercarDidFailed:(NSString*)mes;
@end

//-------------------公交---------------------
@protocol SmartTipDelegate <NSObject>
- (void)smartTipDidSuccess:(NSArray*)lineNOs;
- (void)smartTipDidFailed;
@end
@protocol OneLineInfoDelegate <NSObject>
- (void)oneLineInfoDidSuccess:(NSDictionary *)busInfo;
- (void)oneLineInfoDidFailed;
@end
@protocol OneLineDetailDelegate <NSObject>
- (void)oneLineDetailDidSuccess:(NSDictionary *)busInfo;
- (void)oneLineDetailDidFailed;
@end
@protocol AnnouncementDelegate <NSObject>
- (void)announcementDidSuccess:(NSDictionary *)dic;
- (void)announcementDidFailed;
@end
@protocol CheckUserDelegate <NSObject>
- (void)checkUserDidSuccess:(NSDictionary *)dic;
- (void)checkUserDidFailed;
@end

@protocol FindPoiDelegate <NSObject>
- (void)findPoiDidSuccess:(NSDictionary *)dic;
- (void)findPoiDidFailed:(NSString*)mes;
@end
@protocol routeDriveDelegate <NSObject>
- (void)routeDriveDidSuccess:(NSDictionary *)dic;
- (void)routeDriveDidFailed:(NSString*)mes;
@end
@protocol routeWalkDelegate <NSObject>
- (void)routeWalkDidSuccess:(NSDictionary *)dic;
- (void)routeWalkDidFailed:(NSString*)mes;
@end





@interface TENetworkHandler : NSObject<UIAlertViewDelegate>
@property (nonatomic, strong) ASINetworkQueue* networkQueue;
@property (strong, nonatomic) NSMutableDictionary* myRewardDic;
@property (assign, nonatomic) int target;
//定义各种请求的delegate
@property (nonatomic, strong) id<loginDelegate> delegate_login;
@property (nonatomic, strong) id<registerDelegate> delegate_register;
@property (nonatomic, strong) id<autoLoginDelegate> delegate_autoLogin;
@property (nonatomic, strong) id<UserAvatarUploadDelegate> delegate_userAvatarUpload;
@property (nonatomic, strong) id<UserUpdateUserInfoDelegate> delegate_userUpdateUserInfo;
@property (nonatomic, strong) id<UserPointsDetailDelegate> delegate_userPointsDetail;
@property (nonatomic, strong) id<UserDistanceDetailDelegate> delegate_userdistanceDetail;
@property (nonatomic, strong) id<UserEventDetailDelegate> delegate_userEventDetail;
@property (nonatomic, strong) id<UserForgetPasswordDelegate> delegate_userForgetPassword;
@property (nonatomic, strong) id<UserEditPasswordDelegate> delegate_userEditPassword;
@property (nonatomic, strong) id<ReportEventDelegate> delegate_reportEvent;
@property (nonatomic, strong) id<getTrackDelegate> delegate_getTrack;
@property (nonatomic, strong) id<getEventDelegate> delegate_getEvent;
@property (nonatomic, strong) id<eventDetailDelegate> delegate_eventDetail;
@property (nonatomic, strong) id<optionDelegate> delegate_option;
@property (nonatomic, strong) id<taxiIndexDelegate> delegate_taxiIndex;
@property (nonatomic, strong) id<taxiEasyDelegate> delegate_taxiEasy;
@property (nonatomic, strong) id<taxiLongPressDelegate> delegate_taxiLongPress;
@property (nonatomic, strong) id<snsLoginDelegate> delegate_snsLogin;
@property (nonatomic, strong) id<uploadUserSettingDelegate> delegate_uploadUserSetting;
@property (nonatomic, strong) id<limitNumDelegate> delegate_limitNum;
@property (nonatomic, strong) id<snsShareDelegate> delegate_snsShare;
@property (nonatomic, strong) id<downloadUserSettingDelegate> delegate_downloadUserSetting;
@property (nonatomic, strong) id<uploadLocationDelegate> delegate_uploadLocation;
@property (nonatomic, strong) id<registerPushDelegate> delegate_registerPush;
@property (nonatomic, strong) id<pushSettingDelegate> delegate_pushSetting;
@property (nonatomic, strong) id<lookupFriendsDelegate> delegate_lookupFriends;
@property (nonatomic, strong) id<bindingDelegate> delegate_bingding;
@property (nonatomic, strong) id<invitationDelegate> delegate_invitation;
@property (nonatomic, strong) id<messageCountDelegate> delegate_messageCount;
@property (nonatomic, strong) id<uploadRecordDelegate> delegate_uploadRecord;
@property (nonatomic, strong) id<logoutDelegate> delegate_logout;
@property (nonatomic, strong) id<shareSNSNewDelegate> delegate_newShareSNS;
@property (nonatomic, strong) id<OrdercarDelegate> delegate_ordercar;
@property (nonatomic, strong) id<AnnouncementDelegate> delegate_announcement;
@property (nonatomic, strong) id<CheckUserDelegate> delegate_checkUser;
@property (nonatomic, strong) id<FindPoiDelegate> delegate_findPoi;
@property (nonatomic, strong) id<routeDriveDelegate> delegate_routeDrive;
@property (nonatomic, strong) id<routeWalkDelegate> delegate_routeWalk;


//定义每个请求的request
@property (nonatomic, strong) ASIHTTPRequest* loginRequest;
@property (nonatomic, strong) ASIFormDataRequest* registerRequest;
@property (nonatomic, strong) ASIFormDataRequest* autoLoginRequest;
@property (nonatomic, strong) ASIFormDataRequest* userAvatarUploadRequest;
@property (nonatomic, strong) ASIFormDataRequest* userUpdateUserInfoRequest;
@property (nonatomic, strong) ASIFormDataRequest* userPointsDetailRequest;
@property (nonatomic, strong) ASIFormDataRequest* userDistanceDetailRequest;
@property (nonatomic, strong) ASIFormDataRequest* userEventDetailRequest;
@property (nonatomic, strong) ASIFormDataRequest* userForgetPasswordRequest;
@property (nonatomic, strong) ASIFormDataRequest* userEditPasswordRequest;
@property (nonatomic, strong) ASIFormDataRequest* reportEventRequest;
@property (nonatomic, strong) ASIHTTPRequest* getTrackRequest;
@property (nonatomic, strong) ASIFormDataRequest* getEventRequest;
@property (nonatomic, strong) ASIFormDataRequest* eventDetailRequest;
@property (nonatomic, strong) ASIFormDataRequest* optionRequest;
@property (nonatomic, strong) ASIHTTPRequest* taxiIndexRequest;
@property (nonatomic, strong) ASIHTTPRequest* taxiEasyRequest;
@property (nonatomic, strong) ASIHTTPRequest* taxiLongPressRequest;
@property (nonatomic, strong) ASIFormDataRequest* snsLoginRequest;
@property (nonatomic, strong) ASIFormDataRequest* uploadUserSettingRequest;
@property (nonatomic, strong) ASIHTTPRequest* limitNumRequest;
@property (nonatomic, strong) ASIHTTPRequest* snsShareRequest;
@property (nonatomic, strong) ASIHTTPRequest* downloadUserSettingRequest;
@property (nonatomic, strong) ASIFormDataRequest* uploadLocationRequest;
@property (nonatomic, strong) ASIFormDataRequest* registerPushRequest;
@property (nonatomic, strong) ASIFormDataRequest* pushSettingRequest;
@property (nonatomic, strong) ASIHTTPRequest* lookupFriendsRequest;
@property (nonatomic, strong) ASIHTTPRequest* bindingRequest;
@property (nonatomic, strong) ASIHTTPRequest* invitationRequest;
@property (nonatomic, strong) ASIHTTPRequest* messageCountRequest;
@property (nonatomic, strong) ASIFormDataRequest* uploadRecordRequest;
@property (nonatomic, strong) ASIHTTPRequest* logoutRequest;
@property (nonatomic, strong) ASIFormDataRequest* ShareSNSNewRequest;
@property (nonatomic, strong) ASIFormDataRequest* ordercarRequest;
@property (nonatomic, strong) ASIHTTPRequest* announcementRequest;
@property (nonatomic, strong) ASIHTTPRequest* checkUserRequest;
@property (nonatomic, strong) ASIHTTPRequest* findPoiRequest;
@property (nonatomic, strong) ASIHTTPRequest* routeDriveRequest;
@property (nonatomic, strong) ASIHTTPRequest* routeWalkRequest;


//定义这个变量完全是因为在ARC项目使用ASIHTTPRequest会导致EXC_BAD_ACCESS错误，加上之后保证不被释放，从而解决错误
//@property (nonatomic, strong) TENetworkHandler* handler;
- (void)doRequest_login:(NSDictionary*)params;
- (void)doRequest_register:(NSDictionary*)params;
- (void)doRequest_autoLogin;
- (void)doRequest_userAvatarUpload:(NSDictionary*)params;
- (void)doRequest_userUpdateUserInfo:(NSDictionary*)params;
- (void)doRequest_userPointsDetail:(NSDictionary*)params;
- (void)doRequest_userDistanceDetail:(NSDictionary*)params;
- (void)doRequest_userEventDetail:(NSDictionary*)params;
- (void)doRequest_userForgetPassword:(NSDictionary*)params;
- (void)doRequest_userEditPassword:(NSDictionary*)params;
- (void)doRequest_reportEvent:(NSDictionary*)params :(UIImage*)eventImage;
- (void)doRequest_getTrackWithLatitude:(double)latitude Longitude:(double)longitude Level:(int)zoomLevel;
- (void)doRequest_getEventWithLatitude:(double)latitude Longitude:(double)longitude Level:(int)zoomLevel;
- (void)doRequest_eventDetail:(int)eventid :(NSString*)type;
- (void)doRequest_Option:(NSDictionary*)params;
- (void)doRequest_taxiIndex:(double)latitude longitude:(double)longitude;
- (void)doRequest_taxiEasy:(double)latitude longitude:(double)longitude;
- (void)doRequest_taxiLongPress:(double)latitude longitude:(double)longitude;
- (void)doRequest_snsLogin:(NSDictionary*)params;
- (void)doRequest_uploadUserSetting:(NSString*)type :(NSString*)settingStr;
- (void)doRequest_limitNum;
- (void)doRequest_snsShare:(NSString*)type;
- (void)doRequest_downloadUserSetting;
- (void)doRequest_uploadLocation:(NSString*)uploadString;
- (void)doRequest_registerPush:(NSString*)token :(NSString*)cityName;
- (void)doRequest_pushSetting:(NSString*)isPush :(NSString*)cityName;
- (void)doRequest_lookupFriends:(NSDictionary*)params;
- (void)doRequest_binding:(NSDictionary*)params;
- (void)doRequest_invitation:(NSDictionary*)params;
- (void)doRequest_messageCount;
- (void)doRequest_uploadRecord:(NSString*)uploadString;
- (void)doRequest_logout;
- (void)doRequest_newShareSNS:(NSString*) type :(NSString*)content :(UIImage*) image;
- (void)doRequest_ordercar:(NSString*) repStr :(NSString*) carid;
- (void)doRequest_announcement:(int)type;
- (void)doRequest_checkUser;
- (void)doRequest_findPoi:(double)longitude :(double) latitude;
- (void)doRequest_routeDrive:(NSString*)sLon :(NSString*) sLat :(NSString*) eLon :(NSString*) eLat;
- (void)doRequest_routeWalk:(NSString*)sLon :(NSString*) sLat :(NSString*) eLon :(NSString*) eLat;

- (void)startQueue;

//-----------------公交------------------
@property (nonatomic, strong) id<SmartTipDelegate> delegate_smartTip;
@property (nonatomic, strong) id<OneLineInfoDelegate> delegate_oneLineInfo;
@property (nonatomic, strong) id<OneLineDetailDelegate> delegate_oneLineDetail;


@property (nonatomic, strong) ASIHTTPRequest* smartTipRequest;
@property (nonatomic, strong) ASIHTTPRequest* oneLineInfoRequest;
@property (nonatomic, strong) ASIHTTPRequest* oneLineDetailRequest;

- (void)doRequest_smartTip:(NSString*)keyword;
- (void)doRequest_oneLineInfo:(NSString*)keyword;
- (void)doRequest_oneLineDtail:(NSString*)lineName :(NSString*)station;


@end
