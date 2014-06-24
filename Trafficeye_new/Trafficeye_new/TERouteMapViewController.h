//
//  TERouteMapViewController.h
//  Trafficeye_new
//
//  Created by zc on 14-6-12.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TENetworkHandler.h"

@interface TERouteMapViewController : UIViewController<CNMKMapViewDelegate,routeDriveDelegate,routeWalkDelegate>
@property (strong, nonatomic) CNMKMapView* mapView;
@property (strong, nonatomic) NSString* startLon;
@property (strong, nonatomic) NSString* startLat;
@property (strong, nonatomic) NSString* endLon;
@property (strong, nonatomic) NSString* endLat;
@property (strong, nonatomic) NSString* routeJSON;
@property (assign, nonatomic) int pageType;
@property (strong, nonatomic) NSMutableArray* anno4remove;
@property (strong, nonatomic) NSMutableArray* polylineList;

@property (strong, nonatomic) IBOutlet UIButton *button_back;
@property (strong, nonatomic) IBOutlet UIButton *button_car;
@property (strong, nonatomic) IBOutlet UIButton *button_walk;
@property (strong, nonatomic) IBOutlet UIButton *button_bus;

@property (strong, nonatomic) IBOutlet UIButton *button_gps;
@property (strong, nonatomic) IBOutlet UIButton *button_zoomin;
@property (strong, nonatomic) IBOutlet UIButton *button_zoomout;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (strong, nonatomic) IBOutlet UIImageView *loadingImage;
- (IBAction)button_back_clicked:(id)sender;
- (IBAction)button_clicked:(id)sender;

@end
