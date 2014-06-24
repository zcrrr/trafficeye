//
//  TEReportEventViewController.m
//  Trafficeye_new
//
//  Created by zc on 13-10-15.
//  Copyright (c) 2013年 张 驰. All rights reserved.
//

#import "TEReportEventViewController.h"
#import "TERewardViewController.h"

@interface TEReportEventViewController ()

@end

@implementation TEReportEventViewController

@synthesize eventImage;
@synthesize eventType;
@synthesize lat;
@synthesize lon;

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
    self.textview_content.delegate = self;
    self.textview_content.text = [self getDefaultDes:self.eventType];
    NSInteger number2 = [self.textview_content.text length];
    self.label_letter_num.text = [NSString stringWithFormat:@"%d",140 - number2];
    self.imageview_test.image = self.eventImage;
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    NSString *logString = [NSString stringWithFormat:@"%li,%@,%f %f;",
                           [TEUtil getNowTime],
                           [NSString stringWithFormat:@"I%@101111",LOG_VERSION],
                           [TEUtil getUserLocationLat],
                           [TEUtil getUserLocationLon]];
    [TEUtil appendStringToPlist:logString];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)closeClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)publishClicked:(id)sender {
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    NSString* uid = [[TEAppDelegate getApplicationDelegate] getUid];
    if(!uid){uid = @"0";}
    [params setValue:uid forKey:@"uid"];
    
    NSString* eventType_index = @"";
    NSString* eventTypeServer = @"";
    switch (self.eventType) {
        case 0:
        {
            eventTypeServer = @"5";
            eventType_index = @"1";
            break;
        }
        case 1:
        {
            eventTypeServer = @"5";
            eventType_index = @"3";
            break;
        }
        case 2:
        {
            eventTypeServer = @"2";
            eventType_index = @"2";
            break;
        }
        case 3:
        {
            eventTypeServer = @"2";
            eventType_index = @"1";
            break;
        }
        case 4:
        {
            eventTypeServer = @"3";
            eventType_index = @"1";
            break;
        }
        case 5:
        {
            eventTypeServer = @"3";
            eventType_index = @"2";
            break;
        }
        case 6:
        {
            eventTypeServer = @"1";
            eventType_index = @"2";
            break;
        }
        case 7:
        {
            eventTypeServer = @"1";
            eventType_index = @"1";
            break;
        }
        case 8:
        {
            eventTypeServer = @"1";
            eventType_index = @"0";
            break;
        }
        case 9:
        {
            eventTypeServer = @"4";
            eventType_index = @"2";
            break;
        }
        case 10:
        {
            eventTypeServer = @"4";
            eventType_index = @"1";
            break;
        }
            
            
        default:
            break;
    }
    [params setValue:eventTypeServer forKey:@"eventType"];
    [params setValue:eventType_index forKey:@"eventTypeIndex"];
    [params setValue:@"1" forKey:@"relativePos"];
    [params setValue:self.textview_content.text  forKey:@"eventContent"];
    [params setValue:@"0" forKey:@"speed"];
    [params setValue:@"0" forKey:@"direction"];
    [params setValue:@"0" forKey:@"level"];
    NSString *loc = [NSString stringWithFormat:@"%f %f",lon,lat];
    NSLog(@"loc is %@",loc);
    [params setValue:loc forKey:@"gpsPoint"];
    [TEAppDelegate getApplicationDelegate].networkHandler.delegate_reportEvent = self;
    [[TEAppDelegate getApplicationDelegate].networkHandler doRequest_reportEvent:params :self.eventImage];
    [self displayLoading];
}

- (NSString*)getDefaultDes:(int)type{
    NSString* defaultDes = @"";
    switch (type) {
        case 0:
            defaultDes = @"路上拍街景，这算街拍嘛？！";
            break;
        case 1:
            defaultDes = @"我去~~会开车吗？曝光他（ya）的！！";
            break;
        case 2:
            defaultDes = @"喔！！大事故！大家绕着点。";
            break;
        case 3:
            defaultDes = @"小事故，赶紧挪路边儿去吧，别站着路了。";
            break;
        case 4:
            defaultDes = @"有人施工，大家注意避让。";
            break;
        case 5:
            defaultDes = @"路上来一大工地，灰多路差车挤车啦。";
            break;
        case 6:
            defaultDes = @"堵得都快成停车场了。";
            break;
        case 7:
            defaultDes = @"走走停停，累死朕了。";
            break;
        case 8:
            defaultDes = @"一路畅通，走你！";
            break;
        case 9:
            defaultDes = @"匝道封闭了，上不了高架。";
            break;
        case 10:
            defaultDes = @"啥事儿啊，又把俺们往路边赶？";
            break;
            
        default:
            break;
    }
    return defaultDes;
}
#pragma -mark report event delegate
- (void)reportEventDidFailed:(NSString *)mes{
    UIAlertView* alert =[[UIAlertView alloc] initWithTitle:nil message:mes delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    [self hideLoading];
}

- (void)reportEventDidSuccess:(NSDictionary *)rewardDic{
    [self hideLoading];
    [self dismissViewControllerAnimated:NO completion:nil];
    //如果目前是在地图页面，则刷新一下地图，让用户能够直接看到事件
    extern int selectedIndex;
    if(selectedIndex == INDEX_PAGE_MAP){
        NSString* NOTIFICATION_REQUEST_EVENT = @"request_event";
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REQUEST_EVENT object:nil];
    }
}
#pragma -mark textfield delegate
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //隐藏键盘
    [self.textview_content resignFirstResponder];
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
    self.button_submit.enabled = NO;
    self.button_close.enabled = NO;
}
- (void)enableAllButton{
    self.button_close.enabled = YES;
    self.button_submit.enabled = YES;
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
