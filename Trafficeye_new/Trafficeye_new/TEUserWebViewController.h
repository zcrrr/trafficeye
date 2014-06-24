//
//  TEUserWebViewController.h
//  Trafficeye_new
//
//  Created by zc on 14-4-14.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TEFisrtLevelViewController.h"
#import "TENetworkHandler.h"

@interface TEUserWebViewController : TEFisrtLevelViewController<UIWebViewDelegate,UIPickerViewDelegate, UIPickerViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UserAvatarUploadDelegate>
@property (assign, nonatomic) int isEdit;
@property (assign, nonatomic) NSString* target;
@property (strong, nonatomic) NSString* goto_param;
@property (strong, nonatomic) IBOutlet UIWebView *webview;
@property (strong, nonatomic) UIImagePickerController* avatarPicker;

@end
