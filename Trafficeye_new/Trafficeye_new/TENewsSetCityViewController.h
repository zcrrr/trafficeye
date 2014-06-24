//
//  TENewsSetCityViewController.h
//  Trafficeye_new
//
//  Created by zc on 14-1-24.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TESecondLevelViewController.h"
#import "TENetworkHandler.h"

@interface TENewsSetCityViewController : TESecondLevelViewController<UITableViewDataSource,UITableViewDelegate,uploadUserSettingDelegate>
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property(strong, nonatomic) NSMutableArray* cities;
@property(nonatomic) int cityIndex;
- (IBAction)button_back_clicked:(id)sender;
- (IBAction)button_ok_clicked:(id)sender;

@end
