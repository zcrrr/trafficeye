//
//  TECommunityBaseViewController.h
//  Trafficeye_new
//
//  Created by zc on 14-3-17.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TECommunityBaseViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic ,strong) UIImagePickerController* cameraPicker;
@property (nonatomic,assign) int selectedEventType;
@property (nonatomic,strong) NSMutableArray* viewArray;

@end
