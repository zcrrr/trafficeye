//
//  TETrafficWeiboViewController.m
//  Trafficeye_new
//
//  Created by 张 驰 on 13-6-17.
//  Copyright (c) 2013年 张 驰. All rights reserved.
//

#import "TETrafficWeiboViewController.h"
#import "TEPersistenceHandler.h"
#import "TESetWeiboViewController.h"

@interface TETrafficWeiboViewController ()

@end

@implementation TETrafficWeiboViewController
{
    BOOL hasGD;
    int pageNUM;
}

@synthesize province;
@synthesize city;
@synthesize cityName;
@synthesize type;

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
    self.springWeiboWebView.delegate=self;
    pageNUM = 1;
    [self.pageLabel setText:[NSString stringWithFormat:@"%i/10",pageNUM]];
    [self initCityAndType];
    [self loadURL];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    extern BOOL settingChange;
    if(settingChange){
        NSLog(@"settingchange!!");
        //刷新
        [self initCityAndType];
        [self loadURL];
        settingChange = NO;
    }
    [MobClick beginLogPageView:[NSString stringWithUTF8String:object_getClassName(self)]];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    NSString *logString = [NSString stringWithFormat:@"%li,%@,%f %f;",
                           [TEUtil getNowTime],
                           [NSString stringWithFormat:@"I%@105101[%@]",LOG_VERSION,self.cityName],
                           [TEUtil getUserLocationLat],
                           [TEUtil getUserLocationLon]];
    [TEUtil appendStringToPlist:logString];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)loadURL
{
    [self.springWeiboWebView stopLoading];
    NSLog(@"loadURL province is%@",self.province);
    NSString* str_url = [NSString stringWithFormat:@"%@?province=%@&city=%@&type=%@&pageno=%i",@"http://mobile.trafficeye.com.cn:8091/WeiboService/weibo2",self.province,self.city,self.type,pageNUM];
    NSLog(@"url is%@",str_url);
    NSURL* url = [NSURL URLWithString:str_url];
    [self.springWeiboWebView loadRequest:[NSURLRequest requestWithURL:url]];
    self.springWeiboWebView.scalesPageToFit = YES;
}
- (void)initCityAndType{
    self.province = [NSMutableString stringWithString:@"all"];
    self.city = [NSMutableString stringWithString:@"all"];
    self.cityName = [NSMutableString stringWithString:@"all"];
    self.type = [NSMutableString stringWithString:@"all"];
    hasGD = NO;
    //city
    NSString* filePath = [TEPersistenceHandler getDocument:@"weiboCity.plist"];
    NSMutableArray* arrayFromPlist = [NSMutableArray arrayWithContentsOfFile:filePath];
    if(arrayFromPlist){
        [self.province setString:@""];
        [self.city setString:@""];
        [self.cityName setString:@""];
        if([[arrayFromPlist objectAtIndex:0] isEqualToString:@"1"]){
            [self.province appendString:@"beijing,"];
            [self.cityName appendString:@"北京,"];
            
        }
        if([[arrayFromPlist objectAtIndex:1] isEqualToString:@"1"]){
            [self.province appendString:@"shanghai,"];
            [self.cityName appendString:@"上海,"];
        }
        if([[arrayFromPlist objectAtIndex:2] isEqualToString:@"1"]){
            [self.province appendString:@"guangdong,"];
            [self.city appendString:@"guangzhou,"];
            [self.cityName appendString:@"广州,"];
            hasGD = YES;
        }
        if([[arrayFromPlist objectAtIndex:3] isEqualToString:@"1"]){
            if(!hasGD){
                [self.province appendString:@"guangdong,"];
                hasGD = YES;
            }
            [self.city appendString:@"shenzhen,"];
            [self.cityName appendString:@"深圳,"];
        }
        if([self.city isEqualToString:@""]){
            [self.city setString:@"all"];
            [self.cityName appendString:@"all"];
        }
    }
    if([self.province hasSuffix:@","]){
        [self.province setString:[self.province substringToIndex:([self.province length]-1)]];
    }
    if([self.city hasSuffix:@","]){
        [self.city setString:[self.city substringToIndex:([self.city length]-1)]];
    }
    if([self.cityName hasSuffix:@","]){
        [self.cityName setString:[self.cityName substringToIndex:([self.cityName length]-1)]];
    }
    NSLog(@"province is %@",self.province);
    NSLog(@"city is %@",self.city);
    //type
    NSString* filePath2 = [TEPersistenceHandler getDocument:@"weiboType.plist"];
    NSMutableArray* arrayFromPlist2 = [NSMutableArray arrayWithContentsOfFile:filePath2];
    if(arrayFromPlist2){
        [self.type setString:@""];
        if([[arrayFromPlist2 objectAtIndex:0] isEqualToString:@"1"]){
            [self.type appendString:@"transport,"];
        }
        if([[arrayFromPlist2 objectAtIndex:1] isEqualToString:@"1"]){
            [self.type appendString:@"police,"];
        }
        if([[arrayFromPlist2 objectAtIndex:2] isEqualToString:@"1"]){
            [self.type appendString:@"media,"];
        }
        if([[arrayFromPlist2 objectAtIndex:3] isEqualToString:@"1"]){
            [self.type appendString:@"meteoro,"];
        }
        if([[arrayFromPlist2 objectAtIndex:4] isEqualToString:@"1"]){
            [self.type appendString:@"rail,"];
        }
        if([[arrayFromPlist2 objectAtIndex:5] isEqualToString:@"1"]){
            [self.type appendString:@"air,"];
        }
        if([[arrayFromPlist2 objectAtIndex:6] isEqualToString:@"1"]){
            [self.type appendString:@"subway,"];
        }
        if([[arrayFromPlist2 objectAtIndex:7] isEqualToString:@"1"]){
            [self.type appendString:@"tour,"];
        }
    }
    if([self.type hasSuffix:@","]){
        [self.type setString:[self.type substringToIndex:([self.type length]-1)]];
    }
    NSLog(@"type is%@",type);
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self displayLoading];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self hideLoading];
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
    NSURL *requestURL =[  request URL  ];
    if ( ( [ [ requestURL scheme ] isEqualToString: @"http" ] || [ [ requestURL scheme ] isEqualToString: @"https" ] || [ [ requestURL scheme ] isEqualToString: @"mailto" ])
        && ( navigationType == UIWebViewNavigationTypeLinkClicked ) ) {
        return ![ [ UIApplication sharedApplication ] openURL:  requestURL   ];
    }
    return YES;
}
- (IBAction)firstPage:(id)sender{
    NSLog(@"first");
    pageNUM = 1;
    [self.pageLabel setText:[NSString stringWithFormat:@"%i/10",pageNUM]];
    [self loadURL];
}
- (IBAction)previousPage:(id)sender{
    NSLog(@"previous");
    if(pageNUM == 1){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"已经是第一页" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }else{
        pageNUM--;
        [self.pageLabel setText:[NSString stringWithFormat:@"%i/10",pageNUM]];
        [self loadURL];
    }
    
}
- (IBAction)nextPage:(id)sender{
    NSLog(@"next");
    if(pageNUM == 10){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"已经是最后一页" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }else{
        pageNUM++;
        [self.pageLabel setText:[NSString stringWithFormat:@"%i/10",pageNUM]];
        [self loadURL];
    }
}
- (IBAction)lastPage:(id)sender{
    NSLog(@"last");
    pageNUM = 10;
    [self.pageLabel setText:[NSString stringWithFormat:@"%i/10",pageNUM]];
    [self loadURL];
}
- (IBAction)button_setting_clicked:(id)sender {
    TESetWeiboViewController* setVC = [[TESetWeiboViewController alloc]init];
    [self.navigationController pushViewController:setVC animated:YES];
}

- (IBAction)button_refresh_clicked:(id)sender {
    [self loadURL];
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
