//
//  ShoppingCartViewController.h
//  TrafficEye_Clean
//
//  Created by 张 驰 on 13-7-3.
//
//

#import <UIKit/UIKit.h>
#import "TESecondLevelViewController.h"

@interface ShoppingCartViewController : TESecondLevelViewController
@property (retain, nonatomic) IBOutlet UIView *contentView;
@property (strong,nonatomic) UIView *listView;
@property (strong, nonatomic) IBOutlet UIButton *button_back;
@property (strong, nonatomic) IBOutlet UIButton *button_clear;
@property (strong, nonatomic) IBOutlet UIButton *button_continue;
@property (strong, nonatomic) IBOutlet UIButton *button_submit;


@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (strong, nonatomic) IBOutlet UIImageView *loadingImage;

- (IBAction)buttonClicked:(id)sender;
- (IBAction)button_back_clicked:(id)sender;


@end
