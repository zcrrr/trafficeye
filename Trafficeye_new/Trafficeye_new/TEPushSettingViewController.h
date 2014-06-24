//
//  TEPushSettingViewController.h
//  Trafficeye_new
//
//  Created by zc on 14-2-19.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TESecondLevelViewController.h"
#import "TENetworkHandler.h"

@interface TEPushSettingViewController : TESecondLevelViewController<UITableViewDataSource,UITableViewDelegate,pushSettingDelegate>

@property(strong, nonatomic) NSMutableArray* cities;
@property(nonatomic) int cityIndex;
@property (retain, nonatomic) IBOutlet UISwitch *pushSwitch;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UILabel *label_settingCity;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (strong, nonatomic) IBOutlet UIImageView *loadingImage;
- (IBAction)switchChanged:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *button_back;
@property (strong, nonatomic) IBOutlet UIButton *button_ok;
- (IBAction)button_back_clicked:(id)sender;
- (IBAction)button_ok_clicked:(id)sender;


@end
