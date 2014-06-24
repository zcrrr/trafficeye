//
//  TaxiViewController.m
//  TrafficEye_Clean
//
//  Created by zc on 13-5-22.
//
//

#import "TETaxiViewController.h"
#import "LongPressView.h"
#import "EasyLocView.h"
#import "LongPressAnno.h"
#import "TETaxiHelpViewController.h"
#import "Util.h"

@interface EasyLocAnno : CNMKAnnotation
@end

@implementation EasyLocAnno

@end



@interface TETaxiViewController ()

@end

@implementation TETaxiViewController
{
    int longPressIndex;
    CNMKGeoPoint longPressPoint;
}
@synthesize mapView;
@synthesize isToolBarOn;
@synthesize secondToHide;
@synthesize view_index;
@synthesize view_switch;
@synthesize star1;
@synthesize star2;
@synthesize star3;
@synthesize star4;
@synthesize star5;
@synthesize anno_longPress;
@synthesize annoViewArray;
@synthesize switchEasy;
@synthesize timerIndex;


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
    if(iPhone5){
        self.mapView = [[CNMKMapView alloc] initWithFrame:CGRectMake(0, 0+IOS7OFFSIZE, 320, 503)];
    }else{
        self.mapView = [[CNMKMapView alloc] initWithFrame:CGRectMake(0, 0+IOS7OFFSIZE, 320, 415)];
    }
    [self.mapView setMapType:CNMKMapTypeStandard];
    self.trafficSwitch.on = NO;
    self.mapView.delegate = self;
    self.mapView.taxiOn = YES;
    [self.view addSubview:self.mapView];
    [self.view sendSubviewToBack:mapView];
    [self.view addSubview:self.hot_help_img];
//    UITapGestureRecognizer* tapRecognizer_onMap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMap:)];
//    tapRecognizer_onMap.cancelsTouchesInView = NO;
//    [self.mapView addGestureRecognizer:tapRecognizer_onMap];
    UILongPressGestureRecognizer* longRecognizer_onMap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressOnMap:)];
    longRecognizer_onMap.cancelsTouchesInView = NO;
    [self.mapView addGestureRecognizer:longRecognizer_onMap];
    [self.mapView setShowsUserLocation:YES];
    [self.mapView setZoomLevel:14];
    //toolbar相关
    self.isToolBarOn = false;
    self.secondToHide = 5;
    [self.view addSubview:self.view_index];
    
    //switch相关
    [self.view_switch setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
    UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideSwitchView:)];
    [self.view_switch addGestureRecognizer:tapRecognizer];
    [self.view addSubview:self.view_switch];
    self.view_switch.hidden = YES;
    
    [self performSelector:@selector(getIndexByUserLocation) withObject:nil afterDelay:1];
    [self performSelector:@selector(gotoUserLoc) withObject:nil afterDelay:0.5];
    
    
    annoViewArray = [[NSMutableArray alloc]init];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //5分钟刷新一次指数
    self.timerIndex = [NSTimer scheduledTimerWithTimeInterval:300 target:self selector:@selector(getIndexByUserLocation) userInfo:nil repeats:YES];
    [MobClick beginLogPageView:[NSString stringWithUTF8String:object_getClassName(self)]];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    NSString *logString = [NSString stringWithFormat:@"%li,%@,%f %f;",
                           [TEUtil getNowTime],
                           [NSString stringWithFormat:@"I%@104101[%@]",LOG_VERSION,[self getSwitchStatus]],
                           [TEUtil getUserLocationLat],
                           [TEUtil getUserLocationLon]];
    [TEUtil appendStringToPlist:logString];
}
- (NSString*)getSwitchStatus{
    NSMutableString *str = [[NSMutableString alloc]initWithString:@""];
    if([self.trafficSwitch isOn]){
        [str appendString:@"1"];
    }else{
        [str appendString:@"0"];
    }
    if([self.switchEasy isOn]){
        [str appendString:@"1"];
    }else{
        [str appendString:@"0"];
    }
    if([self.hotSwitch isOn]){
        [str appendString:@"1"];
    }else{
        [str appendString:@"0"];
    }
    return str;
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.timerIndex invalidate];
}
- (void)longPressOnMap:(UILongPressGestureRecognizer *)press {
    if (press.state == UIGestureRecognizerStateEnded) {
        return;
    } else if (press.state == UIGestureRecognizerStateBegan) {
        NSLog(@"长按地图");
        CGPoint translation=[press locationInView:self.mapView];
        NSLog(@"x is %f",translation.x);
        NSLog(@"y is %f",translation.y);
        CNMKGeoPoint point = [self.mapView convertPoint:translation toCoordinateFromView:self.mapView];
        double lon = point.longitude;
        double lat = point.latitude;
        if([[self inBeijingOrShanghai:point] isEqualToString:@"error"]){
            NSLog(@"不在服务区");
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您选定的地点不在本软件服务范围，目前本软件的服务范围限于：北京和上海" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }else{
            longPressPoint = point;
            [TEAppDelegate getApplicationDelegate].networkHandler.delegate_taxiLongPress = self;
            [[TEAppDelegate getApplicationDelegate].networkHandler doRequest_taxiLongPress:lat longitude:lon];
        }
    }
}
- (void)mapViewDidEndDragging:(CNMKMapView *)mapView willDecelerate:(BOOL)decelerate {
    NSLog(@"移动地图！~~~~~~");
    if(self.switchEasy.on){
        [self removeAllEasyLocAnno];
        [self requestEasyLoc];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)buttonPressed:(UIButton *)sender {
    switch (sender.tag) {
        case 0:
        {
            NSLog(@"help");
            TETaxiHelpViewController *thVC = [[TETaxiHelpViewController alloc]init];
            [self.navigationController pushViewController:thVC animated:YES];
            break;
        }
        case 1:
        {
            NSLog(@"refresh");
            [self getIndexByUserLocation];
            break;
        }
        case 2:
        {
            NSLog(@"toc");
            self.secondToHide = 5;
            [UIView beginAnimations:@"show" context:nil];
            [UIView setAnimationDuration:5];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            if (self.view_switch.hidden)
            {
                self.view_switch.hidden = NO;
            }
            else {
                self.view_switch.hidden = YES;
            }
            [UIView commitAnimations];
            break;
        }
        case 3:
        {
            NSLog(@"gps");
            self.secondToHide = 5;
            CLLocationCoordinate2D coordinate = [[self.mapView userLocation] coordinate];
            //如果当前的用户的位置为空时，中心的坐标为0，0，这时不进行跟踪
            if (0.001 > fabs(coordinate.latitude) || 0.001 > fabs(coordinate.longitude))
            {
                return;
            }
            NSLog(@"定位");
            [self.mapView setCenterCoordinate:CNMKGeoPointFromCLLocationCoordinate2D(coordinate)];
            [self requestEasyLoc];
            break;
        }
        case 4:
        {
            NSLog(@"zoomin");
            self.secondToHide = 5;
            [self.mapView zoomIn];
            break;
        }
        case 5:
        {
            NSLog(@"zoomout");
            self.secondToHide = 5;
            [self.mapView zoomOut];
            break;
        }
            
            
            
        default:
            break;
    }
}

- (IBAction)switch_traffic:(UISwitch *)sender {
    if (sender.isOn)
    {
        [self.mapView setMapType:CNMKMapTypeTraffic];
        
    }else{
        [self.mapView setMapType:CNMKMapTypeStandard];
    }
    
}

- (IBAction)switch_suggest:(UISwitch *)sender {
    if (sender.isOn)
    {
        [self requestEasyLoc];
    }else{
        [self removeAllEasyLocAnno];
    }
}
- (IBAction)switch_hot:(UISwitch *)sender{
    if (sender.isOn)
    {
        self.mapView.taxiOn = YES;
        self.hot_help_img.hidden = NO;
    }else{
        self.mapView.taxiOn = NO;
        self.hot_help_img.hidden = YES;
    }
}
- (void)hideSwitchView:(id)sender
{
    self.view_switch.hidden = YES;
}
- (void)requestEasyLoc{
    NSLog(@"requestEasyLoc");
    double lon = self.mapView.centerCoordinate.longitude;
    double lat = self.mapView.centerCoordinate.latitude;
    [TEAppDelegate getApplicationDelegate].networkHandler.delegate_taxiEasy = self;
    [[TEAppDelegate getApplicationDelegate].networkHandler doRequest_taxiEasy:lat longitude:lon];
}
- (void)requestIndexByLatitude:(double)latitude longitude:(double)longitude{
    [TEAppDelegate getApplicationDelegate].networkHandler.delegate_taxiIndex = self;
    [[TEAppDelegate getApplicationDelegate].networkHandler doRequest_taxiIndex:latitude longitude:longitude];
}
- (void)getIndexByUserLocation{
    CLLocationCoordinate2D coordinate = [[self.mapView userLocation] coordinate];
    NSLog(@"lat is %f",coordinate.latitude);
    NSLog(@"lon is %f",coordinate.longitude);
    NSString *result = [self inBeijingOrShanghai:CNMKGeoPointFromCLLocationCoordinate2D(coordinate)];
    if([result isEqualToString:@"error"]){
        NSLog(@"不在服务区");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您当前位置不在打车指数的服务范围，目前打车指数的服务范围限于：北京和上海。您可以移动地图到北京查看相关信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }else{
        [self requestIndexByLatitude:coordinate.latitude longitude:coordinate.longitude];
    }
    
}
- (void)addEasyLocAnno:(NSArray*)taxiArray{
    for(int i =0;i<[taxiArray count];i++){
        EasyLocAnno *anno = [[EasyLocAnno alloc]init];
        NSString *oneTaxi = [taxiArray objectAtIndex:i];
        NSLog(@"oneTaxi is %@",oneTaxi);
        NSArray *oneTaxiInfo = [oneTaxi componentsSeparatedByString:@","];
        double lon = [[oneTaxiInfo objectAtIndex:1] doubleValue];
        double lat = [[oneTaxiInfo objectAtIndex:2] doubleValue];
        NSLog(@"lon is %f",lon);
        NSLog(@"lat is %f",lat);
        CNMKGeoPoint point;
        point.latitude = lat;
        point.longitude = lon;
        anno.encrypted = YES;
        anno.coordinate = point;
        [self.mapView addAnnotation:anno];
        [self.annoViewArray addObject:anno];
    }
}
- (void)removeAllEasyLocAnno{
    for(int i = 0;i<[self.annoViewArray count];i++){
        [self.mapView removeAnnotation:[self.annoViewArray objectAtIndex:i]];
    }
}
- (void)setStarImageByIndex:(int)index{
    switch (index) {
        case 0:
        {
            self.suggestLabel.text = @"还是坐公交吧";
            star1.image = [UIImage imageNamed:@"star_empty.png"];
            star2.image = [UIImage imageNamed:@"star_empty.png"];
            star3.image = [UIImage imageNamed:@"star_empty.png"];
            star4.image = [UIImage imageNamed:@"star_empty.png"];
            star5.image = [UIImage imageNamed:@"star_empty.png"];
            break;
        }
        case 5:
        {
            self.suggestLabel.text = @"还是坐公交吧";
            star1.image = [UIImage imageNamed:@"star_half.png"];
            star2.image = [UIImage imageNamed:@"star_empty.png"];
            star3.image = [UIImage imageNamed:@"star_empty.png"];
            star4.image = [UIImage imageNamed:@"star_empty.png"];
            star5.image = [UIImage imageNamed:@"star_empty.png"];
            break;
        }
        case 10:
        {
            self.suggestLabel.text = @"还是坐公交吧";
            star1.image = [UIImage imageNamed:@"star_full.png"];
            star2.image = [UIImage imageNamed:@"star_empty.png"];
            star3.image = [UIImage imageNamed:@"star_empty.png"];
            star4.image = [UIImage imageNamed:@"star_empty.png"];
            star5.image = [UIImage imageNamed:@"star_empty.png"];
            break;
        }
        case 15:
        {
            self.suggestLabel.text = @"打车有点难";
            star1.image = [UIImage imageNamed:@"star_full.png"];
            star2.image = [UIImage imageNamed:@"star_half.png"];
            star3.image = [UIImage imageNamed:@"star_empty.png"];
            star4.image = [UIImage imageNamed:@"star_empty.png"];
            star5.image = [UIImage imageNamed:@"star_empty.png"];
            break;
        }
        case 20:
        {
            self.suggestLabel.text = @"打车有点难";
            star1.image = [UIImage imageNamed:@"star_full.png"];
            star2.image = [UIImage imageNamed:@"star_full.png"];
            star3.image = [UIImage imageNamed:@"star_empty.png"];
            star4.image = [UIImage imageNamed:@"star_empty.png"];
            star5.image = [UIImage imageNamed:@"star_empty.png"];
            break;
        }
        case 25:
        {
            self.suggestLabel.text = @"稍微等一下车";
            star1.image = [UIImage imageNamed:@"star_full.png"];
            star2.image = [UIImage imageNamed:@"star_full.png"];
            star3.image = [UIImage imageNamed:@"star_half.png"];
            star4.image = [UIImage imageNamed:@"star_empty.png"];
            star5.image = [UIImage imageNamed:@"star_empty.png"];
            break;
        }
        case 30:
        {
            self.suggestLabel.text = @"稍微等一下车";
            star1.image = [UIImage imageNamed:@"star_full.png"];
            star2.image = [UIImage imageNamed:@"star_full.png"];
            star3.image = [UIImage imageNamed:@"star_full.png"];
            star4.image = [UIImage imageNamed:@"star_empty.png"];
            star5.image = [UIImage imageNamed:@"star_empty.png"];
            break;
        }
        case 35:
        {
            self.suggestLabel.text = @"容易打车";
            star1.image = [UIImage imageNamed:@"star_full.png"];
            star2.image = [UIImage imageNamed:@"star_full.png"];
            star3.image = [UIImage imageNamed:@"star_full.png"];
            star4.image = [UIImage imageNamed:@"star_half.png"];
            star5.image = [UIImage imageNamed:@"star_empty.png"];
            break;
        }
        case 40:
        {
            self.suggestLabel.text = @"容易打车";
            star1.image = [UIImage imageNamed:@"star_full.png"];
            star2.image = [UIImage imageNamed:@"star_full.png"];
            star3.image = [UIImage imageNamed:@"star_full.png"];
            star4.image = [UIImage imageNamed:@"star_full.png"];
            star5.image = [UIImage imageNamed:@"star_empty.png"];
            break;
        }
        case 45:
        {
            self.suggestLabel.text = @"马上就有车";
            star1.image = [UIImage imageNamed:@"star_full.png"];
            star2.image = [UIImage imageNamed:@"star_full.png"];
            star3.image = [UIImage imageNamed:@"star_full.png"];
            star4.image = [UIImage imageNamed:@"star_full.png"];
            star5.image = [UIImage imageNamed:@"star_half.png"];
            break;
        }
        case 50:
        {
            self.suggestLabel.text = @"马上就有车";
            star1.image = [UIImage imageNamed:@"star_full.png"];
            star2.image = [UIImage imageNamed:@"star_full.png"];
            star3.image = [UIImage imageNamed:@"star_full.png"];
            star4.image = [UIImage imageNamed:@"star_full.png"];
            star5.image = [UIImage imageNamed:@"star_full.png"];
            break;
        }
        default:
            break;
    }
}




- (void)viewDidUnload {
    [self setStar1:nil];
    [self setStar2:nil];
    [self setStar3:nil];
    [self setStar4:nil];
    [self setStar5:nil];
    [self setSuggestLabel:nil];
    [self setDateLabel:nil];
    [self setTimeLabel:nil];
    [self setSwitchEasy:nil];
    [self setHotSwitch:nil];
    [self setTrafficSwitch:nil];
    [self setHot_help_img:nil];
    [super viewDidUnload];
}
- (CNMKAnnotationView *)mapView:(CNMKMapView *)mapView viewForAnnotation:(id <CNMKAnnotationOverlay>)annotation
{
    if ([annotation isKindOfClass:[LongPressAnno class]]) {
        LongPressView* annoView = [[LongPressView alloc]initWithOverlay:annotation];
        annoView.index = longPressIndex;
        [annoView setFrame:CGRectMake(0, 0, 160,105)];
        UIImageView* imageView_bunbble = [[UIImageView alloc]init];
        //byzc注释掉了速度气泡的点击事件
        imageView_bunbble.image = [UIImage imageNamed:@"taxi_index_bubble.png"];
        annoView.imageView_annotation = imageView_bunbble;
        NSLog(@"add anno");
        return annoView;
    }else if ([annotation isKindOfClass:[EasyLocAnno class]]) {
        EasyLocView* annoView = [[EasyLocView alloc]initWithOverlay:annotation];
        [annoView setFrame:CGRectMake(0, 0, 50,50)];
        UIImageView* imageView_bunbble = [[UIImageView alloc]init];
        //byzc注释掉了速度气泡的点击事件
        imageView_bunbble.image = [UIImage imageNamed:@"taxi_index_pos.png"];
        annoView.imageView_annotation = imageView_bunbble;
        NSLog(@"add anno");
        return annoView;
        
    }
    return nil;
}
- (NSString*)inBeijingOrShanghai:(CNMKGeoPoint)coor{
    double lon = coor.longitude;
    double lat = coor.latitude;
    if(lat > 39.43 && lat < 41.00 && lon > 115.42 && lon < 117.40){
        return @"beijing";
    }
    else if(lat > 30.70 && lat < 31.83 && lon > 120.90 && lon < 121.96){
        return @"shanghai";
    }
    else{
        return @"error";
    }
}
- (void)gotoUserLoc{
    CLLocationCoordinate2D coordinate = [[self.mapView userLocation] coordinate];
    //如果当前的用户的位置为空时，中心的坐标为0，0，这时不进行跟踪
    if (0.001 > fabs(coordinate.latitude) || 0.001 > fabs(coordinate.longitude))
    {
        return;
    }
    [self.mapView setCenterCoordinate:CNMKGeoPointFromCLLocationCoordinate2D(coordinate)];
    [self requestEasyLoc];
}
#pragma -mark taxi index delegate
- (void)taxiIndexDidSuccess:(NSDictionary *)dic{
    NSString *date = [dic objectForKey:@"publishedDate"];
    NSString *shortDate = [date substringFromIndex:5];
    NSString *time = [dic objectForKey:@"publishedTime"];
    int index = [[dic objectForKey:@"locationIndex"] intValue];
    [self setStarImageByIndex:index];
    self.dateLabel.text = shortDate;
    self.timeLabel.text = time;
}
- (void)taxiIndexDidFailed:(NSString *)mes{
    
}
#pragma -mark taxi easy delegate
- (void)taxiEasyDidSuccess:(NSDictionary *)dic{
    NSArray *taxiArray = [dic objectForKey:@"positions"];
    [self addEasyLocAnno:taxiArray];
}
- (void)taxiEasyDidFailed:(NSString *)mes{
    
}
#pragma -mark taxi long press delegate
- (void)taxiLongPressDidSuccess:(NSDictionary *)dic{
    int index = [[dic objectForKey:@"locationIndex"] intValue];
    longPressIndex = index;
    if(anno_longPress){
        [self.mapView removeAnnotation:anno_longPress];
    }
    anno_longPress = [[LongPressAnno alloc]init];
    anno_longPress.encrypted = YES;
    anno_longPress.coordinate = longPressPoint;
    anno_longPress.title = @"longPress";
    [self.mapView addAnnotation:anno_longPress];
    NSLog(@"index is %d",index);
}
- (void)taxiLongPressDidFailed:(NSString *)mes{
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:[NSString stringWithUTF8String:object_getClassName(self)]];
}

@end
