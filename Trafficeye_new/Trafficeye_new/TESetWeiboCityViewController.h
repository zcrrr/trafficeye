//
//  TESetWeiboCityViewController.h
//  Trafficeye_new
//
//  Created by zc on 14-1-24.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TESecondLevelViewController.h"

@interface TESetWeiboCityViewController : TESecondLevelViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) NSArray *listData;
@property (strong, nonatomic) NSMutableArray *flagArray;
- (IBAction)button_back_clicked:(id)sender;
- (IBAction)button_ok_clicked:(id)sender;

@end
