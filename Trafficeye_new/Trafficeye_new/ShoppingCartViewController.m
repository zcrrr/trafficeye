//
//  ShoppingCartViewController.m
//  TrafficEye_Clean
//
//  Created by 张 驰 on 13-7-3.
//
//

#import "ShoppingCartViewController.h"
#import "Goods.h"
#import "PayViewController.h"
#import "SBJson.h"
#import "PayOrderViewController.h"
#import "Util.h"
#import "ASIHTTPRequest.h"

@interface ShoppingCartViewController ()

@end

@implementation ShoppingCartViewController
@synthesize contentView;
@synthesize listView;

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
    [self initListView];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    NSString *logString = [NSString stringWithFormat:@"%li,%@,%f %f;",
                           [TEUtil getNowTime],
                           [NSString stringWithFormat:@"I%@201102",LOG_VERSION],
                           [TEUtil getUserLocationLat],
                           [TEUtil getUserLocationLon]];
    [TEUtil appendStringToPlist:logString];
}
- (void)deleteOneRow:(id)sender{
    NSLog(@"sender is %i",[(UIButton*)sender tag]);
    extern NSMutableArray *goodsArray;
    extern int goodsCount;
    Goods *goodsTemp = [goodsArray objectAtIndex:[(UIButton*)sender tag]];
    goodsCount = goodsCount - goodsTemp.count;
    [goodsArray removeObjectAtIndex:[(UIButton*)sender tag]];
    
    [self.listView removeFromSuperview];
    [self initListView];
    
}
- (void)initListView{
    extern NSMutableArray *goodsArray;
    NSLog(@"length is %i",[goodsArray count]);
    int row = [goodsArray count];
//    self.contentView.frame = CGRectMake(5, 50, 310, 5+25+row*45+25+5+35+5+35+5);
    CGRect newFrame = self.contentView.frame;
    newFrame.size = CGSizeMake(310, 5+25+row*45+25+5+35+5+35+5);
    self.contentView.frame = newFrame;
    listView = [[UIView alloc]initWithFrame:CGRectMake(5, 30, 300, row*45+25)];
    [listView setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:listView];
    
    int i = 0;
    float total = 0.0;
    for(i=0;i<[goodsArray count];i++){
        Goods *goodsTemp = [goodsArray objectAtIndex:i];
        total = total + goodsTemp.subtotal;
        UILabel* label_name = [[UILabel alloc]initWithFrame:CGRectMake(0, 0+i*45, 115, 45)];
        label_name.text = goodsTemp.name;
        label_name.backgroundColor = [UIColor whiteColor];
        label_name.textAlignment = NSTextAlignmentCenter;
        label_name.font = [UIFont systemFontOfSize: 13];
        [listView addSubview:label_name];
        
        UILabel* label_price = [[UILabel alloc]initWithFrame:CGRectMake(115, 0+i*45, 50, 45)];
        label_price.text = [NSString stringWithFormat:@"￥%.2f",goodsTemp.price];
        label_price.backgroundColor = [UIColor whiteColor];
        label_price.textAlignment = NSTextAlignmentRight;
        label_price.font = [UIFont systemFontOfSize: 12];
        [listView addSubview:label_price];
        
        UILabel* label_count = [[UILabel alloc]initWithFrame:CGRectMake(165, 0+i*45, 40, 45)];
        label_count.text = [NSString stringWithFormat:@"%i",goodsTemp.count];
        label_count.backgroundColor = [UIColor whiteColor];
        label_count.textAlignment = NSTextAlignmentCenter;
        label_count.font = [UIFont systemFontOfSize: 12];
        [listView addSubview:label_count];
        
        UILabel* label_subtotal = [[UILabel alloc]initWithFrame:CGRectMake(205, 0+i*45, 50, 45)];
        label_subtotal.text = [NSString stringWithFormat:@"￥%.2f",goodsTemp.subtotal];
        label_subtotal.backgroundColor = [UIColor whiteColor];
        label_subtotal.textAlignment = NSTextAlignmentRight;
        label_subtotal.font = [UIFont systemFontOfSize: 12];
        [listView addSubview:label_subtotal];
        
        UIButton* button_close = [UIButton buttonWithType:UIButtonTypeCustom];
        [button_close setBackgroundImage:[UIImage imageNamed:@"list_item_delete.png"] forState:UIControlStateNormal];
        [button_close setBackgroundImage:[UIImage imageNamed:@"list_item_delete.png"] forState:UIControlStateSelected];
        [button_close setBackgroundColor:[UIColor whiteColor]];
        [button_close setFrame:CGRectMake(255, 0+i*45, 45, 45)];
        [listView addSubview:button_close];
        button_close.tag = i;
        [button_close addTarget:self action:@selector(deleteOneRow:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    UILabel* label_total = [[UILabel alloc]initWithFrame:CGRectMake(165, 0+i*45, 135, 25)];
    label_total.text = [NSString stringWithFormat:@"金额合计：￥%.2f",total];
    label_total.backgroundColor = [UIColor whiteColor];
    label_total.textAlignment = NSTextAlignmentLeft;
    label_total.font = [UIFont systemFontOfSize: 15];
    [listView addSubview:label_total];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setContentView:nil];
    [super viewDidUnload];
}
- (IBAction)buttonClicked:(id)sender {
    switch ([(UIButton*)sender tag]) {
        case 0:
        {
            extern NSMutableArray *goodsArray;
            extern int goodsCount;
            goodsCount = 0;
            [goodsArray removeAllObjects];
            [self.listView removeFromSuperview];
            break;
        }
        case 1:
        {
            PayViewController* payVC = [[PayViewController alloc]init];
            [self.navigationController pushViewController:payVC animated:YES];
            break;
        }
        case 2:
        {
            [self submitOrder];
            break;
        }
        default:
            break;
    }
}

- (IBAction)button_back_clicked:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)submitOrder{
    NSString* uid = [[TEAppDelegate getApplicationDelegate] getUid];
    if(uid.length == 0){
        uid = @"0";
    }
    NSString* str_url = [NSString stringWithFormat:@"http://mobile.trafficeye.com.cn:8090/TrafficeyeOrderManager/order?uid=%@&product=%@&format=json",uid,[self getProductString]];
    NSURL *url= [ NSURL URLWithString : str_url];
    NSLog(@"url is %@",url);
    ASIHTTPRequest *request = [ ASIHTTPRequest requestWithURL :url];
    [request addRequestHeader:@"X-PID" value:[TEAppDelegate getApplicationDelegate].pid];
    [request addRequestHeader:@"User-Agent" value:[TEAppDelegate getApplicationDelegate].userAgent];
    [request setDelegate : self];
    [request startAsynchronous];
    [self displayLoading];
}
- ( void )requestFinished:( ASIHTTPRequest *)request
{
    [self hideLoading];
    NSString *responseString = [request responseString];
    NSLog(@"---服务器返回结果是%@",responseString);
    SBJsonParser *jsonParser = [[SBJsonParser alloc]init];
    id result = [jsonParser objectWithString:responseString];
    NSString *state = [result objectForKey:@"state"];
    NSString *orderid = [result objectForKey:@"orderid"];
    NSString *totleCost = [result objectForKey:@"totleCost"];
    NSLog(@"orderid is %@",orderid);
    NSLog(@"totleCost is %@",totleCost);
    NSLog(@"state is %@",state);
    PayOrderViewController* POVC = [[PayOrderViewController alloc]init];
    POVC.orderid = orderid;
    POVC.totalCost = totleCost;
    [self.navigationController pushViewController:POVC animated:YES];
}
- (void) requestFaild:( ASIHTTPRequest *)request{
    NSLog(@"faild resean is %@",request.error.description);
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
    self.button_clear.enabled = NO;
    self.button_continue.enabled =  NO;
    self.button_submit.enabled = NO;
}
- (void)enableAllButton{
    self.button_back.enabled = YES;
    self.button_clear.enabled = YES;
    self.button_continue.enabled =  YES;
    self.button_submit.enabled = YES;
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
