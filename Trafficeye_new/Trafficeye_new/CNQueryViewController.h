//
//  CNQueryViewController.h
//  WhereIsTheBus
//
//  Created by zc on 14-4-2.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TEFisrtLevelViewController.h"
@interface CNQueryViewController : TEFisrtLevelViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,SmartTipDelegate,OneLineInfoDelegate>

@property (strong, nonatomic) NSTimer* timer;
@property (assign, nonatomic) float two_second;
@property (assign, nonatomic) BOOL lineNOSelected;
@property (assign, nonatomic) BOOL lineNOCollapse;
@property (assign, nonatomic) BOOL directionSelected;
@property (assign, nonatomic) BOOL directionCollapse;
@property (assign, nonatomic) BOOL stationSelected;
@property (assign, nonatomic) BOOL stationCollapse;
@property (strong, nonatomic) NSMutableArray* lineNOList;
@property (strong, nonatomic) NSMutableArray* directionList;
@property (strong, nonatomic) NSMutableArray* stationList;
@property (strong, nonatomic) IBOutlet UILabel *label_change;
@property (assign, nonatomic) int selectDirIndex;
@property (strong, nonatomic) IBOutlet UIView *view_lineno;
@property (strong, nonatomic) IBOutlet UIView *view_direction;
@property (strong, nonatomic) IBOutlet UIView *view_station;
@property (strong, nonatomic) IBOutlet UITextField *textfield;
@property (strong, nonatomic) IBOutlet UITextField *textfield_dir;
@property (strong, nonatomic) IBOutlet UITextField *textfield_station;
@property (strong, nonatomic) IBOutlet UITableView *tableview_lineno;
@property (strong, nonatomic) IBOutlet UITableView *tableview_direction;
@property (strong, nonatomic) IBOutlet UITableView *tableview_station;
@property (strong, nonatomic) IBOutlet UIButton *arrow_lineNO;
@property (strong, nonatomic) IBOutlet UIButton *arrow_dir;
@property (strong, nonatomic) IBOutlet UIButton *arrow_station;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator_lineNO;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator_dir;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (strong, nonatomic) IBOutlet UIImageView *loadingImage;
- (IBAction)textEditChanged:(id)sender;
- (IBAction)button_lineNO_clicked:(id)sender;
- (IBAction)button_dir_clicked:(id)sender;
- (IBAction)button_station_clicked:(id)sender;
- (IBAction)button_quary_clicked:(id)sender;
- (IBAction)button_back_clicked:(id)sender;

@end
