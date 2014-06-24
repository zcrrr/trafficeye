//
//  MCOnboardViewController.h
//  BMWAppKitDemo
//
//  Created by shiny on 1/5/12.
//  Copyright (c) 2012 BMW Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCOnboardViewController : UIViewController
{
    IBOutlet UILabel*  statusLabel;
    IBOutlet UIActivityIndicatorView* activityIndicator;
    IBOutlet UIImageView*  logoView;
    IBOutlet UIImageView*  logoView_MINI;
}

@property (nonatomic, retain) IBOutlet UILabel*                 statusLabel;
@property (nonatomic, retain) IBOutlet UIImageView*             logoView;
@property (nonatomic, retain) IBOutlet UIImageView*             logoView_MINI;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView* activityIndicator;
@end
