//
//  TEBusMapViewController.h
//  Trafficeye_new
//
//  Created by zc on 14-5-12.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CNMKMapView.h"
#import "CNMapKit.h"
#import "TEBusBubbleAnno.h"

@interface TEBusMapViewController : UIViewController<CNMKMapViewDelegate,OneLineDetailDelegate>
@property (strong, nonatomic) NSTimer* timer_one_minute;
@property (strong, nonatomic) NSString* linename;
@property (strong, nonatomic) NSString* stationName;
@property (strong, nonatomic) CNMKMapView* mapView;
@property (strong, nonatomic) NSMutableArray* stationList;
@property (strong, nonatomic) NSMutableArray* busList;
@property (strong, nonatomic) NSString* pointsString;
@property (strong, nonatomic) CNMKPolyline* polyline;
@property (strong, nonatomic) NSMutableArray* anno4remove;
@property (strong, nonatomic) TEBusBubbleAnno* busBubbleAnno;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (strong, nonatomic) IBOutlet UIImageView *loadingImage;
- (IBAction)button_back_clicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *button_back;

@end
