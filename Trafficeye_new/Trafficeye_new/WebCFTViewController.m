//
//  WebPayViewController.m
//  TrafficEye_Clean
//
//  Created by 张 驰 on 13-7-4.
//
//

#import "WebCFTViewController.h"
@interface WebCFTViewController ()

@end

@implementation WebCFTViewController
@synthesize orderid;
@synthesize subject;
@synthesize body;
@synthesize totalCost;

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
    self.webView.delegate = self;
    
    NSString* str_url = [NSString stringWithFormat:@"http://mobile.trafficeye.com.cn:8008/TenpayService/WAPPay?out_trade_no=%@&subject=%@&body=%@&total_fee=%@",self.orderid,@"路况交通眼商品",@"路况交通眼商品描述",self.totalCost];
    NSLog(@"url is%@",str_url);
    str_url = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)str_url, nil, nil, kCFStringEncodingGB_18030_2000);
    NSLog(@"url is%@",str_url);
    NSURL* url = [NSURL URLWithString:str_url];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    self.webView.scalesPageToFit = YES;
    // Do any additional setup after loading the view from its nib.
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    NSString *logString = [NSString stringWithFormat:@"%li,%@,%f %f;",
                           [TEUtil getNowTime],
                           [NSString stringWithFormat:@"I%@201105",LOG_VERSION],
                           [TEUtil getUserLocationLat],
                           [TEUtil getUserLocationLon]];
    [TEUtil appendStringToPlist:logString];
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self displayLoading];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self hideLoading];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)displayLoading{
    self.loadingImage.hidden = NO;
    [self.indicator startAnimating];
//    [self disableAllButton];
}
- (void)hideLoading{
    self.loadingImage.hidden = YES;
    [self.indicator stopAnimating];
//    [self enableAllButton];
}
- (void)disableAllButton{
    self.button_back.enabled = NO;
}
- (void)enableAllButton{
    self.button_back.enabled = YES;
}
- (IBAction)button_back_clicked:(id)sender {
    extern NSMutableArray *goodsArray;
    extern int goodsCount;
    goodsCount = 0;
    [goodsArray removeAllObjects];
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
