//
//  TEMapViewController.h
//  Trafficeye_new
//
//  Created by 张 驰 on 13-6-17.
//  Copyright (c) 2013年 张 驰. All rights reserved.
//

#import "TEFisrtLevelViewController.h"
#import "CNMKMapView.h"
#import "TENetworkHandler.h"

@interface TEMapViewController : TEFisrtLevelViewController<CNMKMapViewDelegate,getTrackDelegate,getEventDelegate>
@property (strong,nonatomic) CNMKMapView *mapView;
@property (strong, nonatomic) NSTimer* timerToolBar;
@property (assign, nonatomic) BOOL isToolBarOn;
@property (assign, nonatomic) int secondToHide;
@property (assign, nonatomic) BOOL initLocation;
@property (assign, nonatomic) BOOL isFollow;
@property (assign, nonatomic) BOOL isRequestingTrack;
@property (strong, nonatomic) NSMutableArray* trackArray;
@property (strong, nonatomic) NSMutableArray* trackPolylineArray;
@property (strong, nonatomic) NSMutableArray* trackAnnoArray;
@property (strong, nonatomic) NSTimer* timer_one_minute;
@property (strong, nonatomic) NSTimer* timer_five_minute;
@property (assign, nonatomic) BOOL isRequestingEvent;
@property (strong, nonatomic) NSMutableArray* eventArray;
@property (strong, nonatomic) NSMutableArray* eventAnnoArray;
@property (strong, nonatomic) NSMutableArray* tocStatus;



@property (strong, nonatomic) IBOutlet UIView *view_switch_board;
@property (strong, nonatomic) IBOutlet UISwitch *switch_traffic;
@property (strong, nonatomic) IBOutlet UISwitch *switch_track;
@property (strong, nonatomic) IBOutlet UISwitch *switch_event;
- (IBAction)button_clicked:(id)sender;
- (IBAction)switch_traffic_changed:(id)sender;
- (IBAction)switch_track_changed:(id)sender;
- (IBAction)switch_event_changed:(id)sender;

@end
