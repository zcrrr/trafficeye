//
//  TEShareCarViewController.h
//  Trafficeye_new
//
//  Created by zc on 14-5-21.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TESecondLevelViewController.h"
@protocol chooseLocationDelegate <NSObject>
//登录接口成功或者失败的协议，如果失败了会有原因mes
- (void)chooseLocationDidSuccess:(NSMutableDictionary*)dic;
- (void)chooseLocationDidFailed:(NSString*)mes;
@end


@interface TEShareCarViewController : TESecondLevelViewController<CNMKMapViewDelegate,FindPoiDelegate,UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) NSString* type;
@property (strong, nonatomic) CNMKMapView* mapView;
@property (strong, nonatomic) NSMutableArray* poiList;
@property (assign, nonatomic) int currentSelectedIndex;
@property (nonatomic, strong) id<chooseLocationDelegate> delegate_chooseLocation;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (strong, nonatomic) IBOutlet UIImageView *loadingImage;
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) IBOutlet UIButton *button_save;
- (IBAction)button_save_clicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *button_back;
- (IBAction)button_back_clicked:(id)sender;
- (IBAction)button_clicked:(id)sender;

@end
