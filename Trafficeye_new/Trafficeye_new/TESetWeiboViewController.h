//
//  TESetWeiboViewController.h
//  Trafficeye_new
//
//  Created by zc on 14-1-24.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TESecondLevelViewController.h"

@interface TESetWeiboViewController : TESecondLevelViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) NSArray *listData;
- (IBAction)button_back_clicked:(id)sender;

@end
