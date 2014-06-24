//
//  CNStationViewController.h
//  WhereIsTheBus
//
//  Created by zc on 14-4-27.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CNStationViewController : UIViewController<OneLineDetailDelegate>
@property (assign, nonatomic) int y_interestStation;
@property (strong, nonatomic) NSString* linename;
@property (strong, nonatomic) NSString* stationName;
@property (strong, nonatomic) NSTimer* timer_one_minute;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollview_station;
@property (strong, nonatomic) NSMutableArray* stationList;
@property (strong, nonatomic) NSMutableArray* busList;
@property (strong, nonatomic) NSMutableDictionary* nearestbus;
@property (strong, nonatomic) UIView* bubbleView;
@property (strong, nonatomic) NSMutableDictionary* busInfoDic;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (strong, nonatomic) IBOutlet UIImageView *loadingImage;
- (IBAction)displayInMap:(id)sender;
- (IBAction)button_back_clicked:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *label_line_no;
@property (strong, nonatomic) IBOutlet UILabel *label_start;
@property (strong, nonatomic) IBOutlet UILabel *label_nearest_bus;
@property (strong, nonatomic) IBOutlet UIButton *button_back;
@property (strong, nonatomic) IBOutlet UIButton *button_map;

@end
