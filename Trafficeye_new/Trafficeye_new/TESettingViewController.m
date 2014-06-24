//
//  TESettingViewController.m
//  Trafficeye_new
//
//  Created by 张 驰 on 13-6-17.
//  Copyright (c) 2013年 张 驰. All rights reserved.
//

#import "TESettingViewController.h"
#import "TEIndexFavViewController.h"
#import "TESetWeiboViewController.h"
#import "TENewsSetCityViewController.h"
#import "TEUserInfoEditViewController.h"
#import "TEServiceViewController.h"
#import "TEAboutViewController.h"
#import "TESetHomePageViewController.h"
#import "TEPushSettingViewController.h"
#import "UMFeedback.h"
#import "TEAboutBMWViewController.h"
#import "TESNSAuthViewController.h"
#import "TEUserWebViewController.h"
#import "TEShareCarServiceViewController.h"

@interface TESettingViewController ()

@end

@implementation TESettingViewController
@synthesize dataList;

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
    NSArray* array_group1 = [[NSArray alloc]initWithObjects:@"初始页面设置",@"交通指数收藏设置",@"交通微博关注设置",@"交通资讯城市设置", nil];
    NSArray* array_group2 = [[NSArray alloc]initWithObjects:@"个人信息管理",@"推送设置",@"绑定社交平台", nil];
    NSArray* array_group3 = [[NSArray alloc]initWithObjects:@"意见反馈",@"如何连接BMW车载设备？",@"服务条款", @"拼车服务条款",@"关于",nil];
    self.dataList = [[NSMutableArray alloc]initWithObjects:array_group1,array_group2,array_group3,nil];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    NSString *logString = [NSString stringWithFormat:@"%li,%@,%f %f;",
                           [TEUtil getNowTime],
                           [NSString stringWithFormat:@"I%@902101",LOG_VERSION],
                           [TEUtil getUserLocationLat],
                           [TEUtil getUserLocationLon]];
    [TEUtil appendStringToPlist:logString];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - tableView delegate

- (int)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.dataList objectAtIndex:section] count];
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section

{
    return 10;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    int section = [indexPath section];
    int row = [indexPath row];
    
    static NSString *MoreCellIdentifier = @"MoreCellIdentifier";
    cell = [tableView dequeueReusableCellWithIdentifier:MoreCellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MoreCellIdentifier];
    }
    
    
    cell.textLabel.text = [[self.dataList objectAtIndex:section]objectAtIndex:row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = [indexPath section];
    int row = [indexPath row];
    switch (section) {
        case 0:
            switch (row) {
                case 0:
                {
                    TESetHomePageViewController* sethomeVC = [[TESetHomePageViewController alloc]init];
                    sethomeVC.FromSetting = YES;
                    [self.navigationController pushViewController:sethomeVC animated:YES];
                    NSLog(@"初始版面");
                    break;
                }
                case 1:
                {
                    NSLog(@"交通指数");
                    TEIndexFavViewController* indexFavVC = [[TEIndexFavViewController alloc]init];
                    [self.navigationController pushViewController:indexFavVC animated:YES];
                    break;
                }
                    
                case 2:
                {
                    NSLog(@"交通微博");
                    TESetWeiboViewController* setWBVC = [[TESetWeiboViewController alloc]init];
                    [self.navigationController pushViewController:setWBVC animated:YES];
                    break;
                }
                    
                case 3:
                {
                    NSLog(@"交通资讯");
                    TENewsSetCityViewController* setNewsVC = [[TENewsSetCityViewController alloc]init];
                    [self.navigationController pushViewController:setNewsVC animated:YES];
                    break;

                }
                default:
                    break;
            }
            break;
        case 1:
            switch (row) {
                case 0:
                {
                    NSLog(@"个人信息");
                    if([TEAppDelegate getApplicationDelegate].isLogin == 1){
//                        TEUserInfoEditViewController* userInfoEditVC = [[TEUserInfoEditViewController alloc]init];
//                        [self.navigationController pushViewController:userInfoEditVC animated:YES];
                        
                        TEUserWebViewController* userWebVC = [[TEUserWebViewController alloc]init];
                        userWebVC.isEdit = 1;
                        [self.navigationController pushViewController:userWebVC animated:YES];
                    }else{
                        NSArray* array = [TEAppDelegate getApplicationDelegate].navControllers;
                        DDMenuController *menuController = (DDMenuController*)[TEAppDelegate getApplicationDelegate].menuController;
                        [menuController setRootController:[array objectAtIndex:INDEX_PAGE_USER] animated:YES];
                    }
                    break;
                }
                case 1:
                {
                    NSLog(@"推送设置");
//                    [self outerOpenAppWithIdentifier:@"488669129"];
//                    NSString* reportString = @"v1,,-1,3,10,1662;S; 2014-04-30-17-07-50,116387277,39976453,44,182,15,5,-1;0,461,-1054,1,158,11,5,-1;0,287,-1195,-1,175,13,5,-1;0,-27,-953,2,180,13,5,-1;0,16,-878,-1,178,10,5,-1;0,-2,-1093,2,182,11,5,-1;0,121,-1241,-1,177,13,5,-1;0,108,-1404,2,178,16,5,-1;0,-28,-1267,2,177,15,5,-1;0,43,-1306,3,180,14,5,-1;S; 2014-04-30-17-09-20,116388228,39965589,52,179,13,5,-1;0,110,-965,1,174,11,5,-1;0,62,-1116,-4,178,11,5,-1;0,-59,-664,0,185,8,5,-1;0,-67,-529,0,182,6,5,-1;0,-156,-577,0,211,6,5,-1;0,-726,57,1,258,6,5,-1;0,-1138,145,0,275,7,5,-1;";
//                    [[TEAppDelegate getApplicationDelegate].networkHandler doRequest_uploadLocation:reportString];
                    TEPushSettingViewController* pushSettingVC = [[TEPushSettingViewController alloc]init];
                    [self.navigationController pushViewController:pushSettingVC animated:YES];
                    break;
                }
                case 2:
                {
                    TESNSAuthViewController* snsAuthVC = [[TESNSAuthViewController alloc]init];
                    [self.navigationController pushViewController:snsAuthVC animated:YES];
                }
                default:
                    break;
            }
            break;
        case 2:
            switch (row) {
                case 0:
                {
                    UIViewController* rootViewController =  [[UIApplication sharedApplication] keyWindow].rootViewController;
                    rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
                    [UMFeedback showFeedback:rootViewController withAppkey:APPKEY];
                    NSLog(@"意见反馈");
                    break;
                }
                case 1:
                {
                    NSLog(@"连接BMW");
                    TEAboutBMWViewController* bmwVC = [[TEAboutBMWViewController alloc]init];
                    UIViewController* rootViewController =  [[UIApplication sharedApplication] keyWindow].rootViewController;
                    rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
                    [rootViewController presentViewController:bmwVC animated:YES completion:nil];
                    break;
                }
                case 2:
                {
                    NSLog(@"服务条款");
                    TEServiceViewController* serviceVC = [[TEServiceViewController alloc]init];
                    [self.navigationController pushViewController:serviceVC animated:YES];
                    break;
                }
                case 3:
                {
                    NSLog(@"拼车服务条款");
                    TEShareCarServiceViewController* sharecarserviceVC = [[TEShareCarServiceViewController alloc]init];
                    [self.navigationController pushViewController:sharecarserviceVC animated:YES];
                    break;
                }
                case 4:
                {
                    NSLog(@"关于");
                    TEAboutViewController* aboutVC = [[TEAboutViewController alloc]init];
                    [self.navigationController pushViewController:aboutVC animated:YES];
                    break;
                }
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)outerOpenAppWithIdentifier:(NSString *)appId {
    NSString *urlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/us/app/id%@?mt=8", appId];
    NSURL *url = [NSURL URLWithString:urlStr];
    [[UIApplication sharedApplication] openURL:url];
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
