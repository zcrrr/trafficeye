//
//  TESurveyViewController.m
//  Trafficeye_new
//
//  Created by zc on 14-2-21.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import "TESurveyViewController.h"
#import "SBJson.h"
#import "TEUserInfoEditViewController.h"
#import "TESurveyStep2ViewController.h"
#import "TEUserWebViewController.h"
#import "Toast+UIView.h"

@interface TESurveyViewController ()

@end

@implementation TESurveyViewController
@synthesize action;
@synthesize url_param;

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
    self.scrollview.contentSize = CGSizeMake(320, 350);
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
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if([TEAppDelegate getApplicationDelegate].isLogin){
        [TEAppDelegate getApplicationDelegate].networkHandler.delegate_checkUser = self;
        [[TEAppDelegate getApplicationDelegate].networkHandler doRequest_checkUser];
    }else{
        [self hideUserInfo];
        [self.button_action setTitle:@"登录/注册" forState:UIControlStateNormal];
        self.action = 3;
    }
    NSString* str_url = [NSString stringWithFormat:@"%@/api2/v3/QualificationsDesc",ENDPOINTS];
    NSURL* url = [NSURL URLWithString:str_url];
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:url];
    request.delegate = self;
    [request startAsynchronous];
    [MobClick beginLogPageView:[NSString stringWithUTF8String:object_getClassName(self)]];
}
- (void)requestFinished:(ASIHTTPRequest*)request{
    NSString *responseString = [request responseString];
    if(responseString == nil || [@"" isEqualToString:responseString]){
        return;
    }
    SBJsonParser *jsonParser = [[SBJsonParser alloc]init];
    NSDictionary *result = [jsonParser objectWithString:responseString];
    if(!result)return;
    NSString* mystr = [result objectForKey:@"desc"];
    NSLog(@"mystr is %@",mystr);
    self.url_param = [result objectForKey:@"url"];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 50)];
    label.numberOfLines = 2;
    label.textColor = [UIColor blueColor];
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:mystr];
    NSRange contentRange = {0,[content length]};
    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    
    label.attributedText = content;
    [self.scrollview addSubview:label];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(button_click2) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(10, 5, 300, 50);
    [self.scrollview addSubview:button];
}
- (void)displayUserInfo{
    self.label_info.hidden = NO;
    self.label_username.hidden = NO;
    self.label_phonenum.hidden = NO;
    self.label_sex.hidden = NO;
    self.label_birthday.hidden = NO;
}
- (void)hideUserInfo{
    self.label_info.hidden = YES;
    self.label_username.hidden = YES;
    self.label_phonenum.hidden = YES;
    self.label_sex.hidden = YES;
    self.label_birthday.hidden = YES;
}
- (void)button_click2{
    TESurveyStep2ViewController* surveyVC = [[TESurveyStep2ViewController alloc]init];
    surveyVC.param_url = self.url_param;
    [self.navigationController pushViewController:surveyVC animated:YES];
    
}
- (IBAction)button_click:(id)sender {
    switch (self.action) {
        case 1:
        {
            TEUserWebViewController* userWebVC = [[TEUserWebViewController alloc]init];
            userWebVC.isEdit = 1;
            userWebVC.target = @"survey";
            [self.navigationController pushViewController:userWebVC animated:YES];
            break;
        }
        case 2:
        {
            TESurveyStep2ViewController* surveyVC = [[TESurveyStep2ViewController alloc]init];
            [self.navigationController pushViewController:surveyVC animated:YES];
            break;
        }
        case 3:
        {
            NSArray* array = [TEAppDelegate getApplicationDelegate].navControllers;
            DDMenuController *menuController = (DDMenuController*)[TEAppDelegate getApplicationDelegate].menuController;
            [menuController setRootController:[array objectAtIndex:INDEX_PAGE_USER] animated:YES];
            break;
        }
        default:
            break;
    }
}
- (void)checkUserDidSuccess:(NSDictionary *)dic{
    int code = [[dic objectForKey:@"code"] intValue];
    NSString* des = [dic objectForKey:@"desc"];
    if(code == 0){
        [self displayUserInfo];
        NSString* sex = [[TEAppDelegate getApplicationDelegate].userInfoDictionary objectForKey:@"gender"];
        if([sex isEqualToString:@"M"]){
            sex = @"男";
        }else if([sex isEqualToString:@"F"]){
            sex = @"女";
        }
        self.label_username.text = [[TEAppDelegate getApplicationDelegate].userInfoDictionary objectForKey:@"username"];
        self.label_phonenum.text = [[TEAppDelegate getApplicationDelegate].userInfoDictionary objectForKey:@"mobile"];
        self.label_sex.text = sex;
        self.label_birthday.text = [[TEAppDelegate getApplicationDelegate].userInfoDictionary objectForKey:@"birthdate"];
        [self.button_action setTitle:@"进入有奖调查" forState:UIControlStateNormal];
        self.action = 2;
    }else if(code == 1||code == 2||code == 3){
        [self.view makeToast:des];
        NSLog(@"请完善信息");
        [self.button_action setTitle:@"请完善信息" forState:UIControlStateNormal];
        self.action = 1;
        [self hideUserInfo];
    }
}
- (void)checkUserDidFailed{
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:[NSString stringWithUTF8String:object_getClassName(self)]];
}


@end
