//
//  TESigraAddCityViewController.m
//  Trafficeye_new
//
//  Created by zc on 14-1-14.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import "TESigraAddCityViewController.h"
#import "TERouteOfCityViewController.h"

@interface TESigraAddCityViewController ()

@end

@implementation TESigraAddCityViewController

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
    self.scrollview.contentSize = CGSizeMake(320, 425);
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    NSString *logString = [NSString stringWithFormat:@"%li,%@,%f %f;",
                           [TEUtil getNowTime],
                           [NSString stringWithFormat:@"I%@102103",LOG_VERSION],
                           [TEUtil getUserLocationLat],
                           [TEUtil getUserLocationLon]];
    [TEUtil appendStringToPlist:logString];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)button_city_clicked:(id)sender {
    NSString* cityCode;
    switch ([(UIButton*)sender tag]) {
        case 0:
            cityCode = @"101010100";
            break;
        case 1:
            cityCode = @"101020100";
            break;
        case 2:
            cityCode = @"101280101";
            break;
        case 3:
            cityCode = @"101280601";
            break;
        case 4:
            cityCode = @"101210101";
            break;
        case 5:
            cityCode = @"101230101";
            break;
        case 6:
            cityCode = @"101200101";
            break;
        case 7:
            cityCode = @"101270101";
            break;
        case 8:
            cityCode = @"101040100";
            break;
        case 9:
            cityCode = @"101120201";
            break;
        case 10:
            cityCode = @"101070101";
            break;
        case 11:
            cityCode = @"101190101";
            break;
        case 12:
            cityCode = @"101210401";
            break;
        case 13:
            cityCode = @"101060101";
            break;
        case 14:
            cityCode = @"101281701";
            break;
        case 15:
            cityCode = @"101090101";
            break;
        case 16:
            cityCode = @"101250101";
            break;
        case 17:
            cityCode = @"101281601";
            break;
        case 18:
            cityCode = @"101280701";
            break;
        case 19:
            cityCode = @"101280800";
            break;
        case 20:
            cityCode = @"101190201";
            break;
        case 21:
            cityCode = @"101030100";
            break;
        case 22:
            cityCode = @"101230201";
            break;
        case 23:
            cityCode = @"101190401";
            break;
        case 24:
            cityCode = @"101210901";
            break;
        case 25:
            cityCode = @"101210701";
            break;
        case 26:
            cityCode = @"000000000";
            break;
            
        default:
            break;
    }
    TERouteOfCityViewController* allRouteVC = [[TERouteOfCityViewController alloc]init];
    allRouteVC.str_city_code = cityCode;
    [self.navigationController pushViewController:allRouteVC animated:YES];
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
