//
//  MenuViewController.m
//  TrafficEye_Clean
//
//  Created by zc on 13-9-17.
//
//

#import "MenuViewController.h"
#import "DDMenuController.h"
#import "TEPersistenceHandler.h"
#import "TEAboutBMWViewController.h"
#import "TEQrcodeViewController.h"
#import "Toast+UIView.h"

@interface MenuViewController ()

@end

@implementation MenuViewController
@synthesize menuItemArray;
@synthesize imageArray;
@synthesize imagePressedArray;
int selectedIndex;
int newestMessageCount = 0;

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
    if(iPhone5){
        self.view_avatar.frame = CGRectOffset(self.view_avatar.frame, 0, 40);
    }
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSArray* array = [[NSArray alloc]initWithObjects: @"地图",@"简图",@"交通指数",@"出租车",@"实时公交",@"拼车",@"有奖调查",@"交通资讯",@"交通微博",nil];
    self.menuItemArray = array;
    UIImage *image1 = [UIImage imageNamed:@"navi_map.png"];
    UIImage *image2 = [UIImage imageNamed:@"navi_sigra.png"];
    UIImage *image3 = [UIImage imageNamed:@"navi_index.png"];
    UIImage *image4 = [UIImage imageNamed:@"navi_taxi.png"];
    UIImage *image5 = [UIImage imageNamed:@"navi_bus.png"];
    UIImage *image6 = [UIImage imageNamed:@"navi_carsharing.png"];
    UIImage *image7 = [UIImage imageNamed:@"navi_survey.png"];
    UIImage *image8 = [UIImage imageNamed:@"navi_info.png"];
    UIImage *image9 = [UIImage imageNamed:@"navi_weibo.png"];
    
    
    NSArray* array2 = [[NSArray alloc]initWithObjects:image1,image2,image3,image4,image5,image6,image7,image8,image9,nil];
    self.imageArray = array2;
    UIImage *image11 = [UIImage imageNamed:@"navi_map_on.png"];
    UIImage *image12 = [UIImage imageNamed:@"navi_sigra_on.png"];
    UIImage *image13 = [UIImage imageNamed:@"navi_index_on.png"];
    UIImage *image14 = [UIImage imageNamed:@"navi_taxi_on.png"];
    UIImage *image15 = [UIImage imageNamed:@"navi_bus_on.png"];
    UIImage *image16 = [UIImage imageNamed:@"navi_carsharing_on.png"];
    UIImage *image17 = [UIImage imageNamed:@"navi_survey_on.png"];
    UIImage *image18 = [UIImage imageNamed:@"navi_info_on.png"];
    UIImage *image19 = [UIImage imageNamed:@"navi_weibo_on.png"];
    
    NSArray* array3 = [[NSArray alloc]initWithObjects:image11,image12,image13,image14,image15,image16,image17,image18,image19,nil];
    self.imagePressedArray = array3;
    NSString* NOTIFICATION_SETUSERINFO = @"NOTIFICATION_SETUSERINFO";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initUser) name:NOTIFICATION_SETUSERINFO object:nil];
    
    NSString* NOTIFICATION_CLEARUSERINFO = @"NOTIFICATION_CLEARUSERINFO";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearUser) name:NOTIFICATION_CLEARUSERINFO object:nil];
}
- (void)displayOrHideOrderCar{
    if([TEAppDelegate getApplicationDelegate].isLogin == 0){
        self.button_order_car.hidden = YES;
    }else{
        int userGroup = [[[TEAppDelegate getApplicationDelegate].userInfoDictionary objectForKey:@"userGroup"]intValue];
        if(userGroup == 0){
            self.button_order_car.hidden = YES;
        }else if(userGroup == 1){
            self.button_order_car.hidden = NO;
        }
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self displayOrHideOrderCar];
    if ([TEAppDelegate getApplicationDelegate].isLogin == 1){
        NSLog(@"initUser");
        [self initUser];
    }
    [MobClick beginLogPageView:[NSString stringWithUTF8String:object_getClassName(self)]];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
//    NSString *logString = [NSString stringWithFormat:@"%li,%@,%f %f;",
//                           [TEUtil getNowTime],
//                           [NSString stringWithFormat:@"添加页面编号"],
//                           [TEUtil getUserLocationLat],
//                           [TEUtil getUserLocationLon]];
//    [TEUtil appendStringToPlist:logString];
    if([TEAppDelegate getApplicationDelegate].isLogin == 1){
        [TEAppDelegate getApplicationDelegate].networkHandler.delegate_messageCount = self;
        [[TEAppDelegate getApplicationDelegate].networkHandler doRequest_messageCount];
    }else{
        self.image_reddot.hidden = YES;
    }
}
- (void)initUser{
    NSDictionary* dic = [TEAppDelegate getApplicationDelegate].userInfoDictionary;
    //先判断dic里有没有图片数据
    NSData* imageData = [TEAppDelegate getApplicationDelegate].imageData;
    if(imageData){
        self.imageview_avatar.image = [[UIImage alloc] initWithData:imageData];
    }else{
        NSString *avatar = [dic objectForKey:@"avatarUrl"];
        if(![TEUtil isStringNULL:avatar]){
            NSString* imageURL = [NSString stringWithFormat:@"%@",avatar];
            NSLog(@"avatar is %@",imageURL);
            NSURL *url = [NSURL URLWithString:imageURL];
            ASIHTTPRequest *Imagerequest = [ASIHTTPRequest requestWithURL:url];
            Imagerequest.tag = 1;
            Imagerequest.timeOutSeconds = 15;
            [Imagerequest setDelegate:self];
            [Imagerequest startAsynchronous];
        }
    }
    self.label_username.text = [dic objectForKey:@"username"];
    [self displayOrHideOrderCar];
}
#pragma -mark ASIHttpRequest delegate
- (void)requestFinished:(ASIHTTPRequest *)request{
    UIImage *image = [[UIImage alloc] initWithData:[request responseData]];
    if(image){
        self.imageview_avatar.image = image;
        [TEAppDelegate getApplicationDelegate].imageData = [request responseData];
    }
}
- (void)clearUser{
    self.imageview_avatar.image = [UIImage imageNamed:@"icon_noavatar"];
    self.label_username.text = @"登录/注册";
    [self displayOrHideOrderCar];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.menuItemArray count];
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *TableIdentifier = @"TableIdentifier";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:TableIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableIdentifier];
    }
    NSUInteger row = [indexPath row];
    cell.textLabel.text = [self.menuItemArray objectAtIndex:row];
    cell.imageView.image = [self.imageArray objectAtIndex:row];
    if(row == selectedIndex){
        cell.imageView.image = [self.imagePressedArray objectAtIndex:row];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	
	// set the root controller
    DDMenuController *menuController = [TEAppDelegate getApplicationDelegate].menuController;
    NSArray* array = [TEAppDelegate getApplicationDelegate].navControllers;
	NSLog(@"------>%i",indexPath.row);
    if(indexPath.row == INDEX_PAGE_SHARECAR){
        if([TEAppDelegate getApplicationDelegate].isLogin != 1){
            [self.view makeToast:@"请先登录"];
            return;
        }
    }
    [menuController setRootController:[array objectAtIndex:indexPath.row] animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    for(int i=0;i<[self.menuItemArray count];i++){//所有行图标重置
        NSIndexPath *temp = [NSIndexPath indexPathForRow:i inSection:0];
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:temp];
        oldCell.imageView.image = [self.imageArray objectAtIndex:temp.row];
    }
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    newCell.imageView.image = [self.imagePressedArray objectAtIndex:indexPath.row];
    selectedIndex = indexPath.row;
}


- (IBAction)goUserPage:(id)sender {
    selectedIndex = INDEX_PAGE_USER;
    NSArray* array = [TEAppDelegate getApplicationDelegate].navControllers;
    DDMenuController *menuController = [TEAppDelegate getApplicationDelegate].menuController;
    [menuController setRootController:[array objectAtIndex:INDEX_PAGE_USER] animated:YES];
}

- (IBAction)button_setting_clicked:(id)sender {
    selectedIndex = INDEX_PAGE_SETTING;
    NSArray* array = [TEAppDelegate getApplicationDelegate].navControllers;
    DDMenuController *menuController = [TEAppDelegate getApplicationDelegate].menuController;
    [menuController setRootController:[array objectAtIndex:INDEX_PAGE_SETTING] animated:YES];
}

- (IBAction)button_message_clicked:(id)sender {
    if([TEAppDelegate getApplicationDelegate].isLogin == 0){
        UIAlertView* alert =[[UIAlertView alloc] initWithTitle:nil message:@"请先登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        NSArray* array = [TEAppDelegate getApplicationDelegate].navControllers;
        DDMenuController *menuController = (DDMenuController*)[TEAppDelegate getApplicationDelegate].menuController;
        [menuController setRootController:[array objectAtIndex:INDEX_PAGE_USER] animated:YES];
        selectedIndex = INDEX_PAGE_USER;
        return;
    }
    selectedIndex = INDEX_PAGE_MESSAGE;
//    self.image_reddot.hidden = YES;
//    //本地记录看到多少条了
//    NSMutableDictionary* dic_message = [[NSMutableDictionary alloc]init];
//    extern int newestMessageCount;
//    [dic_message setObject:[NSString stringWithFormat:@"%i",newestMessageCount] forKey:@"count"];
//    NSString* filePath = [TEPersistenceHandler getDocument:@"message.plist"];
//    [dic_message writeToFile:filePath atomically:YES];
    
    
    NSArray* array = [TEAppDelegate getApplicationDelegate].navControllers;
    DDMenuController *menuController = [TEAppDelegate getApplicationDelegate].menuController;
    [menuController setRootController:[array objectAtIndex:INDEX_PAGE_MESSAGE] animated:YES];
}

- (IBAction)button_bmw:(id)sender {
    TEAboutBMWViewController* bmwVC = [[TEAboutBMWViewController alloc]init];
    UIViewController* rootViewController =  [[UIApplication sharedApplication] keyWindow].rootViewController;
    rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
    [rootViewController presentViewController:bmwVC animated:YES completion:nil];
}

- (IBAction)button_qrcode_clicked:(id)sender {
    TEQrcodeViewController* qrcodeVC = [[TEQrcodeViewController alloc]init];
    UIViewController* rootViewController =  [[UIApplication sharedApplication] keyWindow].rootViewController;
    rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
    [rootViewController presentViewController:qrcodeVC animated:YES completion:nil];
}

- (IBAction)button_ordercar_clicked:(id)sender {
    selectedIndex = INDEX_PAGE_ORDER;
    NSArray* array = [TEAppDelegate getApplicationDelegate].navControllers;
    DDMenuController *menuController = [TEAppDelegate getApplicationDelegate].menuController;
    [menuController setRootController:[array objectAtIndex:INDEX_PAGE_ORDER] animated:YES];
}
- (void)viewDidUnload {
    [self setImageview_avatar:nil];
    [self setLabel_username:nil];
    [self setView_avatar:nil];
    [super viewDidUnload];
}
#pragma -mark message count delegate
- (void)messageCountDidFailed:(NSString *)mes{
    
}
- (void)messageCountDidSuccess:(NSDictionary *)dic{
//    NSString* count_new_str = [dic objectForKey:@"extras"];
//    int count_new = [count_new_str intValue];
//    extern int newestMessageCount;
//    newestMessageCount = count_new;//每次请求之后，用内存里的变量记录有多少条
//    NSLog(@"count is %@",count_new_str);
//    NSString* filePath = [TEPersistenceHandler getDocument:@"message.plist"];
//    NSMutableDictionary* dic_message = [NSDictionary dictionaryWithContentsOfFile:filePath];
//    NSString *count_old_str = [dic_message valueForKey:@"count"];
//    int count_old = 0;
//    if(count_old_str == nil || [@"" isEqualToString:count_old_str]){
//        count_old = 0;
//    }else{
//        count_old = [count_old_str intValue];
//    }
//    if(count_new > count_old){
//        self.image_reddot.hidden = NO;
//    }else{
//        self.image_reddot.hidden = YES;
//    }
    int newsNum = [[dic objectForKey:@"newsNum"]intValue];
    int lettersNum = [[dic objectForKey:@"lettersNum"]intValue];
    int notRead = newsNum + lettersNum;
    NSLog(@"not read is %i",notRead);
    if(notRead == 0){
        self.image_reddot.hidden = YES;
    }else{
        self.image_reddot.hidden = NO;
        self.label_messageCount.text = [NSString stringWithFormat:@"%i",notRead];
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber= notRead;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:[NSString stringWithUTF8String:object_getClassName(self)]];
}

@end
