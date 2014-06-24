//
//  TEIndexFavViewController.h
//  Trafficeye_new
//
//  Created by zc on 14-1-16.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TESecondLevelViewController.h"

@interface TEIndexFavViewController : TESecondLevelViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic) NSMutableArray *favRouteList;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)button_add_clicked:(id)sender;
- (IBAction)button_ok_clicked:(id)sender;


@end
