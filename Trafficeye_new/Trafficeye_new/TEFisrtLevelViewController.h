//
//  TEFisrtLevelViewController.h
//  Trafficeye_new
//
//  所有一级页面都继承这个类
//
//  Created by 张 驰 on 13-6-17.
//  Copyright (c) 2013年 张 驰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TEFisrtLevelViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic ,strong) UIImagePickerController* cameraPicker;
@property (nonatomic,assign) int selectedEventType;
@property (nonatomic,strong) NSMutableArray* viewArray;
@property (nonatomic, strong) UIView* view_toolbar;

@end
