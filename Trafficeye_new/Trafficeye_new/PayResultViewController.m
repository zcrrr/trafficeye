//
//  PayResultViewController.m
//  TrafficEye_Clean
//
//  Created by 张 驰 on 13-7-4.
//
//

#import "PayResultViewController.h"
#import "PayViewController.h"

@interface PayResultViewController ()

@end

@implementation PayResultViewController
@synthesize totalCost;
@synthesize orderid;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *emailAdd = [[TEAppDelegate getApplicationDelegate].userInfoDictionary objectForKey:@"email"];
    self.email.text = [NSString stringWithFormat:@"用户：%@",emailAdd];
    self.label_orderid.text = [NSString stringWithFormat:@"订单号：%@",self.orderid];
    self.label_totalCost.text = [NSString stringWithFormat:@"支付金额：￥%@",self.totalCost];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
//    NSString *logString = [NSString stringWithFormat:@"%li,%@,%f %f;",
//                           [TEUtil getNowTime],
//                           [NSString stringWithFormat:@"添加页面编号"],
//                           [TEUtil getUserLocationLat],
//                           [TEUtil getUserLocationLon]];
//    [TEUtil appendStringToPlist:logString];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    
    [super viewDidUnload];
}
- (IBAction)goBack:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:[NSString stringWithUTF8String:object_getClassName(self)]];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:[NSString stringWithUTF8String:object_getClassName(self)]];
}

@end
