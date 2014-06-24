//
//  TEUserInfoViewController.m
//  Trafficeye_new
//
//  Created by zc on 13-9-2.
//  Copyright (c) 2013年 张 驰. All rights reserved.
//

#import "TEUserInfoViewController.h"
#import "TEPersistenceHandler.h"
#import "ASIHTTPRequest.h"
#import "TEUserLevelHandler.h"
#import "TEUserInfoEditViewController.h"
#import "TEUserLevelViewController.h"
#import "TEUserPointsViewController.h"
#import "TEUserDistanceViewController.h"
#import "TEUserBadgeViewController.h"
#import "TEUserEventViewController.h"


@interface TEUserInfoViewController ()

@end

@implementation TEUserInfoViewController

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
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.hidesBottomBarWhenPushed = NO;
    [self updateUI];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    NSString *logString = [NSString stringWithFormat:@"%li,%@,%f %f;",
                           [TEUtil getNowTime],
                           [NSString stringWithFormat:@"I%@901104[%@]",LOG_VERSION,[[TEAppDelegate getApplicationDelegate] getUid]],
                           [TEUtil getUserLocationLat],
                           [TEUtil getUserLocationLon]];
    [TEUtil appendStringToPlist:logString];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonClicked:(id)sender {
    switch ([(UIButton*)sender tag]) {
        case 0://点击头像或者昵称
        {
            TEUserInfoEditViewController* userInfoEditVC = [[TEUserInfoEditViewController alloc]init];
            [self.navigationController pushViewController:userInfoEditVC animated:YES];
            break;
        }
        case 1://点击编辑资料
        {
            TEUserInfoEditViewController* userInfoEditVC = [[TEUserInfoEditViewController alloc]init];
            [self.navigationController pushViewController:userInfoEditVC animated:YES];
            break;
        }
        case 2://点击注销
        {
            UIAlertView* alert =[[UIAlertView alloc] initWithTitle:nil message:@"您要退出账号吗？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            [alert show];
            break;
        }
            
        case 3://点击等级
        {
            TEUserLevelViewController* userLevelVC = [[TEUserLevelViewController alloc]init];
            [self.navigationController pushViewController:userLevelVC animated:YES];
            break;
        }
        case 4://点击积分
        {
            TEUserPointsViewController* userPointsVC = [[TEUserPointsViewController alloc]init];
            [self.navigationController pushViewController:userPointsVC animated:YES];
            break;
        }
        case 5://点击里程
        {
            TEUserDistanceViewController* userDisVC = [[TEUserDistanceViewController alloc]init];
            [self.navigationController pushViewController:userDisVC animated:YES];
            break;
        }
        case 6://点击徽章
        {
            TEUserBadgeViewController* userBadgeVC = [[TEUserBadgeViewController alloc]init];
            [self.navigationController pushViewController:userBadgeVC animated:YES];
            break;
        }
        case 7://点击事件
        {
            TEUserEventViewController* userEventVC = [[TEUserEventViewController alloc]init];
            [self.navigationController pushViewController:userEventVC animated:YES];
            break;
        }
        default:
            break;
    }
}
- (void)updateUI{
    if([TEAppDelegate getApplicationDelegate].userInfoDictionary){
        NSDictionary* dic = [TEAppDelegate getApplicationDelegate].userInfoDictionary;
        [self setUserAvatar:dic];
        self.label_username.text = [dic objectForKey:@"username"];
        
        int points = [[dic objectForKey:@"totalPoints"] intValue];
        self.label_points.text = [NSString stringWithFormat:@"%d积分",points];
        int level = [TEUserLevelHandler generateLevelWithPoint:points];
        self.label_level.text = [NSString stringWithFormat:@"%d等级",level];
        float distance = [[dic objectForKey:@"drive_miles"] longLongValue]/1000.0;
        self.label_distance.text = [NSString stringWithFormat:@"%.1f公里",distance];
        NSString* group_name = [dic objectForKey:@"group_name"];
        if(![TEUtil isStringNULL:group_name]){
            if([group_name isEqualToString:@"sinaweibo"]){
//                [TEAppDelegate getApplicationDelegate].sns_login_type = 1;
            }else if([group_name isEqualToString:@"qqweibo"]){
//                [TEAppDelegate getApplicationDelegate].sns_login_type = 2;
            }
        }
        
    }
    
//    if([TEAppDelegate getApplicationDelegate].sns_login_type == 0){
//        self.imageView_SNSLogo.hidden = YES;
//    }else if([TEAppDelegate getApplicationDelegate].sns_login_type == 1){
//        self.imageView_SNSLogo.hidden = NO;
//        self.imageView_SNSLogo.image = [UIImage imageNamed:@"tinylogo_sina_weibo"];
//    }else if([TEAppDelegate getApplicationDelegate].sns_login_type == 2){
//        self.imageView_SNSLogo.hidden = NO;
//        self.imageView_SNSLogo.image = [UIImage imageNamed:@"tinylogo_tencent_weibo"];
//    }
}
- (void)setUserAvatar:(NSDictionary*)dic{
    //先判断dic里有没有图片数据
    NSData* imageData = [TEAppDelegate getApplicationDelegate].imageData;
    if(imageData){
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        self.imageViewAvatar.image = image;
    }else{
        NSString *avatar = [dic objectForKey:@"avatar"];
        if(![TEUtil isStringNULL:avatar]){
            NSString* imageURL = [NSString stringWithFormat:@"%@%@",ENDPOINTS,avatar];
            NSLog(@"avatar is %@",imageURL);
            NSURL *url = [NSURL URLWithString:imageURL];
            ASIHTTPRequest *Imagerequest = [ASIHTTPRequest requestWithURL:url];
            Imagerequest.tag = 1;
            Imagerequest.timeOutSeconds = 15;
            [Imagerequest setDelegate:self];
            [Imagerequest startAsynchronous];
        }
        
    }
}
#pragma -mark ASIHttpRequest delegate
- (void)requestFinished:(ASIHTTPRequest *)request{
    UIImage *image = [[UIImage alloc] initWithData:[request responseData]];
    if(image){
        self.imageViewAvatar.image = image;
        [TEAppDelegate getApplicationDelegate].imageData = [request responseData];
    }
}
- (void)requestFailed:(ASIHTTPRequest *)request{
}
#pragma -mark alert delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
        {
            [TEAppDelegate getApplicationDelegate].isLogin = 0;
//            [TEAppDelegate getApplicationDelegate].sns_login_type = 0;
            [TEAppDelegate getApplicationDelegate].userInfoDictionary = nil;
            [TEAppDelegate getApplicationDelegate].imageData = nil;
            [TEAppDelegate getApplicationDelegate].hasBadges = nil;
            [TEAppDelegate getApplicationDelegate].hasBadges = [[NSMutableArray alloc]init];
            NSString* filePath = [TEPersistenceHandler getDocument:@"userLogin.plist"];
            NSDictionary* dic = [[NSDictionary alloc]initWithObjectsAndKeys:@"0",@"needLogin",nil];
            [dic writeToFile:filePath atomically:YES];
            [self.navigationController popToRootViewControllerAnimated:YES];
            NSString* NOTIFICATION_CLEARUSERINFO = @"NOTIFICATION_CLEARUSERINFO";
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CLEARUSERINFO object:nil];
            [[TEAppDelegate getApplicationDelegate].networkHandler doRequest_logout];
            break;
        }
        case 1:
        {
            [alertView dismissWithClickedButtonIndex:1 animated:YES];
        }
            
            
        default:
            break;
    }
}
@end
