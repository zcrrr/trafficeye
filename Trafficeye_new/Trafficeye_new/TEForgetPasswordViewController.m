//
//  TEForgetPasswordViewController.m
//  Trafficeye_new
//
//  Created by zc on 13-9-17.
//  Copyright (c) 2013年 张 驰. All rights reserved.
//

#import "TEForgetPasswordViewController.h"

@interface TEForgetPasswordViewController ()

@end

@implementation TEForgetPasswordViewController

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
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    NSString *logString = [NSString stringWithFormat:@"%li,%@,%f %f;",
                           [TEUtil getNowTime],
                           [NSString stringWithFormat:@"I%@901103",LOG_VERSION],
                           [TEUtil getUserLocationLat],
                           [TEUtil getUserLocationLon]];
    [TEUtil appendStringToPlist:logString];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)button_clicked:(id)sender {
    if(self.textfield_email.text != nil && ![self.textfield_email.text isEqualToString:@""]){
        [self displayLoading];
        NSMutableDictionary* dic = [[NSMutableDictionary alloc ]init];
        [dic setValue:self.textfield_email.text forKey:@"email"];
        [TEAppDelegate getApplicationDelegate].networkHandler.delegate_userForgetPassword = self;
        [[TEAppDelegate getApplicationDelegate].networkHandler doRequest_userForgetPassword:dic];
    }else{
        //textfiled为空
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil message:@"邮箱不能为空"  delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
        [alertView show];
    }
}
#pragma -mark user edit password delegate
- (void)userForgetPasswordDidFailed:(NSString *)mes{
    UIAlertView* alert =[[UIAlertView alloc] initWithTitle:nil message:mes delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    [self hideLoading];
}
- (void)userForgetPasswordDidSuccess:(NSDictionary *)dic{
    UIAlertView* alert =[[UIAlertView alloc] initWithTitle:nil message:@"已经发送到邮箱" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    [self hideLoading];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)displayLoading{
    self.loadingImage.hidden = NO;
    [self.indicator startAnimating];
    [self disableAllButton];
}
- (void)hideLoading{
    self.loadingImage.hidden = YES;
    [self.indicator stopAnimating];
    [self enableAllButton];
}
- (void)disableAllButton{
    self.button_back.enabled = NO;
}
- (void)enableAllButton{
    self.button_back.enabled = YES;
}
- (IBAction)button_back_clicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
