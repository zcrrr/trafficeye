//
//  PayOrderViewController.h
//  TrafficEye_Clean
//
//  Created by 张 驰 on 13-7-3.
//
//

#import <UIKit/UIKit.h>
#import "TESecondLevelViewController.h"

@interface PayOrderViewController : TESecondLevelViewController
@property (strong, nonatomic)NSString *orderid;
@property (strong, nonatomic)NSString *totalCost;
@property (retain, nonatomic) IBOutlet UILabel *email;
@property (retain, nonatomic) IBOutlet UILabel *label_orderid;
@property (retain, nonatomic) IBOutlet UILabel *label_totalCost;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (strong, nonatomic) IBOutlet UIImageView *loadingImage;
@property (strong, nonatomic) IBOutlet UIButton *button_back;
@property (strong, nonatomic) IBOutlet UIButton *button_client_arrow;
@property (strong, nonatomic) IBOutlet UIButton *button_client;
@property (strong, nonatomic) IBOutlet UIButton *button_web_arrow;
@property (strong, nonatomic) IBOutlet UIButton *button_web;
@property (strong, nonatomic) IBOutlet UIButton *button_cft_arrow;
@property (strong, nonatomic) IBOutlet UIButton *button_cft;

- (IBAction)buttonClicked:(id)sender;
- (IBAction)button_back_clicked:(id)sender;

@end
