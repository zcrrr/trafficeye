//
//  PayViewController.m
//  TrafficEye_Clean
//
//  Created by 张 驰 on 13-7-2.
//
//

#import "PayViewController.h"
#import "Goods.h"
#import "ShoppingCartViewController.h"
#import "Util.h"

@interface PayViewController ()

@end

@implementation PayViewController
@synthesize goodsCountLabel;
//外部变量goodsArray和goodsCount记录选购的商品
NSMutableArray *goodsArray;
int goodsCount;

- (void)viewDidLoad
{
    [super viewDidLoad];
    myCollapseClick.CollapseClickDelegate = self;
    self.myTextField2.delegate = self;
    self.myTextField1.delegate = self;
    [myCollapseClick reloadCollapseClick];
    if(!goodsArray){
        goodsArray = [[NSMutableArray alloc]init];
        goodsCount = 0;
    }
    self.goodsCountLabel.text = [NSString stringWithFormat:@"购物车共%i件商品",goodsCount];
    

}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    NSString *logString = [NSString stringWithFormat:@"%li,%@,%f %f;",
                           [TEUtil getNowTime],
                           [NSString stringWithFormat:@"I%@201101",LOG_VERSION],
                           [TEUtil getUserLocationLat],
                           [TEUtil getUserLocationLon]];
    [TEUtil appendStringToPlist:logString];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Collapse Click Delegate

// Required Methods
-(int)numberOfCellsForCollapseClick {
    return 2;
}

-(NSString *)titleForCollapseClickAtIndex:(int)index {
    switch (index) {
        case 0:
            return @"交通眼捐献1";
            break;
        case 1:
            return @"交通眼捐献2";
            break;
        default:
            return @"";
            break;
    }
}

-(UIView *)viewForCollapseClickContentViewAtIndex:(int)index {
    switch (index) {
        case 0:
            return test1View;
            break;
        case 1:
            return test2View;
            break;
            
        default:
            return test1View;
            break;
    }
}


-(void)didClickCollapseClickCellAtIndex:(int)index isNowOpen:(BOOL)open {
    NSLog(@"%d and it's open:%@", index, (open ? @"YES" : @"NO"));
}

- (IBAction)button_back_clicked:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - TextField Delegate for Demo

- (IBAction)textFieldDoneEditing:(id)sender {
    NSLog(@"zc");
    [sender resignFirstResponder];
}
- (IBAction)backgroundTap:(id)sender{
    [self.myTextField1 resignFirstResponder];
    [self.myTextField2 resignFirstResponder];
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;
    [UIView commitAnimations];
}
- (void)keyboardWillShow:(NSNotification *)noti
{
    //键盘输入的界面调整
    //键盘的高度
    float height = 216.0;
    CGRect frame = self.view.frame;
    frame.size = CGSizeMake(frame.size.width, frame.size.height - height);
    [UIView beginAnimations:@"Curl"context:nil];//动画开始
    [UIView setAnimationDuration:0.30];
    [UIView setAnimationDelegate:self];
    [self.view setFrame:frame];
    [UIView commitAnimations];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // When the user presses return, take focus away from the text field so that the keyboard is dismissed.
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 20.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;
    [UIView commitAnimations];
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGPoint point = [textField.superview convertPoint:textField.frame.origin toView:nil];
    int offset = point.y + 32 - (self.view.frame.size.height - 216.0);//键盘高度216
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    if(offset > 0)
    {
        CGRect rect = CGRectMake(0.0f, -offset,width,height);
        self.view.frame = rect;
    }
    [UIView commitAnimations];
}
- (IBAction)putIntoCar:(id)sender{
    [self backgroundTap:sender];
    switch ([(UIButton*)sender tag]) {
        case 1:
        {
            NSString *text1 = self.myTextField1.text;
            if(![text1 isEqualToString:@""]){
                NSLog(@"1号购买数量是%@",self.myTextField1.text);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"成功添加到购物车" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                Goods *goods1 = [[Goods alloc]init];
                goods1.type = 1;
                goods1.name = @"交通眼捐献1";
                goods1.price = 0.01;
                goods1.count = [text1 intValue];
                [goods1 calSubtotal];
                [self addGoodsToArray:goods1];
                goodsCount = goodsCount+goods1.count;
                self.goodsCountLabel.text = [NSString stringWithFormat:@"购物车共%i件商品",goodsCount];
            }else{
                NSLog(@"请输入数量");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请输入数量" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
            break;
        }
            
        case 2:
        {
            NSString *text2 = self.myTextField2.text;
            if(![text2 isEqualToString:@""]){
                NSLog(@"2号购买数量是%@",self.myTextField2.text);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"成功添加到购物车" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                Goods *goods2 = [[Goods alloc]init];
                goods2.type = 2;
                goods2.name = @"交通眼捐献2";
                goods2.price = 10;
                goods2.count = [text2 intValue];
                [goods2 calSubtotal];
                [self addGoodsToArray:goods2];
                goodsCount = goodsCount+goods2.count;
                self.goodsCountLabel.text = [NSString stringWithFormat:@"购物车共%i件商品",goodsCount];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请输入数量" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
            break;
        }
        default:
            break;
    }
}

- (IBAction)goPaying:(id)sender {
    NSLog(@"goPaying");
    if(goodsCount == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"购物车为空" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        ShoppingCartViewController* scVC = [[ShoppingCartViewController alloc]init];
        [self.navigationController pushViewController:scVC animated:YES];

    }

}

- (void)viewDidUnload {
    [self setGoodsCountLabel:nil];
    [super viewDidUnload];
}
- (void)addGoodsToArray:(Goods *)goods{
    int type = goods.type;
    int i = 0;
    for(i = 0;i<[goodsArray count];i++){
        Goods *goodsTemp = [goodsArray objectAtIndex:i];
        if(goodsTemp.type == type)break;
    }
    if(i<[goodsArray count]){
        Goods *goodsTemp = [goodsArray objectAtIndex:i];
        goodsTemp.count = goodsTemp.count+goods.count;
        [goodsTemp calSubtotal];
    }else{
        [goodsArray addObject:goods];
    }
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
