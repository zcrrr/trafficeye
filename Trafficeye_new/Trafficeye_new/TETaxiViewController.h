//
//  TETaxiViewController.h
//  Trafficeye_new
//
//  Created by 张 驰 on 13-6-17.
//  Copyright (c) 2013年 张 驰. All rights reserved.
//

#import "TEFisrtLevelViewController.h"
#import "CNMKMapView.h"
#import "LongPressAnno.h"
#import "TENetworkHandler.h"

@interface TETaxiViewController : TEFisrtLevelViewController<CNMKMapViewDelegate,taxiIndexDelegate,taxiEasyDelegate,taxiLongPressDelegate>

@property (strong, nonatomic) CNMKMapView* mapView;
@property (assign, nonatomic) BOOL isToolBarOn;
@property (strong, nonatomic) NSTimer* timerIndex;
@property (assign, nonatomic) int secondToHide;
@property (strong, nonatomic) LongPressAnno* anno_longPress;
@property (strong, nonatomic) NSMutableArray* annoViewArray;

@property (strong,nonatomic) IBOutlet UIView *view_index;
@property (strong,nonatomic) IBOutlet UIView *view_switch;
@property (retain, nonatomic) IBOutlet UIImageView *star1;
@property (retain, nonatomic) IBOutlet UIImageView *star2;
@property (retain, nonatomic) IBOutlet UIImageView *star3;
@property (retain, nonatomic) IBOutlet UIImageView *star4;
@property (retain, nonatomic) IBOutlet UIImageView *star5;
@property (retain, nonatomic) IBOutlet UILabel *suggestLabel;
@property (retain, nonatomic) IBOutlet UILabel *dateLabel;
@property (retain, nonatomic) IBOutlet UILabel *timeLabel;
@property (retain, nonatomic) IBOutlet UISwitch *switchEasy;
@property (retain, nonatomic) IBOutlet UISwitch *hotSwitch;
@property (retain, nonatomic) IBOutlet UISwitch *trafficSwitch;
@property (retain, nonatomic) IBOutlet UIImageView *hot_help_img;
- (IBAction)buttonPressed:(UIButton *)sender;
- (IBAction)switch_traffic:(UISwitch *)sender;
- (IBAction)switch_suggest:(UISwitch *)sender;
- (IBAction)switch_hot:(UISwitch *)sender;


@end
