//
//  PayOrderViewController.m
//  TrafficEye_Clean
//
//  Created by 张 驰 on 13-7-3.
//
//

#import "PayOrderViewController.h"
#import "AlixPayOrder.h"
#import "AlixPay.h"
#import "DataSigner.h"
#import "PayResultViewController.h"
#import "Goods.h"
#import "WebPayViewController.h"
#import "WebCFTViewController.h"
#import "Util.h"
#import "ASIFormDataRequest.h"

@interface PayOrderViewController ()

@end

@implementation PayOrderViewController
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
    NSString* NOTIFICATION_GO_RESULT = @"GORESULT";
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(goResult) name:NOTIFICATION_GO_RESULT object:nil];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    NSString *logString = [NSString stringWithFormat:@"%li,%@,%f %f;",
                           [TEUtil getNowTime],
                           [NSString stringWithFormat:@"I%@201103",LOG_VERSION],
                           [TEUtil getUserLocationLat],
                           [TEUtil getUserLocationLon]];
    [TEUtil appendStringToPlist:logString];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setEmail:nil];
    [self setLabel_orderid:nil];
    [self setLabel_totalCost:nil];
    [super viewDidUnload];
}
- (IBAction)buttonClicked:(id)sender {
    switch ([(UIButton*)sender tag]) {
        case 0:
        {
            NSLog(@"客户端支付");
            NSString *partner = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Partner"];
            NSString *seller = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Seller"];
            
            //partner和seller获取失败,提示
            if ([partner length] == 0 || [seller length] == 0)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"缺少partner或者seller。"
                                                               delegate:self
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
                [alert show];
                return;
            }
            
            /*
             *生成订单信息及签名
             *由于demo的局限性，本demo中的公私钥存放在AlixPayDemo-Info.plist中,外部商户可以存放在服务端或本地其他地方。
             */
            //将商品信息赋予AlixPayOrder的成员变量
            AlixPayOrder *order = [[AlixPayOrder alloc] init];
            order.partner = partner;
            order.seller = seller;
            order.tradeNO = self.orderid; //订单ID（由商家自行制定）
            order.productName = @"路况交通眼商品"; //商品标题
            order.productDescription = @"goods des"; //商品描述
            order.amount = [NSString stringWithFormat:@"%.2f",0.01]; //商品价格
            order.notifyURL =  @"http://www.xxx.com"; //回调URL
            
            //应用注册scheme,在AlixPayDemo-Info.plist定义URL types,用于安全支付成功后重新唤起商户应用
            NSString *appScheme = @"trafficeye";
            
            //将商品信息拼接成字符串
            NSString *orderSpec = [order description];
            NSLog(@"orderSpec = %@",orderSpec);
            
            //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
            id<DataSigner> signer = CreateRSADataSigner([[NSBundle mainBundle] objectForInfoDictionaryKey:@"RSA private key"]);
            NSString *signedString = [signer signString:orderSpec];
            //将签名成功字符串格式化为订单字符串,请严格按照该格式
            NSString *orderString = nil;
            if (signedString != nil) {
                orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                               orderSpec, signedString, @"RSA"];
                
                //获取安全支付单例并调用安全支付接口
                AlixPay * alixpay = [AlixPay shared];
                int ret = [alixpay pay:orderString applicationScheme:appScheme];
                
                if (ret == kSPErrorAlipayClientNotInstalled) {
                    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" 
                                                                         message:@"您还没有安装支付宝快捷支付，请先安装。" 
                                                                        delegate:self 
                                                               cancelButtonTitle:@"确定" 
                                                               otherButtonTitles:nil];
                    [alertView setTag:123];
                    [alertView show];
                }
                else if (ret == kSPErrorSignError) {
                    NSLog(@"签名错误！");
                }
                
            }

            break;
        }
        case 1:
        {
            NSLog(@"网页支付");
            WebPayViewController* wpVC = [[WebPayViewController alloc]init];
            wpVC.orderid = orderid;
            wpVC.totalCost = self.totalCost;
            [self.navigationController pushViewController:wpVC animated:YES];

            break;
            
        }
        case 2:
        {
            NSLog(@"财付通支付");
            WebCFTViewController* cftVC = [[WebCFTViewController alloc]init];
            cftVC.orderid = orderid;
            cftVC.totalCost = self.totalCost;
            [self.navigationController pushViewController:cftVC animated:YES];
            
            break;
            
        }
        default:
            break;
    }
}

- (IBAction)button_back_clicked:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (alertView.tag == 123) {
		NSString * URLString = @"http://itunes.apple.com/cn/app/id535715926?mt=8";
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLString]];
	}
}
- (NSString*)getProductString{
    NSMutableString *goodsStr = [NSMutableString stringWithString:@""];
    extern NSMutableArray *goodsArray;
    int i = 0;
    for(i = 0;i<[goodsArray count];i++){
        Goods *goodsTemp = [goodsArray objectAtIndex:i];
        [goodsStr appendString:[NSString stringWithFormat:@"%i-%i",goodsTemp.type,goodsTemp.count]];
        if(i < [goodsArray count]-1){
            [goodsStr appendString:@","];
        }
    }
    NSLog(@"goodStr is %@",goodsStr);
    return goodsStr;
}

- (void)goResult{
    NSLog(@"result");
    //更改订单状态
    NSString *uid = [[TEAppDelegate getApplicationDelegate] getUid];
    if(uid.length == 0){
        uid = @"0";
    }
    
    NSString* str_url = [NSString stringWithFormat:@"http://mobile.trafficeye.com.cn:8090/TrafficeyeOrderManager/order?format=json"];
    NSURL *url= [ NSURL URLWithString : str_url];
    NSLog(@"url is %@",url);
    ASIFormDataRequest *request1 = [ ASIFormDataRequest requestWithURL :url];
    
    [request1 addRequestHeader:@"X-PID" value:[TEAppDelegate getApplicationDelegate].pid];
    [request1 addRequestHeader:@"User-Agent" value:[TEAppDelegate getApplicationDelegate].userAgent];
    [request1 addRequestHeader:@"Accept" value:@"application/x-www-form-urlencoded"];
    [request1 setRequestMethod:@"POST"];
    [request1 setPostValue:self.orderid forKey:@"orderId"];
    [request1 setPostValue:@"支付成功" forKey:@"state"];
    [request1 setPostValue:@"aipay" forKey:@"payway"];
    [request1 setPostValue:uid forKey:@"uid"];
    [request1 setPostValue:[self getProductString] forKey:@"product"];
    [request1 setDelegate : self];
    [request1 startAsynchronous];
    
    
    extern NSMutableArray *goodsArray;
    extern int goodsCount;
    goodsCount = 0;
    [goodsArray removeAllObjects];
    PayResultViewController* PrVC = [[PayResultViewController alloc]init];
    PrVC.orderid = self.orderid;
    PrVC.totalCost = self.totalCost;
    [self.navigationController pushViewController:PrVC animated:YES];
}
- ( void )requestFinished:( ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    NSLog(@"---服务器返回结果是%@",responseString);
}
- (void)displayLoading{
    self.loadingImage.hidden = NO;
    [self.indicator startAnimating];
    [self disableAllButton];
}
- (void)hideLoading{
    self.loadingImage.hidden = YES;
    [self.indicator stopAnimating];
    [self enableAllButton];
}
- (void)disableAllButton{
    self.button_back.enabled = NO;
    self.button_client_arrow.enabled = NO;
    self.button_client.enabled = NO;
    self.button_web_arrow.enabled = NO;
    self.button_web.enabled = NO;
    self.button_cft_arrow.enabled = NO;
    self.button_cft.enabled = NO;
    
}
- (void)enableAllButton{
    self.button_back.enabled = YES;
    self.button_client_arrow.enabled = YES;
    self.button_client.enabled = YES;
    self.button_web_arrow.enabled = YES;
    self.button_web.enabled = YES;
    self.button_cft_arrow.enabled = YES;
    self.button_cft.enabled = YES;
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
