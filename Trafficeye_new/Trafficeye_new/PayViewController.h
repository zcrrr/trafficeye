//
//  PayViewController.h
//  TrafficEye_Clean
//
//  Created by 张 驰 on 13-7-2.
//
//

#import <UIKit/UIKit.h>
#import "CollapseClick.h"
#import "TESecondLevelViewController.h"

@interface PayViewController : TESecondLevelViewController<CollapseClickDelegate,UITextFieldDelegate>
{
    IBOutlet UIView *test1View;
    IBOutlet UIView *test2View;
    
    IBOutlet CollapseClick *myCollapseClick;
}
@property (strong, nonatomic) IBOutlet UITextField *myTextField1;
@property (strong, nonatomic) IBOutlet UITextField *myTextField2;
@property (retain, nonatomic) IBOutlet UILabel *goodsCountLabel;
- (IBAction)button_back_clicked:(id)sender;



- (IBAction)textFieldDoneEditing:(id)sender;
- (IBAction)backgroundTap:(id)sender;
- (IBAction)putIntoCar:(id)sender;
- (IBAction)goPaying:(id)sender;


@end
