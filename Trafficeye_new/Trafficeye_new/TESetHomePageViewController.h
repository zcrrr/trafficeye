//
//  TESetHomePageViewController.h
//  Trafficeye_new
//
//  Created by zc on 14-1-26.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TESecondLevelViewController.h"
#import "TENetworkHandler.h"

@interface TESetHomePageViewController : TESecondLevelViewController<UITableViewDataSource,UITableViewDelegate,uploadUserSettingDelegate>
@property (assign, nonatomic) int currentHomePageIndex;
@property (strong, nonatomic) NSMutableArray* pageArray;
@property (assign, nonatomic) BOOL FromSetting;
@property (strong, nonatomic) IBOutlet UIButton *button_back;
@property (strong, nonatomic) IBOutlet UITableView *tableview;
- (IBAction)button_back_clicked:(id)sender;
- (IBAction)button_ok_clicked:(id)sender;

@end
