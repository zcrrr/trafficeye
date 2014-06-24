//
//  TETimeLineViewController.m
//  Trafficeye_new
//
//  Created by zc on 14-2-20.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import "TETimeLineViewController.h"
#import "TEUserInfoEditViewController.h"
#import "GetDeviceIPAdress.h"
#import <ShareSDK/ShareSDK.h>
#import "TEUserWebViewController.h"

@interface TETimeLineViewController ()

@end

@implementation TETimeLineViewController
@synthesize clientIP;
@synthesize goto_param;
@synthesize pageName;

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
    [self loadpicURL];
    self.clientIP = [GetDeviceIPAdress deviceIPAdress];
//    NSLog(@"ip is %@",[GetDeviceIPAdress deviceIPAdress]);
//    [self lookupfriends:@"0" :@"10" :@"sinaweibo"];
//    [self bingdingStep1:@"sinaweibo"];
//    [self invitation:@"内容" :@"sinaweibo"];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
//    NSString *logString = [NSString stringWithFormat:@"%li,%@,%f %f;",
//                           [TEUtil getNowTime],
//                           [NSString stringWithFormat:@"添加页面编号"],
//                           [TEUtil getUserLocationLat],
//                           [TEUtil getUserLocationLon]];
//    [TEUtil appendStringToPlist:logString];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)loadpicURL{
    NSString* page = @"com_index";
    if(self.pageName!=nil){
        page = pageName;
    }
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
    NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    NSString *path = [[NSBundle mainBundle] pathForResource:page ofType:@"html"];
    NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [self.webview loadHTMLString:html baseURL:baseURL];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    if(self.pageName != nil){
        NSString* paramConvert = [self.goto_param stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
        NSString* fromPerParam = [NSString stringWithFormat:@"window.personalGotoCommunityPage('%@')",paramConvert];
        NSLog(@"时间线参数是%@",fromPerParam);
        [self.webview stringByEvaluatingJavaScriptFromString:fromPerParam];
        self.pageName = nil;
        return;
    }
    NSLog(@"调用js");
    NSString* uid = [[TEAppDelegate getApplicationDelegate] getUid];
    NSString* pid = [TEAppDelegate getApplicationDelegate].pid;
    NSString *param = [NSString stringWithFormat:@"window.initPageManager(%@,'%@',320,568)",uid,pid];
    NSString* currentURL = webView.request.URL.absoluteString;
    NSLog(@"currentURL is %@",currentURL);
    if([currentURL hasSuffix:@"Trafficeye_new.app/"]||[currentURL hasSuffix:@"com_index.html"]){
        param = [NSString stringWithFormat:@"window.initPageManager(%@,'%@',320,568)",uid,pid];
    }else{
        param = @"";
    }
    NSLog(@"时间线参数是%@",param);
    [self.webview stringByEvaluatingJavaScriptFromString:param];
//    [self hideLoading];
}
- (void)goUserCenter{
    [self closeSelf];
    NSArray* array = [TEAppDelegate getApplicationDelegate].navControllers;
    DDMenuController *menuController = (DDMenuController*)[TEAppDelegate getApplicationDelegate].menuController;
    [menuController setRootController:[array objectAtIndex:INDEX_PAGE_USER] animated:YES];
}
- (void)goUserEdit{
//    [self closeSelf];
//    TEUserInfoEditViewController* userInfoEditVC = [[TEUserInfoEditViewController alloc]init];
//    [self.navigationController pushViewController:userInfoEditVC animated:YES];
    TEUserWebViewController* userWebVC = [[TEUserWebViewController alloc]init];
    userWebVC.isEdit = 1;
    [self.navigationController pushViewController:userWebVC animated:YES];
}
- (void)closeSelf{
//    [self dismissViewControllerAnimated:YES completion:^(void){NSLog(@"close");}];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)lookupfriends:(NSString*)page : (NSString*)count :(NSString*)requestType{
    NSString* uid = [[TEAppDelegate getApplicationDelegate] getUid];
    NSString* sns_login_type = [[TEAppDelegate getApplicationDelegate].userInfoDictionary objectForKey:@"userType"];
    NSString* userType = @"";
    int snsType = 0;
    if([sns_login_type isEqualToString:@"sinaweibo"]){
        userType = @"sinaweibo";
        snsType = ShareTypeSinaWeibo;
    }else if([sns_login_type isEqualToString:@"qqweibo"]){
        userType = @"qqweibo";
        snsType = ShareTypeTencentWeibo;
    }else{
        userType = @"trafficeye";
    }
    NSString* token = @"";
    NSString* openid = @"";
    id<ISSPlatformCredential> credentialInfo = [ShareSDK getCredentialWithType:snsType];
    if(credentialInfo){
        NSLog(@"不为nil");
        token = [credentialInfo token];
        openid = [credentialInfo uid];
    }
    NSLog(@"credentialInfo is %@",credentialInfo);
    NSLog(@"uid is %@",[credentialInfo uid]);
    NSLog(@"token is %@",[credentialInfo token]);
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    [params setObject:uid forKey:@"uid"];
    [params setObject:self.clientIP forKey:@"clientip"];
    [params setObject:page forKey:@"page"];
    [params setObject:count forKey:@"count"];
    [params setObject:requestType forKey:@"requestType"];
    [params setObject:userType forKey:@"userType"];
    [params setObject:token forKey:@"token"];
    [params setObject:openid forKey:@"openid"];
    [TEAppDelegate getApplicationDelegate].networkHandler.delegate_lookupFriends = self;
    [[TEAppDelegate getApplicationDelegate].networkHandler doRequest_lookupFriends:params];
}
- (void)bingdingStep1:(NSString*)requestType{
    int type = 0;
    if([requestType isEqualToString:@"sinaweibo"]){
        type = ShareTypeSinaWeibo;
    }else if([requestType isEqualToString:@"qqweibo"]){
        type = ShareTypeTencentWeibo;
    }
    if([ShareSDK hasAuthorizedWithType:type]){
        //得到所有参数访问接口
        [self bingdingStep2:type :requestType];
    }else{//先授权
        [ShareSDK authWithType:type                                                                     options:nil
                        result:^(SSAuthState state, id<ICMErrorInfo> error) {                            if (state == SSAuthStateSuccess)
                            {
                                NSLog(@"成功");
                                [self bingdingStep2:type :requestType];
                            }
                            else if (state == SSAuthStateFail)
                            {
                                NSLog(@"失败");
                            }
                        }];
    }
}
- (void)bingdingStep2:(int)type :(NSString*)requestType{
    NSString* uid = [[TEAppDelegate getApplicationDelegate] getUid];
    NSString* token = @"";
    NSString* openid = @"";
    id<ISSPlatformCredential> credentialInfo = [ShareSDK getCredentialWithType:type];
    if(credentialInfo){
        NSLog(@"不为nil");
        token = [credentialInfo token];
        openid = [credentialInfo uid];
    }
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    [params setObject:uid forKey:@"uid"];
    [params setObject:self.clientIP forKey:@"clientip"];
    [params setObject:requestType forKey:@"requestType"];
    [params setObject:token forKey:@"token"];
    [params setObject:openid forKey:@"openid"];
    [TEAppDelegate getApplicationDelegate].networkHandler.delegate_bingding = self;
    [[TEAppDelegate getApplicationDelegate].networkHandler doRequest_binding:params];
}
- (void)invitation:(NSString*)content :(NSString*)requestType{
    NSString* uid = [[TEAppDelegate getApplicationDelegate] getUid];
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    [params setObject:uid forKey:@"uid"];
    [params setObject:self.clientIP forKey:@"clientip"];
    [params setObject:requestType forKey:@"requestType"];
    [params setObject:content forKey:@"content"];
    [TEAppDelegate getApplicationDelegate].networkHandler.delegate_invitation = self;
    [[TEAppDelegate getApplicationDelegate].networkHandler doRequest_invitation:params];
}
#pragma -community delegate
- (void)lookupFriendsDidFailed:(NSString *)mes{
    
}
- (void)lookupFriendsDidSuccess:(NSString *)result{
    NSString *param = [NSString stringWithFormat:@"window.initparm(\'%@\')",result];
    NSLog(@"查找好友参数是%@",param);
    [self.webview stringByEvaluatingJavaScriptFromString:param];
}
-(void)bindingDidFailed:(NSString *)mes{
    
}
-(void)bindingDidSuccess:(NSString *)result{
    NSString *param = [NSString stringWithFormat:@"window.initparm(\'%@\')",result];
    NSLog(@"绑定参数是%@",param);
    [self.webview stringByEvaluatingJavaScriptFromString:param];
}
- (void)invitationDidFailed:(NSString *)mes{
    
}
- (void)invitationDidSuccess:(NSString *)result{
    NSString *param = [NSString stringWithFormat:@"window.inviteResult(\'%@\')",result];
    NSLog(@"邀请参数是%@",param);
    [self.webview stringByEvaluatingJavaScriptFromString:param];
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
    NSLog(@"js返回url是%@",urlString);
    NSArray *urlComps = [urlString componentsSeparatedByString:@"://"];
    
    if([urlComps count] && [[urlComps objectAtIndex:0] isEqualToString:@"objc"])
    {
        NSArray *arrFucnameAndParameter = [(NSString*)[urlComps objectAtIndex:1] componentsSeparatedByString:@":/"];
        NSString *funcStr = [arrFucnameAndParameter objectAtIndex:0];
        
        if (1 == [arrFucnameAndParameter count])
        {
            // 没有参数
            if([funcStr isEqualToString:@"closeSelf"])
            {
                /*调用本地函数1*/
               [self closeSelf];
            }
            // 没有参数
            if([funcStr isEqualToString:@"goUserCenter"])
            {
                /*调用本地函数1*/
                [self goUserCenter];
            }
            // 没有参数
            if([funcStr isEqualToString:@"goUserEdit"])
            {
                /*调用本地函数1*/
                [self goUserEdit];
            }
        }
        else
        {
            //有参数的
            if([funcStr isEqualToString:@"lookupfriends:"])
            {
                NSString *str1 = [arrFucnameAndParameter objectAtIndex:1];
                NSString *str2 = [arrFucnameAndParameter objectAtIndex:2];
                NSString *str3 = [arrFucnameAndParameter objectAtIndex:3];
                NSLog(@"str1 is %@,str2 is %@,str3 is %@",str1,str2,str3);
                [self lookupfriends:str1 :str2 :str3];
            }
            if([funcStr isEqualToString:@"bingdingStep1:"])
            {
                NSString *str1 = [arrFucnameAndParameter objectAtIndex:1];
                NSLog(@"str1 is %@",str1);
                [self bingdingStep1:str1];
            }
            if([funcStr isEqualToString:@"invitation:"])
            {
                NSString *str1 = [arrFucnameAndParameter objectAtIndex:1];
                NSString *str2 = [arrFucnameAndParameter objectAtIndex:2];
                NSLog(@"str1 is %@,str2 is %@",str1,str2);
                NSString *content = [TEUtil URLDecode:[TEUtil URLDecode:str1]];
                [self invitation:content :str2];
            }
            if([funcStr isEqualToString:@"showAlert:"])
            {
                NSString *str1 = [arrFucnameAndParameter objectAtIndex:1];
                NSLog(@"str1 is %@",str1);
                NSString *encode_str = [TEUtil URLDecode:[TEUtil URLDecode:str1]];
                UIAlertView* alert =[[UIAlertView alloc] initWithTitle:nil message:encode_str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            if([funcStr isEqualToString:@"gotoPersonalDetail:"])
            {
                NSString *str1 = [arrFucnameAndParameter objectAtIndex:1];
                NSLog(@"str1 is %@",str1);
                NSString *encode_str = [TEUtil URLDecode:[TEUtil URLDecode:str1]];
                NSLog(@"encode_str is %@",encode_str);
                TEUserWebViewController* userWebVC = [[TEUserWebViewController alloc]init];
                userWebVC.isEdit = 2;
                userWebVC.goto_param = encode_str;
                [self.navigationController pushViewController:userWebVC animated:YES];
            }
        }
    }
    return YES;
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
