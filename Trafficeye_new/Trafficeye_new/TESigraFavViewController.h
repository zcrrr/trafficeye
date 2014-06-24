//
//  TESigraFavViewController.h
//  Trafficeye_new
//
//  Created by zc on 14-1-14.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TESecondLevelViewController.h"
#import "TENetworkHandler.h"

@interface TESigraFavViewController : TESecondLevelViewController<UITableViewDataSource,UITableViewDelegate,uploadUserSettingDelegate>
@property (strong,nonatomic) NSMutableArray *favRouteList;
@property (strong, nonatomic) IBOutlet UITableView *tableview_roadList;
@property (strong, nonatomic) IBOutlet UIButton *button_add;
@property (strong, nonatomic) IBOutlet UIButton *button_ok;
- (IBAction)button_add_clicked:(id)sender;
- (IBAction)button_ok_clicked:(id)sender;

@end
