//
//  TEAboutViewController.m
//  Trafficeye_new
//
//  Created by zc on 14-1-26.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import "TEAboutViewController.h"
#import "PayViewController.h"

@interface TEAboutViewController ()

@end

@implementation TEAboutViewController

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
    NSString* path = [[[NSBundle mainBundle]bundlePath] stringByAppendingPathComponent:@"about.html"];
    NSURL* url = [NSURL fileURLWithPath:path];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    self.webview.scalesPageToFit = YES;
    [self.webview setBackgroundColor:[UIColor clearColor]];
    [self.webview loadRequest:request];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    NSString *logString = [NSString stringWithFormat:@"%li,%@,%f %f;",
                           [TEUtil getNowTime],
                           [NSString stringWithFormat:@"I%@902106",LOG_VERSION],
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

- (IBAction)button_pay_clicked:(id)sender {
    if([TEAppDelegate getApplicationDelegate].isLogin == 1){
        PayViewController* payVC = [[PayViewController alloc]init];
        [self.navigationController pushViewController:payVC animated:YES];
    }else{
        NSLog(@"请先登录");
    }

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
