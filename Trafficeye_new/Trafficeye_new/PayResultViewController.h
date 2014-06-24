//
//  PayResultViewController.h
//  TrafficEye_Clean
//
//  Created by 张 驰 on 13-7-4.
//
//

#import <UIKit/UIKit.h>

@interface PayResultViewController : UIViewController
@property (strong, nonatomic)NSString *orderid;
@property (strong, nonatomic)NSString *totalCost;
@property (retain, nonatomic) IBOutlet UILabel *email;
@property (retain, nonatomic) IBOutlet UILabel *label_orderid;
@property (retain, nonatomic) IBOutlet UILabel *label_totalCost;
- (IBAction)goBack:(id)sender;

@end
