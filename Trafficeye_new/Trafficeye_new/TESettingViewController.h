//
//  TESettingViewController.h
//  Trafficeye_new
//
//  Created by 张 驰 on 13-6-17.
//  Copyright (c) 2013年 张 驰. All rights reserved.
//

#import "TEFisrtLevelViewController.h"

@interface TESettingViewController : TEFisrtLevelViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) NSMutableArray* dataList;
@property (strong, nonatomic) IBOutlet UITableView *tableview_setting;

@end
