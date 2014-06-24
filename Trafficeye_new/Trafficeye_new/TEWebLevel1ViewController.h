//
//  TEWebLevel1ViewController.h
//  Trafficeye_new
//
//  Created by zc on 14-5-26.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TEFisrtLevelViewController.h"
#import "TEShareCarViewController.h"
#import "TEPointInMapViewController.h"

@interface TEWebLevel1ViewController : TEFisrtLevelViewController<chooseLocationDelegate,UIWebViewDelegate,UIPickerViewDelegate, UIPickerViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UserAvatarUploadDelegate,ConfirmPointDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webview;
@property (strong, nonatomic) UIImagePickerController* avatarPicker;
@property (strong, nonatomic) NSString* entryHTML;
@property (strong, nonatomic) NSString* jsonParam;
@property (assign, nonatomic) int pageLevel;//一级页面或者二级页面
@property (assign, nonatomic) BOOL isfirst;
- (IBAction)button_test_clicked:(id)sender;
- (IBAction)button_display_point:(id)sender;
- (IBAction)button_line:(id)sender;

@end
