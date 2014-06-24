//
//  TESNSAuthViewController.h
//  Trafficeye_new
//
//  Created by zc on 14-3-20.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TESecondLevelViewController.h"
@interface TESNSAuthViewController : TESecondLevelViewController<UITableViewDataSource,UITableViewDelegate>

@property(strong, nonatomic) NSMutableArray* snsDataList;
@property (strong, nonatomic) IBOutlet UITableView *tableview;
- (IBAction)button_back_clicked:(id)sender;

@end
