//
//  TETaxiHelpViewController.m
//  Trafficeye_new
//
//  Created by zc on 13-11-1.
//  Copyright (c) 2013年 张 驰. All rights reserved.
//

#import "TETaxiHelpViewController.h"

@interface TETaxiHelpViewController ()

@end

@implementation TETaxiHelpViewController
@synthesize bannerView_;

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
    NSString* path = [[[NSBundle mainBundle]bundlePath] stringByAppendingPathComponent:@"taxi_index_help.html"];
    NSURL* url = [NSURL fileURLWithPath:path];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [self.webview loadRequest:request];
    self.webview.scalesPageToFit = YES;
    
    //广告
    self.bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    
    // 指定广告单元ID。
    self.bannerView_.adUnitID = @"a153620e6b38338";
    self.bannerView_.rootViewController = self;
    [self.view addSubview:bannerView_];
    self.bannerView_.hidden = YES;

    [bannerView_ loadRequest:[GADRequest request]];

    
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    NSString *logString = [NSString stringWithFormat:@"%li,%@,%f %f;",
                           [TEUtil getNowTime],
                           [NSString stringWithFormat:@"I%@104102",LOG_VERSION],
                           [TEUtil getUserLocationLat],
                           [TEUtil getUserLocationLon]];
    [TEUtil appendStringToPlist:logString];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)button_back_clicked:(id)sender {
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
