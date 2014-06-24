//
//  WebPayViewController.h
//  TrafficEye_Clean
//
//  Created by 张 驰 on 13-7-4.
//
//

#import <UIKit/UIKit.h>
#import "TESecondLevelViewController.h"

@interface WebCFTViewController : TESecondLevelViewController<UIWebViewDelegate>
@property (strong, nonatomic) NSString *orderid;
@property (strong, nonatomic) NSString *subject;
@property (strong, nonatomic) NSString *body;
@property (strong, nonatomic) NSString *totalCost;
@property (retain, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (strong, nonatomic) IBOutlet UIImageView *loadingImage;
@property (strong, nonatomic) IBOutlet UIButton *button_back;
- (IBAction)button_back_clicked:(id)sender;

@end
