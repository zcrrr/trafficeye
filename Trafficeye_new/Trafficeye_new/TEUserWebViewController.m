//
//  TEUserWebViewController.m
//  Trafficeye_new
//
//  Created by zc on 14-4-14.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import "TEUserWebViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "TEPersistenceHandler.h"
#import "TERewardViewController.h"
#import "SBJson.h"
#import "UIImage+Rescale.h"
#import "TETimeLineViewController.h"

@interface TEUserWebViewController ()

@end

@implementation TEUserWebViewController
@synthesize isEdit;
@synthesize goto_param;
@synthesize avatarPicker;
@synthesize target;

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
    self.webview.delegate = self;
    NSString* NOTIFICATION_AUTOLOGIN_DONE = @"notification_autologin_done";
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(autologinDone) name:NOTIFICATION_AUTOLOGIN_DONE object:nil];
    
    //获取测试数据
//    [self getSNSUserInfo:@"qqweibo"];
//    [self autologinDone];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self loadpicURL];
    [MobClick beginLogPageView:[NSString stringWithUTF8String:object_getClassName(self)]];
}
- (void)autologinDone{
    NSString* userInfoJSON = [TEAppDelegate getUserInfoJSON];
    NSString* userInfoJSONConvert = [userInfoJSON stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *param = [NSString stringWithFormat:@"window.callbackAutoLoginDone('%@')",userInfoJSONConvert];
    NSLog(@"----callbackAutoLoginDone----param is %@",param);
    [self jsCallbackMethod:param];
}
- (void)loadpicURL{
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
    NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"pre_login" ofType:@"html"];
    NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [self.webview loadHTMLString:html baseURL:baseURL];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"初始化个人页面js");
    int isLogin = [TEAppDelegate getApplicationDelegate].isLogin;
    NSString* userInfoJSON = [TEAppDelegate getUserInfoJSON];
    NSString* ua = [TEAppDelegate getApplicationDelegate].userAgent;
    NSString* pid = [TEAppDelegate getApplicationDelegate].pid;
    NSString* userInfoJSONConvert = [userInfoJSON stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    
    NSString* currentURL = webView.request.URL.absoluteString;
    NSLog(@"currentURL is %@",currentURL);
    if(!self.target){
        self.target = @"info";
    }
    if([currentURL hasSuffix:@"Trafficeye_new.app/"]||[currentURL hasSuffix:@"/pre_login.html"]){
        
        if([TEUtil isStringNULL:self.goto_param]||self.goto_param == nil){
            self.goto_param = @"";
        }
        NSString* paramConvert = [self.goto_param stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
        NSString *param = [NSString stringWithFormat:@"window.callbackInitPage(%i,'%@',%i,'%@','%@','%@','%@')",isLogin,userInfoJSONConvert,self.isEdit,ua,pid,paramConvert,self.target];
        NSLog(@"----callbackInitPage----param is %@",param);
        [self jsCallbackMethod:param];
    }
}
//接收js的调用，跟2个参数
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *requestURL = [request URL];
    if ( ( [ [ requestURL scheme ] isEqualToString: @"http" ] || [ [ requestURL scheme ] isEqualToString: @"https" ] || [ [ requestURL scheme ] isEqualToString: @"mailto" ])
        && ( navigationType == UIWebViewNavigationTypeLinkClicked ) ) {
        return ![ [ UIApplication sharedApplication ] openURL: requestURL];
    }
    
    NSString *urlString = [[request URL] absoluteString];
    
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
            if([funcStr isEqualToString:@"getValueByKey:"])
            {
                NSString *str1 = [arrFucnameAndParameter objectAtIndex:1];
                NSLog(@"----getValueByKey----str1 is %@",str1);
                [self getValueByKey:str1];
                
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
        }
    }
    return YES;
}
#pragma -mark 供js调用的本地方法，以及delegate
//第三方登录
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
//js回调
- (void)jsCallbackMethod:(NSString*)param{
    [self.webview stringByEvaluatingJavaScriptFromString:param];
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

- (void)getValueByKey:(NSString *) key{
    NSString* value = @"";
    if([key isEqualToString:@"isLogin"]){
        value = [NSString stringWithFormat:@"%i",[TEAppDelegate getApplicationDelegate].isLogin];
    }else if([key isEqualToString:@"userAgent"]){
        value = [TEAppDelegate getApplicationDelegate].userAgent;
    }else if([key isEqualToString:@"pid"]){
        value = [TEAppDelegate getApplicationDelegate].pid;
    }
    NSString *param = [NSString stringWithFormat:@"window.callbackGetValueByKey('%@','%@')",key,value];
    NSLog(@"----callbackGetValueByKey----param is %@",param);
    [self jsCallbackMethod:param];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:[NSString stringWithUTF8String:object_getClassName(self)]];
}


@end
