//
//  TETrafficIndexViewController.m
//  Trafficeye_new
//
//  Created by 张 驰 on 13-6-17.
//  Copyright (c) 2013年 张 驰. All rights reserved.
//

#import "TETrafficIndexViewController.h"
#import "TEPersistenceHandler.h"
#import "TEIndexFavViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "UIImage+Rescale.h"

@interface TETrafficIndexViewController ()

@end

@implementation TETrafficIndexViewController
@synthesize favRouteList;
@synthesize weiboText;

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
    self.webview.delegate = self;
    NSString* NOTIFICATION_REFRESH_INDEX = @"refresh_index";
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadURL) name:NOTIFICATION_REFRESH_INDEX object:nil];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    NSString *logString = [NSString stringWithFormat:@"%li,%@,%f %f;",
                           [TEUtil getNowTime],
                           [NSString stringWithFormat:@"I%@103101[%@]",LOG_VERSION,[self getFavRoads]],
                           [TEUtil getUserLocationLat],
                           [TEUtil getUserLocationLon]];
    [TEUtil appendStringToPlist:logString];
}
- (void)loadURL{
    NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [self.webview loadHTMLString:html baseURL:baseURL];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString* filePath = [TEPersistenceHandler getDocument:@"traIndexFav.plist"];
    NSMutableArray* arrayFromPlist = [NSMutableArray arrayWithContentsOfFile:filePath];
    if(arrayFromPlist){
        self.favRouteList = arrayFromPlist;
    }else{
        self.favRouteList = [[NSMutableArray alloc]initWithObjects:@"北京-全路网",@"深圳-全市",nil];
    }
    [MobClick beginLogPageView:[NSString stringWithUTF8String:object_getClassName(self)]];
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"startLoad");
    [self displayLoading];
    
}
- (NSString*)getFavRoads{
    NSMutableString* str = [[NSMutableString alloc]initWithString:@""];
    int i = 0;
    for (i = 0;i<[self.favRouteList count];i++){
        [str appendString:[self.favRouteList objectAtIndex:i]];
        [str appendString:@","];
    }
    if([str hasSuffix:@","]){
        [str setString:[str substringToIndex:([str length]-1)]];
    }
    return str;
}
//页面加载完成之后，通过objc 传递js参数
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"调用js");
    NSMutableString *cities = [NSMutableString stringWithString:@""];
    for(int i=0;i<[self.favRouteList count];i++){
        [cities appendString:[self.favRouteList objectAtIndex:i]];
        if(i < [self.favRouteList count]-1){
            [cities appendString:@","];
        }
    }
    NSLog(@"cities is %@",cities);
    int length = 0 ;
    if(iPhone5){
        length = 465;
    }else{
        length = 375;
    }
    NSString *currentURL= self.webview.request.URL.absoluteString;
    NSLog(@"currentURL is %@",currentURL);
    NSString *urlstr = @"";
    if([currentURL hasSuffix:@"index.html"]||[currentURL hasSuffix:@"Trafficeye_new.app/"]){
        urlstr = @"\"http://mobile.trafficeye.com.cn:8000/\"";
        NSString *param = [NSString stringWithFormat:@"Traffic.initByParam('{\"area\":\"%@\",\"width\":320,\"height\":%i,\"url\":%@}')",cities,length,urlstr];
        [self.webview stringByEvaluatingJavaScriptFromString:param];
    }else if([currentURL hasSuffix:@"index_list.html"]){
        NSString *param = [NSString stringWithFormat:@"init()"];
        [self.webview stringByEvaluatingJavaScriptFromString:param];
    }
    [self hideLoading];
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
                NSLog(@"setting");
                [self goSetting];
            }
        }
        else
        {
            //有参数的
            if([funcStr isEqualToString:@"share:"])
            {
                NSString *str = [arrFucnameAndParameter objectAtIndex:1];
                self.weiboText = [NSString stringWithFormat:@"#路况交通眼#%@指数",[TEUtil URLDecode:[TEUtil URLDecode:str]]];
                [self displayShareView];
            }
        }
    }
    return YES;
}
- (void)goSetting{
    TEIndexFavViewController* indexFavVC = [[TEIndexFavViewController alloc]init];
    [self.navigationController pushViewController:indexFavVC animated:YES];
}
- (void)displayShareView{
    id<ISSContent> publishContent = [ShareSDK content:self.weiboText
                                       defaultContent:@"路况交通眼"
                                                image:[ShareSDK pngImageWithImage:[self getWeiboImage]]
                                                title:self.weiboText
                                                  url:@"http://mobile.trafficeye.com.cn"
                                          description:@"路况交通眼"
                                            mediaType:SSPublishContentMediaTypeImage];
    NSArray *shareList = [ShareSDK getShareListWithType:
                          ShareTypeSinaWeibo,
                          ShareTypeTencentWeibo,
                          ShareTypeWeixiSession,
                          ShareTypeWeixiTimeline,
                          ShareTypeQQSpace,
                          nil];
    
    [ShareSDK showShareActionSheet:nil
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions: nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                    NSString* shareTypeString = @"sinaweibo";
                                    switch (type) {
                                        case ShareTypeSinaWeibo:
                                            shareTypeString = @"sinaweibo";
                                            break;
                                        case ShareTypeTencentWeibo:
                                            shareTypeString = @"qqweibo";
                                            break;
                                        case ShareTypeWeixiSession:
                                            shareTypeString = @"weChat";
                                            break;
                                        case ShareTypeWeixiTimeline:
                                            shareTypeString = @"weChatFriends";
                                            break;
                                        case ShareTypeQQSpace:
                                            shareTypeString = @"qzone";
                                            break;
                                            
                                        default:
                                            break;
                                    }
                                    NSLog(@"shareTypeString is %@",shareTypeString);
                                    [[TEAppDelegate getApplicationDelegate].networkHandler doRequest_newShareSNS:shareTypeString :self.weiboText :[self getWeiboImage]];
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                }
                            }];
}
- (UIImage *)getWeiboImage{
    UIGraphicsBeginImageContext(CGSizeMake(320,self.view.frame.size.height));
    [self.view.window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* image_temp = UIGraphicsGetImageFromCurrentImageContext();
    UIImage* image_small = [image_temp rescaleImageToSize:CGSizeMake(240, self.view.frame.size.height/4*3)];
    NSData* imageData = UIImagePNGRepresentation(image_small);
    UIImage* image_compressed = [UIImage imageWithData:imageData];
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
//    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"test.png"]];   // 保存文件的名称
//    BOOL result = [UIImagePNGRepresentation(image_compressed)writeToFile: filePath atomically:YES];
//    NSLog(@"result is %i",result);
    return image_compressed;
}
- (void)loadpicURL{
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
    NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"transfromIndex" ofType:@"html"];
    NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [self.webview loadHTMLString:html baseURL:baseURL];
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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:[NSString stringWithUTF8String:object_getClassName(self)]];
}


@end
