//
//  TEWebLevel1ViewController.m
//  Trafficeye_new
//
//  Created by zc on 14-5-26.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import "TEWebLevel1ViewController.h"
#import "SBJson.h"
#import "TEPersistenceHandler.h"
#import "TERewardViewController.h"
#import "TETimeLineViewController.h"
#import "UIImage+Rescale.h"
#import <ShareSDK/ShareSDK.h>
#import "TEShareCarServiceViewController.h"
#import "TEPointInMapViewController.h"
#import "TERouteMapViewController.h"

@interface TEWebLevel1ViewController ()

@end

@implementation TEWebLevel1ViewController
@synthesize entryHTML;
@synthesize jsonParam;
@synthesize avatarPicker;
@synthesize pageLevel;
@synthesize isfirst;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.isfirst = YES;
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
    NSString *path = [[NSBundle mainBundle] pathForResource:self.entryHTML ofType:@"html"];
    NSURL* url = [NSURL fileURLWithPath:path];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    self.webview.scalesPageToFit = YES;
    self.webview.delegate = self;
    [self.webview setBackgroundColor:[UIColor clearColor]];
    [self.webview loadRequest:request];
    if(self.pageLevel == 2){
        CGRect newFrame = self.webview.frame;
        newFrame.size = CGSizeMake(320, newFrame.size.height+45);
        self.webview.frame = newFrame;
    }
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(self.pageLevel == 2){
        self.view_toolbar.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    if(isfirst){
        isfirst = NO;
        //公共参数：
        int isLogin = [TEAppDelegate getApplicationDelegate].isLogin;
        NSString* userInfoJSON = [TEAppDelegate getUserInfoJSON];
        NSString* ua = [TEAppDelegate getApplicationDelegate].userAgent;
        NSString* pid = [TEAppDelegate getApplicationDelegate].pid;
        NSString* userInfoJSONConvert = [userInfoJSON stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
        NSString* currentURL = webView.request.URL.absoluteString;
        if([self.entryHTML isEqualToString:@"pcar_index"]&&([currentURL hasSuffix:@"Trafficeye_new.app/"]||[currentURL hasSuffix:@"/pcar_index.html"])){
            CLLocationCoordinate2D coordinate = [[[TEAppDelegate getApplicationDelegate].mapview_app userLocation] coordinate];
            self.jsonParam = [NSString stringWithFormat:@"'{\\\"lon\\\":\\\"%f\\\",\\\"lat\\\":\\\"%f\\\"}'",coordinate.longitude,coordinate.latitude];
            NSString *jsparam = [NSString stringWithFormat:@"window.callbackInitPage(%i,'%@','%@','%@',%@)",isLogin,userInfoJSONConvert,ua,pid,self.jsonParam];
            [self jsCallbackMethod:jsparam];
        }else if([self.entryHTML isEqualToString:@"poiselect"]&&([currentURL hasSuffix:@"Trafficeye_new.app/"]||[currentURL hasSuffix:@"/poiselect.html"])){
            CLLocationCoordinate2D coordinate = [[[TEAppDelegate getApplicationDelegate].mapview_app userLocation] coordinate];
            self.jsonParam = [NSString stringWithFormat:@"'{\\\"lon\\\":\\\"%f\\\",\\\"lat\\\":\\\"%f\\\"}'",coordinate.longitude,coordinate.latitude];
            NSString *jsparam = [NSString stringWithFormat:@"window.callbackInitSearchPage(%i,'%@','%@','%@',%@)",isLogin,userInfoJSONConvert,ua,pid,self.jsonParam];
            [self jsCallbackMethod:jsparam];
        }
        else if([self.entryHTML isEqualToString:@"bus_index"]&&([currentURL hasSuffix:@"Trafficeye_new.app/"]||[currentURL hasSuffix:@"/bus_index.html"])){
            CLLocationCoordinate2D coordinate = [[[TEAppDelegate getApplicationDelegate].mapview_app userLocation] coordinate];
            self.jsonParam = [NSString stringWithFormat:@"'{\\\"lon\\\":\\\"%f\\\",\\\"lat\\\":\\\"%f\\\"}'",coordinate.longitude,coordinate.latitude];
            NSString *jsparam = [NSString stringWithFormat:@"window.callbackInitSettingStartEndPage(%i,'%@','%@','%@',%@)",isLogin,userInfoJSONConvert,ua,pid,self.jsonParam];
            [self jsCallbackMethod:jsparam];
        }
    }
    
}
//js回调
- (void)jsCallbackMethod:(NSString*)param{
    NSLog(@"----callbackjs----param is %@",param);
    [self.webview stringByEvaluatingJavaScriptFromString:param];
}
//js调用本地方法
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *requestURL = [request URL];
    if ( ( [ [ requestURL scheme ] isEqualToString: @"http" ] || [ [ requestURL scheme ] isEqualToString: @"https" ] || [ [ requestURL scheme ] isEqualToString: @"mailto" ])
        && ( navigationType == UIWebViewNavigationTypeLinkClicked ) ) {
        return ![ [ UIApplication sharedApplication ] openURL: requestURL];
    }
    
    NSString *urlString = [[request URL] absoluteString];
    NSLog(@"urlString is %@",urlString);
    
    NSArray *urlComps = [urlString componentsSeparatedByString:@":??"];
    
    if([urlComps count] && [[urlComps objectAtIndex:0] isEqualToString:@"objc"])
    {
        NSArray *arrFucnameAndParameter = [(NSString*)[urlComps objectAtIndex:1] componentsSeparatedByString:@":?"];
        NSString *funcStr = [arrFucnameAndParameter objectAtIndex:0];
        
        if (1 == [arrFucnameAndParameter count])
        {
            // 没有参数
            if([funcStr isEqualToString:@"getUserInfo"])
            {
                /*调用本地函数1*/
                NSString* userInfoJSON = [TEAppDelegate getUserInfoJSON];
                NSString* userInfoJSONConvert = [userInfoJSON stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
                NSString *param = [NSString stringWithFormat:@"window.callbackGetUserInfo('%@')",userInfoJSONConvert];
                NSLog(@"----callbackGetUserInfo----param is %@",param);
                [self jsCallbackMethod:param];
                
            }
            if([funcStr isEqualToString:@"setUserAvatar"])
            {
                UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"选取来自" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"用户相册", nil];
                [actionSheet showInView:self.view];
            }
            if([funcStr isEqualToString:@"closeThisPage"])
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
            if([funcStr isEqualToString:@"gotoServicePage"])
            {
                TEShareCarServiceViewController* sharecarserviceVC = [[TEShareCarServiceViewController alloc]init];
                [self.navigationController pushViewController:sharecarserviceVC animated:YES];
            }
            if([funcStr isEqualToString:@"routeCloseThisPage"])
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        
        else
        {
            if([funcStr isEqualToString:@"showAlert:"])
            {
                NSString *str1 = [arrFucnameAndParameter objectAtIndex:1];
                NSString *encode_str = [TEUtil URLDecode:[TEUtil URLDecode:str1]];
                NSLog(@"encode_str is %@",encode_str);
                UIAlertView* alert =[[UIAlertView alloc] initWithTitle:nil message:encode_str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            if([funcStr isEqualToString:@"makeACall:"])
            {
                NSString *str1 = [arrFucnameAndParameter objectAtIndex:1];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",str1]]];
            }
            if([funcStr isEqualToString:@"chooseLocation:"])
            {
                NSString *str1 = [arrFucnameAndParameter objectAtIndex:1];
                TEShareCarViewController* sharecarVC = [[TEShareCarViewController alloc]init];
                sharecarVC.type = str1;
                sharecarVC.delegate_chooseLocation = self;
                [self.navigationController pushViewController:sharecarVC animated:YES];
            }
            //有参数的
            if([funcStr isEqualToString:@"getSNSUserInfo:"])
            {
                NSString *str1 = [arrFucnameAndParameter objectAtIndex:1];
                NSLog(@"----getSNSUserInfo----str1 is %@",str1);
                [self getSNSUserInfo:str1];
            }
            if([funcStr isEqualToString:@"updateUserInfo:"])
            {
                NSString *str1 = [arrFucnameAndParameter objectAtIndex:1];
                NSString *userInfoJson = [TEUtil URLDecode:[TEUtil URLDecode:str1]];
                NSLog(@"----updateUserInfo----userInfoJson is %@",userInfoJson);
                [self updateUserInfo:userInfoJson];
                
                NSString *str2 = [arrFucnameAndParameter objectAtIndex:2];
                NSString *rewardJSON = [TEUtil URLDecode:[TEUtil URLDecode:str2]];
                NSLog(@"----updateUserInfo----rewardJSON is %@",rewardJSON);
                
                [self popupRewardWindow:rewardJSON];
                
            }
            if([funcStr isEqualToString:@"loginNotify:"])
            {
                NSString *str1 = [arrFucnameAndParameter objectAtIndex:1];
                NSString *str2 = [arrFucnameAndParameter objectAtIndex:2];
                
                NSLog(@"----loginNotify----str1 is %@",str1);
                NSLog(@"----loginNotify----str2 is %@",str2);
                NSString* filePath = [TEPersistenceHandler getDocument:@"userLogin.plist"];
                NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
                if(!dic){
                    dic = [[NSMutableDictionary alloc]init];
                }
                [dic setObject:@"1" forKey:@"needLogin"];
                [dic setObject:str1 forKey:@"email"];
                [dic setObject:str2 forKey:@"passwd"];
                [dic writeToFile:filePath atomically:YES];
                
                NSString *str3 = [arrFucnameAndParameter objectAtIndex:3];
                NSString *userInfoJson = [TEUtil URLDecode:[TEUtil URLDecode:str3]];
                NSLog(@"----loginNotify----userInfoJson is %@",userInfoJson);
                //                [self updateUserInfo:userInfoJson];
                [[TEAppDelegate getApplicationDelegate].networkHandler doRequest_downloadUserSetting];
                SBJsonParser *jsonParser = [[SBJsonParser alloc]init];
                NSMutableDictionary* result = [jsonParser objectWithString:userInfoJson];
                [TEAppDelegate getApplicationDelegate].userInfoDictionary = result;
                [TEAppDelegate getApplicationDelegate].isLogin = 1;
                [[TEAppDelegate getApplicationDelegate].networkHandler doRequest_announcement:1];
                
                NSString *str4 = [arrFucnameAndParameter objectAtIndex:4];
                NSString *rewardJSON = [TEUtil URLDecode:[TEUtil URLDecode:str4]];
                NSLog(@"----loginNotify----rewardJSON is %@",rewardJSON);
                [self popupRewardWindow:rewardJSON];
            }
            if([funcStr isEqualToString:@"gotoCommunity:"]){
                NSString *pageName = [arrFucnameAndParameter objectAtIndex:1];
                NSString *str2 = [arrFucnameAndParameter objectAtIndex:2];
                NSString *param = [TEUtil URLDecode:[TEUtil URLDecode:str2]];
                NSLog(@"----gotoCommunity----pageName is %@",pageName);
                NSLog(@"----gotoCommunity----param is %@",param);
                TETimeLineViewController* timelineVC = [[TETimeLineViewController alloc]init];
                timelineVC.pageName = pageName;
                timelineVC.goto_param = param;
                [self.navigationController pushViewController:timelineVC animated:YES];
            }
            if([funcStr isEqualToString:@"displayPointInMap:"]){
                NSString* lon = [arrFucnameAndParameter objectAtIndex:1];
                NSString* lat = [arrFucnameAndParameter objectAtIndex:2];
                NSString* locationName = [TEUtil URLDecode:[TEUtil URLDecode:[arrFucnameAndParameter objectAtIndex:3]]];
                NSString* addr = [TEUtil URLDecode:[TEUtil URLDecode:[arrFucnameAndParameter objectAtIndex:4]]];
                NSString* type = [arrFucnameAndParameter objectAtIndex:5];
                NSLog(@"----displayPointInMap----lon is %@",lon);
                NSLog(@"----displayPointInMap----lat is %@",lat);
                NSLog(@"----displayPointInMap----locationName is %@",locationName);
                NSLog(@"----displayPointInMap----addr is %@",addr);
                NSLog(@"----displayPointInMap----type is %@",type);
                TEPointInMapViewController* pointInMapVC = [[TEPointInMapViewController alloc]init];
                pointInMapVC.lon = lon;
                pointInMapVC.lat = lat;
                pointInMapVC.locationName = locationName;
                pointInMapVC.addr = addr;
                pointInMapVC.type = type;
                pointInMapVC.delegate_confirmPoint = self;
                [self.navigationController pushViewController:pointInMapVC animated:YES];
            }
            if([funcStr isEqualToString:@"displayRouteInMap:"]){
                NSString* startLon = [arrFucnameAndParameter objectAtIndex:1];
                NSString* startLat = [arrFucnameAndParameter objectAtIndex:2];
                NSString* endLon = [arrFucnameAndParameter objectAtIndex:3];
                NSString* endLat = [arrFucnameAndParameter objectAtIndex:4];
                NSString* routeJSON = [TEUtil URLDecode:[TEUtil URLDecode:[arrFucnameAndParameter objectAtIndex:5]]];
                TERouteMapViewController* routeMapVC = [[TERouteMapViewController alloc]init];
                routeMapVC.startLon = startLon;
                routeMapVC.startLat = startLat;
                routeMapVC.endLon = endLon;
                routeMapVC.endLat = endLat;
                routeMapVC.routeJSON = routeJSON;
                routeMapVC.pageType = 3;
                [self.navigationController pushViewController:routeMapVC animated:YES];
            }
            if([funcStr isEqualToString:@"displayWalkDriveRouteInMap:"]){
                NSString* startLon = [arrFucnameAndParameter objectAtIndex:1];
                NSString* startLat = [arrFucnameAndParameter objectAtIndex:2];
                NSString* endLon = [arrFucnameAndParameter objectAtIndex:3];
                NSString* endLat = [arrFucnameAndParameter objectAtIndex:4];
                NSString* type = [arrFucnameAndParameter objectAtIndex:5];
                TERouteMapViewController* routeMapVC = [[TERouteMapViewController alloc]init];
                routeMapVC.startLon = startLon;
                routeMapVC.startLat = startLat;
                routeMapVC.endLon = endLon;
                routeMapVC.endLat = endLat;
                routeMapVC.pageType = [type intValue];
                [self.navigationController pushViewController:routeMapVC animated:YES];
            }
            
        }
    }
    return YES;
}
- (void)getSNSUserInfo:(NSString *)platform{
    int platformtype = ShareTypeSinaWeibo;
    if([@"sinaweibo" isEqualToString:platform]){
        platformtype = ShareTypeSinaWeibo;
    }else if([@"qqweibo" isEqualToString:platform]){
        platformtype = ShareTypeTencentWeibo;
    }else if([@"qzone" isEqualToString:platform]){
        platformtype = ShareTypeQQSpace;
    }
    [ShareSDK getUserInfoWithType:platformtype
                      authOptions:nil
                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                               if (result)
                               {
                                   NSLog(@"nickname :%@",[userInfo nickname]);
                                   NSLog(@"gender :%d",[userInfo gender]);
                                   NSLog(@"avatar :%@",[userInfo profileImage]);
                                   NSLog(@"uid :%@",[userInfo uid]);
                                   NSLog(@"birthday :%@",[userInfo birthday]);
                                   NSString* nickname = [userInfo nickname];
                                   NSString* gender;
                                   switch ([userInfo gender]) {
                                       case 0:
                                           gender = @"M";
                                           break;
                                       case 1:
                                           gender = @"F";
                                           break;
                                       case 2:
                                           gender = @"S";
                                           break;
                                       default:
                                           break;
                                   }
                                   NSString* avatar = [userInfo profileImage];
                                   NSString* uid = [userInfo uid];
                                   NSString* birthday = @"";//birthday暂时不用
                                   NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
                                   [dic setObject:platform forKey:@"userType"];
                                   [dic setObject:uid forKey:@"unitId"];
                                   [dic setObject:birthday forKey:@"birthdate"];
                                   [dic setObject:gender forKey:@"gender"];
                                   [dic setObject:nickname forKey:@"username"];
                                   [dic setObject:avatar forKey:@"avatarUrl"];
                                   SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
                                   NSString *snsUserInfoJSON = [jsonWriter stringWithObject:dic];
                                   NSString* snsUserInfoJSONConvert = [snsUserInfoJSON stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
                                   NSString *param = [NSString stringWithFormat:@"window.callbackGetSNSUserInfo('%@')",snsUserInfoJSONConvert];
                                   NSLog(@"----callbackGetSNSUserInfo----param is %@",param);
                                   [self jsCallbackMethod:param];
                               }else{
                                   NSString *param = [NSString stringWithFormat:@"window.callbackGetSNSUserInfo('')"];
                                   NSLog(@"----callbackGetSNSUserInfo----param is %@",param);
                                   [self jsCallbackMethod:param];
                               }
                           }];
}
- (void)popupRewardWindow:(NSString*) rewardStringJSON{
    
    SBJsonParser *jsonParser = [[SBJsonParser alloc]init];
    NSDictionary* rewardDic = [jsonParser objectWithString:rewardStringJSON];
    if([[rewardDic allKeys] count]>0){
        TERewardViewController* rewardVC = [[TERewardViewController alloc]init];
        rewardVC.reward_dic = rewardDic;
        rewardVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        UIViewController* rootViewController =  [[UIApplication sharedApplication] keyWindow].rootViewController;
        rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
        [rootViewController presentViewController:rewardVC animated:YES completion:^(void){NSLog(@"rewardvc");}];
    }
}
//setUserinfo
- (void)updateUserInfo:(NSString *)userInfoJSON{
    SBJsonParser *jsonParser = [[SBJsonParser alloc]init];
    NSMutableDictionary* result = [jsonParser objectWithString:userInfoJSON];
    if(![TEAppDelegate getApplicationDelegate].userInfoDictionary&&[[result allKeys] count]>0){//原本没有登录
        //下载用户设置
        [[TEAppDelegate getApplicationDelegate].networkHandler doRequest_downloadUserSetting];
        //第三方登陆或者注册
        [TEAppDelegate getApplicationDelegate].isLogin = 1;
        [[TEAppDelegate getApplicationDelegate].networkHandler doRequest_announcement:1];
        NSString* filePath = [TEPersistenceHandler getDocument:@"userLogin.plist"];
        NSDictionary* dic = [[NSDictionary alloc]initWithObjectsAndKeys:@"1",@"needLogin",nil];
        [dic writeToFile:filePath atomically:YES];
    }
    if([[result allKeys] count] == 0){//注销了
        [TEAppDelegate getApplicationDelegate].isLogin = 0;
        [TEAppDelegate getApplicationDelegate].userInfoDictionary = nil;
        [TEAppDelegate getApplicationDelegate].imageData = nil;
        NSString* filePath = [TEPersistenceHandler getDocument:@"userLogin.plist"];
        NSDictionary* dic = [[NSDictionary alloc]initWithObjectsAndKeys:@"0",@"needLogin",nil];
        [dic writeToFile:filePath atomically:YES];
        NSString* NOTIFICATION_CLEARUSERINFO = @"NOTIFICATION_CLEARUSERINFO";
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CLEARUSERINFO object:nil];
        return;
    }
    [TEAppDelegate getApplicationDelegate].userInfoDictionary = result;
}

//各种delegate的实现
#pragma -mark choose location delegate
- (void)chooseLocationDidSuccess:(NSMutableDictionary *)dic{
    NSString* type = [dic objectForKey:@"type"];
    NSString* lon = [dic objectForKey:@"lon"];
    NSString* lat = [dic objectForKey:@"lat"];
    NSString* addr = [dic objectForKey:@"addr"];
    NSString *jsparam = [NSString stringWithFormat:@"window.callbackChooseLocation('%@','%@','%@','%@')",type,lon,lat,addr];
    [self jsCallbackMethod:jsparam];
}
- (void)chooseLocationDidFailed:(NSString *)mes{
    
}

#pragma -mark actionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    self.avatarPicker = [[UIImagePickerController alloc]init];
    switch (buttonIndex) {
        case 0:
        {
            NSLog(@"拍照");
            self.avatarPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            self.avatarPicker.allowsEditing = YES;
            self.avatarPicker.delegate = self;
            self.avatarPicker.title = @"user";
            [self presentViewController:self.avatarPicker animated:YES completion:^{
            }];
            break;
        }
        case 1:
        {
            NSLog(@"相册");
            self.avatarPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            self.avatarPicker.allowsEditing = YES;
            self.avatarPicker.delegate = self;
            self.avatarPicker.title = @"user";
            [self presentViewController:self.avatarPicker animated:YES completion:^{
                
            }];
            break;
        }
        default:
            break;
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    if([picker isEqual:self.avatarPicker]){
        UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        UIImage* image_compressed = [image rescaleImageToSize:CGSizeMake(150, 150)];
        [picker dismissViewControllerAnimated:YES completion:nil];
        //新头像同步到服务器
        NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
        NSData* data_image = UIImageJPEGRepresentation(image_compressed, 1);
        //本地保存一下
        [TEAppDelegate getApplicationDelegate].imageData = data_image;
        [params setValue:data_image forKey:@"avatar"];
        [TEAppDelegate getApplicationDelegate].networkHandler.delegate_userAvatarUpload = self;
        [[TEAppDelegate getApplicationDelegate].networkHandler doRequest_userAvatarUpload:params];
    }else{
        [super imagePickerController:picker didFinishPickingMediaWithInfo:info];
    }
}
#pragma -mark avatar upload delegate
- (void)userAvatarUploadDidFailed:(NSString *)mes{
    NSString *param = [NSString stringWithFormat:@"window.callbackSetUserAvatar('')"];
    NSLog(@"----callbackSetUserAvatar----param is %@",param);
    [self jsCallbackMethod:param];
}
- (void)userAvatarUploadDidSuccess:(NSDictionary *)rewardDic{
    NSString* userInfoJSON = [TEAppDelegate getUserInfoJSON];
    NSString* userInfoJSONConvert = [userInfoJSON stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *param = [NSString stringWithFormat:@"window.callbackSetUserAvatar('%@')",userInfoJSONConvert];
    NSLog(@"----callbackSetUserAvatar----param is %@",param);
    [self jsCallbackMethod:param];
    
}
#pragma -mark point in map delegate
- (void)confirmPointDidSuccess:(NSMutableDictionary *)dic{
    NSString* type = [dic objectForKey:@"type"];
    NSString* lon = [dic objectForKey:@"lon"];
    NSString* lat = [dic objectForKey:@"lat"];
    NSString* locationName = [dic objectForKey:@"locationName"];
    NSString *jsparam = [NSString stringWithFormat:@"window.callbackDisplayPointInMap('%@','%@','%@','%@')",lon,lat,locationName,type];
    [self jsCallbackMethod:jsparam];
}
- (void)confirmPointDidFailed:(NSString *)mes{
    
}
- (IBAction)button_test_clicked:(id)sender {
    TEShareCarViewController* sharecarVC = [[TEShareCarViewController alloc]init];
    sharecarVC.type = @"start";
    sharecarVC.delegate_chooseLocation = self;
    [self.navigationController pushViewController:sharecarVC animated:YES];
}

- (IBAction)button_display_point:(id)sender {
    //测试代码：
    TEPointInMapViewController* pointInMapVC = [[TEPointInMapViewController alloc]init];
    pointInMapVC.lon = @"116.3924646";
    pointInMapVC.lat = @"39.90715";
    pointInMapVC.locationName = @"天安门";
    pointInMapVC.addr = @"长安街";
    pointInMapVC.type = @"1";
    pointInMapVC.delegate_confirmPoint = self;
    [self.navigationController pushViewController:pointInMapVC animated:YES];
}

- (IBAction)button_line:(id)sender {
    NSString* startLon = @"53635339";
    NSString* startLat = @"18420206";
    NSString* endLon = @"53627281";
    NSString* endLat = @"18356660";
//    NSString* endLon = @"53627281";
//    NSString* endLat = @"18356660";
    
    NSString* routeJSON = @"{\"brldist\":\"28.390\",\"brltime\":\"66\",\"linecnt\":\"2\",\"lineInfo\":[{\"walkdist\":\"0.4\",\"stationName\":\"北辰路\",\"walkLine\":\"53635268,18420351,53634959,18420342,53634954,18420618,53634954,18420618,53634544,18420683,53634544,18420683,53634526,18421342,53634493,18421337,53634473,18421337\",\"linename\":\"地铁10号线(首经贸站-西局站)\",\"bid\":\"busline_2358_110000\",\"consumetime\":\"17\",\"stopcnt\":\"6\",\"swdist\":\"320\",\"usid\":\"63413\",\"usname\":\"北土城\",\"spx\":\"53634473\",\"spy\":\"18421354\",\"dsid\":\"63419\",\"dsname\":\"海淀黄庄\",\"epx\":\"53599136\",\"epy\":\"18420926\",\"clistcnt\":\"10\",\"clist\":\"53634473,18421354,53628424,18421301,53623007,18421252,53615787,18421182,53609487,18421129,53606757,18421168,53605298,18421122,53604180,18421090,53604176,18421089,53599136,18420926,\"},{\"walkdist\":\"0.1\",\"stationName\":\"未知路段\",\"walkLine\":\"53599135,18420943,53599076,18420941,53599076,18420941,53599090,18420904,53599196,18420904,53599182,18420945,53599145,18420943\",\"linename\":\"地铁4号线(安河桥北站-公益西桥站)\",\"bid\":\"busline_1102_110000\",\"consumetime\":\"32\",\"stopcnt\":\"17\",\"swdist\":\"0\",\"usid\":\"27825\",\"usname\":\"海淀黄庄\",\"spx\":\"53599146\",\"spy\":\"18420927\",\"dsid\":\"27842\",\"dsname\":\"公益西桥站\",\"epx\":\"53623674\",\"epy\":\"18356908\",\"clistcnt\":\"65\",\"clist\":\"53599150,18420916,53600853,18416758,53601244,18415713,53601347,18415258,53601696,18412533,53601908,18411181,53602631,18405769,53602865,18403975,53602872,18403954,53602884,18403940,53602942,18403886,53603029,18403824,53603087,18403799,53606680,18403511,53609045,18403572,53611200,18403662,53611854,18403734,53612359,18403847,53613133,18404107,53613725,18404247,53614861,18404414,53616621,18404575,53622337,18404642,53624293,18404663,53624312,18404663,53624399,18404645,53624502,18404609,53624541,18404574,53624579,18404503,53624598,18404426,53624618,18403987,53624630,18402405,53624688,18400962,53624793,18399556,53624886,18396966,53625026,18393231,53625089,18392280,53625170,18389236,53625310,18385818,53625365,18384495,53625340,18380990,53625309,18376006,53625327,18373094,53625417,18372735,53625505,18372549,53625818,18372227,53627010,18371356,53627386,18371022,53627405,18371000,53627450,18370907,53627464,18370863,53627469,18370812,53627450,18370685,53627418,18370600,53627210,18370226,53626687,18369580,53624641,18367262,53624307,18366855,53624100,18366520,53624068,18366449,53624000,18366205,53623989,18366077,53623939,18364573,53623814,18361012,53623674,18356908,\"}],\"toEndDist\":\"1.0\",\"distName\":\"马家堡路\",\"toDistLine\":\"53623644,18356908,53623614,18355903,53623614,18355903,53624632,18355894,53624895,18355940,53625798,18356268,53626079,18356323,53627429,18356364,53627429,18356364,53627416,18356666\"}";
    TERouteMapViewController* routeMapVC = [[TERouteMapViewController alloc]init];
    routeMapVC.startLon = startLon;
    routeMapVC.startLat = startLat;
    routeMapVC.endLon = endLon;
    routeMapVC.endLat = endLat;
    routeMapVC.routeJSON = routeJSON;
    routeMapVC.pageType = 3;
    [self.navigationController pushViewController:routeMapVC animated:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:[NSString stringWithUTF8String:object_getClassName(self)]];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:[NSString stringWithUTF8String:object_getClassName(self)]];
}
@end
