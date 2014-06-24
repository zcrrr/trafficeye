//
//  TENewsViewController.m
//  Trafficeye_new
//
//  Created by zc on 13-10-15.
//  Copyright (c) 2013年 张 驰. All rights reserved.
//

#import "TENewsViewController.h"
#import "TEPersistenceHandler.h"
#import "TENewsSetCityViewController.h"
#import "Toast+UIView.h"

@interface TENewsViewController ()

@end

@implementation TENewsViewController
@synthesize city;
#warning
int lineNo;//不知道干什么用的

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
    [self loadURL];
    self.webView.delegate = self;
    
    NSString* NOTIFICATION_REFRESH_NEWS = @"refresh_news";
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadURL) name:NOTIFICATION_REFRESH_NEWS object:nil];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString* filePath = [TEPersistenceHandler getDocument:@"newsCitySetting.plist"];
    NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    if(dic){
        self.city = [self cityNameForIndex:[[dic objectForKey:@"newsCity"] intValue]];
    }else{
        self.city = @"beijing";
    }
    [MobClick beginLogPageView:[NSString stringWithUTF8String:object_getClassName(self)]];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    NSString *logString = [NSString stringWithFormat:@"%li,%@,%f %f;",
                           [TEUtil getNowTime],
                           [NSString stringWithFormat:@"I%@107101[%@]",LOG_VERSION,[self getCityName]],
                           [TEUtil getUserLocationLat],
                           [TEUtil getUserLocationLon]];
    [TEUtil appendStringToPlist:logString];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSString*)cityNameForIndex:(int)index{
    switch (index) {
        case 0:
            return @"beijing";
            break;
        case 1:
            return @"shenzhen";
            break;
            
        default:
            return @"beijing";
            break;
    }
}
- (NSString*)getCityName{
    if([self.city isEqualToString:@"beijing"]){
        return @"北京";
    }else if([self.city isEqualToString:@"shenzhen"]){
        return @"深圳";
    }
    return @"北京";
}
- (void)loadURL{
    NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"informationIndex" ofType:@"html"];
    NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [self.webView loadHTMLString:html baseURL:baseURL];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"调用js");
    NSLog(@"lineNo is %d",lineNo);
    NSString *param = [NSString stringWithFormat:@"init(\"%@|%d\")",self.city,lineNo];
    [self.webView stringByEvaluatingJavaScriptFromString:param];
    [self hideLoading];
}
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *requestURL =[  request URL  ];
    if ( ( [ [ requestURL scheme ] isEqualToString: @"http" ] || [ [ requestURL scheme ] isEqualToString: @"https" ] || [ [ requestURL scheme ] isEqualToString: @"mailto" ])
        && ( navigationType == UIWebViewNavigationTypeLinkClicked ) ) {
        return ![ [ UIApplication sharedApplication ] openURL:  requestURL   ];
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
            if([funcStr isEqualToString:@"goSetting"])
            {
                /*调用本地函数1*/
                NSLog(@"doFunc1");
                [self goSetting];
            }
        }
        else
        {
            //有参数的
            if([funcStr isEqualToString:@"displayToast:"])
            {
                NSString *str = [arrFucnameAndParameter objectAtIndex:1];
                NSLog(@"显示toast：%@",[TEUtil URLDecode:[TEUtil URLDecode:str]]);
                [self.view makeToast:[TEUtil URLDecode:[TEUtil URLDecode:str]]];
            }
        }
    }
    return YES;
}
- (void)goSetting{
    TENewsSetCityViewController* setVC = [[TENewsSetCityViewController alloc]init];
    [self.navigationController pushViewController:setVC animated:YES];
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"startLoad");
    [self displayLoading];
    
}
- (void)displayLoading{
    self.loadingImage.hidden = NO;
    [self.indicator startAnimating];
}
- (void)hideLoading{
    self.loadingImage.hidden = YES;
    [self.indicator stopAnimating];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:[NSString stringWithUTF8String:object_getClassName(self)]];
}



@end
