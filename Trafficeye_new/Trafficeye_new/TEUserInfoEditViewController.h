//
//  TEUserInfoEditViewController.h
//  Trafficeye_new
//
//  Created by zc on 13-9-5.
//  Copyright (c) 2013年 张 驰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TESecondLevelViewController.h"
#import "TENetworkHandler.h"

@interface TEUserInfoEditViewController : TESecondLevelViewController<UITextFieldDelegate,UIPickerViewDelegate, UIPickerViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UserAvatarUploadDelegate,UserUpdateUserInfoDelegate>
@property (strong, nonatomic) NSArray* sexPickerData;
@property (nonatomic, assign) BOOL isEdit;
@property (strong, nonatomic) NSDictionary* myRewardDic;
@property (strong, nonatomic) IBOutlet UILabel *label_username;
@property (strong, nonatomic) IBOutlet UIImageView *imageview_avatar;
@property (strong, nonatomic) IBOutlet UITextField *textfield_nickname;
@property (strong, nonatomic) IBOutlet UITextField *textfield_realname;
@property (strong, nonatomic) IBOutlet UITextField *textfield_phonenumber;
@property (strong, nonatomic) IBOutlet UITextField *textfield_sex;
@property (strong, nonatomic) IBOutlet UITextField *textfield_birthday;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UIPickerView *sexPicker;
@property (strong, nonatomic) IBOutlet UIToolbar *accessoryView;
@property (strong, nonatomic) IBOutlet UIToolbar *sexAccessoryView;
@property (strong, nonatomic) IBOutlet UIImageView *loadingImage;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (strong, nonatomic) IBOutlet UIButton *button_save;
- (IBAction)buttonClicked:(id)sender;
- (IBAction)dateChanged:(id)sender;
- (IBAction)doneEditing:(id)sender;
- (IBAction)button_back_clicked:(id)sender;

@end
