//
//  TEAllRoutesViewController.h
//  Trafficeye_new
//
//  Created by zc on 14-1-22.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TESecondLevelViewController.h"

@interface TEAllRoutesViewController : TESecondLevelViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) int cityIndex;
@property (nonatomic, retain) NSMutableArray* selectRouteList;
@property (strong, nonatomic) IBOutlet UIButton *btn1;
@property (strong, nonatomic) IBOutlet UIButton *btn2;
@property (strong, nonatomic) IBOutlet UIButton *btn3;
@property (retain, nonatomic) IBOutlet UIButton *btn4;
@property (strong, nonatomic) NSMutableArray* favRouteList;
- (IBAction)button_back_clicked:(id)sender;
- (IBAction)button_ok_clicked:(id)sender;
- (IBAction)button_city_clicked:(id)sender;

@end
