//
//  TEPointInMapViewController.h
//  Trafficeye_new
//
//  Created by zc on 14-6-8.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ConfirmPointDelegate <NSObject>
//登录接口成功或者失败的协议，如果失败了会有原因mes
- (void)confirmPointDidSuccess:(NSMutableDictionary*)dic;
- (void)confirmPointDidFailed:(NSString*)mes;
@end

@interface TEPointInMapViewController : UIViewController<CNMKMapViewDelegate>
@property (strong, nonatomic) NSString* lon;
@property (strong, nonatomic) NSString* lat;
@property (strong, nonatomic) NSString* locationName;
@property (strong, nonatomic) NSString* addr;
@property (strong, nonatomic) NSString* type;
@property (nonatomic, strong) id<ConfirmPointDelegate> delegate_confirmPoint;
@property (strong, nonatomic) CNMKMapView* mapView;
@property (strong, nonatomic) IBOutlet UIButton *button_back;
@property (strong, nonatomic) IBOutlet UILabel *label_locationName1;
@property (strong, nonatomic) IBOutlet UIButton *button_zoomin;
@property (strong, nonatomic) IBOutlet UIButton *button_zoomout;
@property (strong, nonatomic) IBOutlet UIButton *button_gps;
@property (strong, nonatomic) IBOutlet UILabel *label_locationName2;
@property (strong, nonatomic) IBOutlet UILabel *label_addr;
@property (strong, nonatomic) IBOutlet UIButton *button_go;
- (IBAction)button_back_clicked:(id)sender;
- (IBAction)button_go_clicked:(id)sender;
- (IBAction)button_clicked:(id)sender;

@end
