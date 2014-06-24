//
//  TEChangeNameViewController.m
//  Trafficeye_new
//
//  Created by zc on 14-1-10.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import "TEChangeNameViewController.h"
#import "NSString+Calculate.h"
#import "TEPersistenceHandler.h"
#import "TERewardViewController.h"
#import "TEUserInfoViewController.h"

@interface TEChangeNameViewController ()

@end

@implementation TEChangeNameViewController
@synthesize userInfo;

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
                           [NSString stringWithFormat:@"901113"],
                           [TEUtil getUserLocationLat],
                           [TEUtil getUserLocationLon]];
    [TEUtil appendStringToPlist:logString];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    self.button_submit.enabled = NO;
}
- (void)enableAllButton{
    self.button_back.enabled = YES;
    self.button_submit.enabled = YES;
}
- (IBAction)button_back_clicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)button_submit_clicked:(id)sender {
    int length = [self.textfield_name.text calculateTextNumber];
    NSLog(@"length is %i",length);
    if (self.textfield_name.text == nil || [self.textfield_name.text isEqualToString:@""] ||length < 4 || length>30)
    {
        NSString* string_alert = @"昵称不符合规范，应为4-30个字符，支持中英文、数字、下划线和减号";
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil message:string_alert delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    [self.userInfo setObject:self.textfield_name.text forKey:@"username"];
    [TEAppDelegate getApplicationDelegate].networkHandler.delegate_snsLogin = self;
    [[TEAppDelegate getApplicationDelegate].networkHandler doRequest_snsLogin:self.userInfo];
    [self displayLoading];
}
#pragma mark -sns login Delegate
- (void)snsLoginDidSuccess:(NSDictionary *)dic{
    [self hideLoading];
    NSDictionary* stateDic = [dic objectForKey:@"state"];
    NSString* code = [stateDic objectForKey:@"code"];
    NSLog(@"code is %@",code);
    if([code isEqualToString:@"0"]){
        //登录成功
        [TEAppDelegate getApplicationDelegate].isLogin = 1;
        NSString* filePath = [TEPersistenceHandler getDocument:@"userLogin.plist"];
        NSMutableDictionary* dic_plist = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
        if(!dic_plist){
            dic_plist = [[NSMutableDictionary alloc]init];
        }
        [dic_plist setObject:@"1" forKey:@"needLogin"];
        [dic_plist writeToFile:filePath atomically:YES];
        [TEAppDelegate getApplicationDelegate].userInfoDictionary = [dic objectForKey:@"userInfo"];
        NSDictionary* rewardDic = [dic objectForKey:@"reward"];
        if(rewardDic){
            TERewardViewController* rewardVC = [[TERewardViewController alloc]init];
            rewardVC.reward_dic = rewardDic;
            rewardVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            UIViewController* rootViewController =  [[UIApplication sharedApplication] keyWindow].rootViewController;
            rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
            [rootViewController presentViewController:rewardVC animated:YES completion:^(void){NSLog(@"rewardvc");}];
            //弹出奖励窗口后延迟1秒执行跳转页面
            [self performSelector:@selector(turnToUserInfoView) withObject:nil afterDelay:1];
        }else{
            //跳转到个人详细信息页面
            [self turnToUserInfoView];
        }
    }else if([code isEqualToString:@"-2"]){
        NSLog(@"名字有重复");
        TEChangeNameViewController* changeNameVC = [[TEChangeNameViewController alloc]init];
        [self.navigationController pushViewController:changeNameVC animated:YES];
        
    }
}
- (void)snsLoginDidFailed:(NSString *)mes{
    [self hideLoading];
}
- (void)turnToUserInfoView{
    if([TEAppDelegate getApplicationDelegate].isLogin == 1){//成功登录之后才会跳转，登录失败只需要停止loading的动画
        TEUserInfoViewController* userInfoVC = [[TEUserInfoViewController alloc]init];
        [self.navigationController pushViewController:userInfoVC animated:YES];
    }
}
@end
