//
//  MenuViewController.h
//  TrafficEye_Clean
//
//  Created by zc on 13-9-17.
//
//

#import <UIKit/UIKit.h>
#import "TENetworkHandler.h"

@interface MenuViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,messageCountDelegate>

@property (strong, nonatomic) NSArray* menuItemArray;
@property (strong, nonatomic) NSArray* imageArray;
@property (strong, nonatomic) IBOutlet UIButton *button_order_car;
@property (strong, nonatomic) NSArray* imagePressedArray;
@property (retain, nonatomic) IBOutlet UIImageView *imageview_avatar;
@property (retain, nonatomic) IBOutlet UILabel *label_username;
@property (retain, nonatomic) IBOutlet UIView *view_avatar;
@property (strong, nonatomic) IBOutlet UIView *image_reddot;
@property (strong, nonatomic) IBOutlet UILabel *label_messageCount;
- (IBAction)goUserPage:(id)sender;
- (IBAction)button_setting_clicked:(id)sender;
- (IBAction)button_message_clicked:(id)sender;
- (IBAction)button_bmw:(id)sender;
- (IBAction)button_qrcode_clicked:(id)sender;
- (IBAction)button_ordercar_clicked:(id)sender;
@end
