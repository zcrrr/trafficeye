//
//  TESurveyStep2ViewController.m
//  Trafficeye_new
//
//  Created by zc on 14-2-24.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import "TESurveyStep2ViewController.h"

@interface TESurveyStep2ViewController ()

@end

@implementation TESurveyStep2ViewController
@synthesize param_url;

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
    NSString* uid = [[TEAppDelegate getApplicationDelegate] getUid];
    NSString* pid = [TEAppDelegate getApplicationDelegate].pid;
    NSString *phoneNum = [[TEAppDelegate getApplicationDelegate].userInfoDictionary objectForKey:@"mobile"];
    NSString *realname = [[TEAppDelegate getApplicationDelegate].userInfoDictionary objectForKey:@"realName"];
    NSString *username = [[TEAppDelegate getApplicationDelegate].userInfoDictionary objectForKey:@"username"];
    NSString *sex = [[TEAppDelegate getApplicationDelegate].userInfoDictionary objectForKey:@"gender"];
    if([sex isEqualToString:@"M"]){
        sex = @"男";
    }else if([sex isEqualToString:@"F"]){
        sex = @"女";
    }else{
        
    }
    NSString *birthday = [[TEAppDelegate getApplicationDelegate].userInfoDictionary objectForKey:@"birthdate"];
    NSString* url;
    if(self.param_url){
        url = [NSString stringWithFormat:@"%@%@?app=ios",ENDPOINTS,self.param_url];
    }else{
        CLLocationCoordinate2D coordinate = [[[TEAppDelegate getApplicationDelegate].mapview_app userLocation] coordinate];
        NSLog(@"loc lat = %f, loc lon = %f",coordinate.latitude,coordinate.longitude);
        float lat = coordinate.latitude;
        float lon = coordinate.longitude;
        url = [NSString stringWithFormat:@"%@/api2/v3/answerQualifications?uid=%@&pid=%@&location=%f %f&phone=%@&username=%@&realName=%@&gender=%@&birthday=%@&type=ios",ENDPOINTS,uid,pid,lat,lon,phoneNum,username,realname,sex,birthday];
    }
    NSLog(@"url is %@",url);
    NSString *encodedString=[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *weburl = [NSURL URLWithString:encodedString];
    NSURLRequest *request =[NSURLRequest requestWithURL:weburl];
    [self.webview loadRequest:request];
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
- (void)displayLoading{
    self.loadingImage.hidden = NO;
    [self.indicator startAnimating];
}
- (void)hideLoading{
    self.loadingImage.hidden = YES;
    [self.indicator stopAnimating];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"error:%@",[error localizedDescription]);
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self hideLoading];
}
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *requestURL =[request URL];
    if ( ( [ [ requestURL scheme ] isEqualToString: @"http" ] || [ [ requestURL scheme ] isEqualToString: @"https" ] || [ [ requestURL scheme ] isEqualToString: @"mailto" ])
        && ( navigationType == UIWebViewNavigationTypeLinkClicked ) ) {
        return ![ [ UIApplication sharedApplication ] openURL:requestURL ];
    }
    
    NSString *urlString = [[request URL] absoluteString];
    
    NSArray *urlComps = [urlString componentsSeparatedByString:@"://"];
    
    if([urlComps count] && [[urlComps objectAtIndex:0] isEqualToString:@"objc"])
    {
        
        NSArray *arrFucnameAndParameter = [(NSString*)[urlComps objectAtIndex:1] componentsSeparatedByString:@":/"];
        NSString *funcStr = [arrFucnameAndParameter objectAtIndex:0];
        if (1 == [arrFucnameAndParameter count])
        {
            // 没有参数
            if([funcStr isEqualToString:@"goBack"])
            {
                /*调用本地函数1*/
                [self goback];
            }
        }
    }
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self displayLoading];
}
- (void)goback{
    [self.navigationController popViewControllerAnimated:YES];
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
