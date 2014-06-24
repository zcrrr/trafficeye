//
//  TERouteOfCityViewController.h
//  Trafficeye_new
//
//  Created by zc on 14-1-15.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TESecondLevelViewController.h"
#import "TENetworkHandler.h"

@interface TERouteOfCityViewController : TESecondLevelViewController<UITableViewDelegate,UITableViewDataSource,uploadUserSettingDelegate>
@property (nonatomic, assign) int displayType;
@property (nonatomic, strong) NSString* str_city_code;
@property (nonatomic, strong) NSMutableArray* dataSourceList;
@property (nonatomic, strong) NSMutableDictionary* dataSourceDic;
@property (nonatomic, strong) NSMutableArray* favRouteList;
@property (nonatomic, strong) NSMutableArray* routeListAll;
@property (nonatomic, strong) NSMutableArray* routeList_area;
@property (nonatomic, strong) NSMutableArray* routeList_street;
@property (nonatomic, strong) NSMutableArray* routeList_station;
@property (nonatomic, strong) UIButton* button_all;
@property (nonatomic, strong) UIButton* button_area;
@property (nonatomic, strong) UIButton* button_street;
@property (nonatomic, strong) UIButton* button_station;
@property (nonatomic, strong) NSMutableArray* keys;//索引
@property (strong, nonatomic) IBOutlet UITableView *tableview;

- (IBAction)button_back_clicked:(id)sender;
- (IBAction)button_ok_clicked:(id)sender;

@end
