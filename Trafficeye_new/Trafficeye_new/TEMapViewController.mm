//
//  TEMapViewController.m
//  Trafficeye_new
//
//  Created by 张 驰 on 13-6-17.
//  Copyright (c) 2013年 张 驰. All rights reserved.
//

#import "TEMapViewController.h"
#import "TETrack.h"
#import "TEPolylineViewWithSpeed.h"
#import "TEPolylineWithSpeed.h"
#import "CNMapKit.h"
#import "TEGeoPoint.h"
#import "TETrackAnno.h"
#import "TETrackAnnoView.h"
#import "TEEvent.h"
#import "TEEventAnno.h"
#import "TEEventInfoViewController.h"
#import "TETrackInfoViewController.h"
#import "TEPersistenceHandler.h"
#import "TEEventDetailViewController.h"
#import "TEWebLevel1ViewController.h"


@interface TEMapViewController ()

@end

@implementation TEMapViewController
@synthesize mapView;
@synthesize timerToolBar;
@synthesize secondToHide;
@synthesize isToolBarOn;
@synthesize initLocation;
@synthesize isFollow;
@synthesize isRequestingTrack;
@synthesize trackArray;
@synthesize trackPolylineArray;
@synthesize trackAnnoArray;
@synthesize timer_one_minute;
@synthesize timer_five_minute;
@synthesize isRequestingEvent;
@synthesize eventArray;
@synthesize eventAnnoArray;
@synthesize tocStatus;

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
    // Do any additional setup after loading the view from its nib.
    NSString* NOTIFICATION_REQUEST_EVENT = @"request_event";
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestEvent) name:NOTIFICATION_REQUEST_EVENT object:nil];
    if(iPhone5){
        self.mapView = [[CNMKMapView alloc] initWithFrame:CGRectMake(0, 0+IOS7OFFSIZE, 320, 503)];
        self.view_switch_board.frame = CGRectMake(0, 0, 320, 568);
    }else{
        self.mapView = [[CNMKMapView alloc] initWithFrame:CGRectMake(0, 0+IOS7OFFSIZE, 320, 415)];
        self.view_switch_board.frame = CGRectMake(0, 0, 320, 480);
    }
    NSString* filePath = [TEPersistenceHandler getDocument:@"MapToc.plist"];
    NSMutableArray* arrayFromPlist = [NSMutableArray arrayWithContentsOfFile:filePath];
    if(arrayFromPlist){
        self.tocStatus = arrayFromPlist;
    }else{
        self.tocStatus = [[NSMutableArray alloc]initWithObjects:@"1",@"1",@"1",nil];
    }
    NSLog(@"maptoc is %@",tocStatus);
    if([[self.tocStatus objectAtIndex:0] isEqualToString:@"1"]){
        [self.switch_traffic setOn:YES];
        self.mapView.mapType = CNMKMapTypeTraffic;
    }else{
        [self.switch_traffic setOn:NO];
        self.mapView.mapType = CNMKMapTypeStandard;
    }
    if([[self.tocStatus objectAtIndex:1] isEqualToString:@"1"]){
        [self.switch_track setOn:YES];
    }else{
        [self.switch_track setOn:NO];
    }
    if([[self.tocStatus objectAtIndex:2] isEqualToString:@"1"]){
        [self.switch_event setOn:YES];
    }else{
        [self.switch_event setOn:NO];
    }
    
    [self.mapView setShowsUserLocation:YES];
    [self.mapView setZoomLevel:11];
    self.mapView.delegate = self;
    self.trackArray = [[NSMutableArray alloc]init];
    self.trackPolylineArray = [[NSMutableArray alloc]init];
    self.trackAnnoArray = [[NSMutableArray alloc]init];
    self.eventArray = [[NSMutableArray alloc]init];
    self.eventAnnoArray = [[NSMutableArray alloc]init];
    [self initViewsAndGesture];
    [self.view addSubview:mapView];
    [self.view sendSubviewToBack:mapView];
    //请求轨迹
    [self requestTrack];
    [self requestEvent];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.timer_one_minute = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(requestTrack) userInfo:nil repeats:YES];
    self.timer_five_minute = [NSTimer scheduledTimerWithTimeInterval:60*5 target:self selector:@selector(requestEvent) userInfo:nil repeats:YES];
    [MobClick beginLogPageView:[NSString stringWithUTF8String:object_getClassName(self)]];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [self.timer_one_minute invalidate];
    [self.timer_five_minute invalidate];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    NSString *logString = [NSString stringWithFormat:@"%li,%@,%f %f;",
                           [TEUtil getNowTime],
                           [NSString stringWithFormat:@"I%@101101[%@]",LOG_VERSION,[self getSwitchStatus]],
                           [TEUtil getUserLocationLat],
                           [TEUtil getUserLocationLon]];
    [TEUtil appendStringToPlist:logString];
    
    if(![CLLocationManager locationServicesEnabled]){//这里判断系统设置的定位打开没有
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:nil
                                   message:@"请在系统设置中打开\"定位服务\"来允许\"路况交通眼\"确定您得位置"
                                  delegate:nil
                         cancelButtonTitle:@"知道了"
                         otherButtonTitles:nil];
        [alert show];
    }
    //这里先把ios获取的原生坐标，用户地图的中心点，因为这个原生的坐标和偏移的差距不大，并且一运行程序就可以得到。
    CNMKGeoPoint centerPoint;
    centerPoint.latitude = [TEUtil getUserLocationLat];
    centerPoint.longitude = [TEUtil getUserLocationLon];
    
    if(centerPoint.latitude<0.1&&centerPoint.longitude<0.1){//这里说明用户所在位置不能获取gps或者设置里没有打开对交通眼的位置服务的允许
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:nil
                                   message:@"请在系统设置中打开\"定位服务\"来允许\"路况交通眼\"确定您得位置"
                                  delegate:nil
                         cancelButtonTitle:@"知道了"
                         otherButtonTitles:nil];
        [alert show];
    }else{
        [self.mapView setCenterCoordinate:centerPoint animated:NO];
    }
}
- (NSString*)getSwitchStatus{
    NSMutableString *str = [[NSMutableString alloc]initWithString:@""];
    if([self.switch_traffic isOn]){
        [str appendString:@"1"];
    }else{
        [str appendString:@"0"];
    }
    if([self.switch_track isOn]){
        [str appendString:@"1"];
    }else{
        [str appendString:@"0"];
    }
    if([self.switch_event isOn]){
        [str appendString:@"1"];
    }else{
        [str appendString:@"0"];
    }
    return str;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)button_clicked:(id)sender {
    switch ([(UIButton*)sender tag]) {
        case 0://图层控制
        {
            self.secondToHide = 5;
            self.view_switch_board.hidden = NO;
            break;
        }
        case 1:
        {
            NSLog(@"路线查询");
            TEWebLevel1ViewController* webVC = [[TEWebLevel1ViewController alloc]init];
            webVC.entryHTML = @"bus_index";
            webVC.pageLevel = 2;
            [self.navigationController pushViewController:webVC animated:YES];
            break;
        }
        case 2://定位
        {
            self.secondToHide = 5;
            isFollow = YES;
            CLLocationCoordinate2D coordinate = [[self.mapView userLocation] coordinate];
            //如果当前的用户的位置为空时，中心的坐标为0，0，这时不进行跟踪
            if (0.001 > fabs(coordinate.latitude) || 0.001 > fabs(coordinate.longitude))
            {
                return;
            }
            [self.mapView setCenterCoordinate:CNMKGeoPointFromCLLocationCoordinate2D(coordinate)];
            break;
        }
        case 3://放大
        {
            self.secondToHide = 5;
            [self.mapView zoomIn];
            break;
        }
        case 4://缩小
        {
            self.secondToHide = 5;
            [self.mapView zoomOut];
            break;
        }
        case 5://搜索
        {
            NSLog(@"搜索");
            TEWebLevel1ViewController* webVC = [[TEWebLevel1ViewController alloc]init];
            webVC.entryHTML = @"poiselect";
            webVC.pageLevel = 2;
            [self.navigationController pushViewController:webVC animated:YES];
            break;
        }
        default:
            break;
    }
}

- (IBAction)switch_traffic_changed:(id)sender {
    if(self.switch_traffic.on){
        [self.mapView setMapType:CNMKMapTypeTraffic];
    }else{
        [self.mapView setMapType:CNMKMapTypeStandard];
    }
    [self saveUserTocSetting];
}

- (IBAction)switch_track_changed:(id)sender {
    if(self.switch_track.on){
        [self requestTrack];
    }else{
        [self removeAllTracks];
    }
    [self saveUserTocSetting];
}

- (IBAction)switch_event_changed:(id)sender {
    if(self.switch_event.on){
        [self requestEvent];
    }else{
        [self removeAllEvents];
    }
    [self saveUserTocSetting];
}
#pragma -mark map delegate
- (void)mapViewDidZooming:(CNMKMapView *)mapView {
    [self requestTrack];
    [self requestEvent];
}
- (void)mapViewWillBeginDragging:(CNMKMapView *)mapView {
    NSLog(@"Begin dragging!");
    isFollow = NO;
}
//- (void)tapMap:(id)sender{
//    if(self.isToolBarOn){
//        [self hideToolBar];
//        self.isToolBarOn = false;
//    }else{
//        self.secondToHide = 5;
//        [self displayToolBar];
//        self.isToolBarOn = true;
//    }
//    NSLog(@"tap on map");
//}
- (CNMKOverlayView *)mapView:(CNMKMapView *)mapView viewForOverlay:(id <CNMKOverlay>)overlay
{
	if ([overlay isKindOfClass:[TEPolylineWithSpeed class]])
    {
        TEPolylineWithSpeed* polyline = overlay;
        float speed = polyline.speed;
        TEPolylineViewWithSpeed* polylineView = [[TEPolylineViewWithSpeed alloc]initWithOverlay:overlay];
        if(speed < 20)
        {
            polylineView.strokeColor = [UIColor colorWithRed:198.0 / 255 green:0 blue:0 alpha:1];
        }
        else if(speed <= 40)
        {
            polylineView.strokeColor = [UIColor colorWithRed:255.0 / 255 green:126.0 / 255 blue:0 alpha:1];
        }
        else
        {
            polylineView.strokeColor = [UIColor colorWithRed:50.0 / 255 green:178.0 / 255 blue:0 alpha:1];
        }
		
		polylineView.lineWidth = 5.0;
		return polylineView;
    }
    return nil;
}
- (CNMKAnnotationView *)mapView:(CNMKMapView *)mapView viewForAnnotation:(id <CNMKAnnotationOverlay>)annotation
{
    //    NSLog(@"view for annotation------");
    if ([annotation isKindOfClass:[TETrackAnno class]])
    {
        TETrackAnno* speedAnno_ = annotation;
        float speed = speedAnno_.speed;
        
        TETrackAnnoView* newAnnotation = [[TETrackAnnoView alloc]initWithOverlay:annotation];
        [newAnnotation setFrame:CGRectMake(0, 0, 38, 42)];
        
        UIImageView* imageView_bunbble = [[UIImageView alloc]init];
        //byzc注释掉了速度气泡的点击事件
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(trackOnClick:)];
        imageView_bunbble.userInteractionEnabled=YES;
        [imageView_bunbble addGestureRecognizer:singleTap];
        singleTap.view.tag = speedAnno_.index;
        
        if (40 <= speed)
        {
            imageView_bunbble.image = [UIImage imageNamed:@"map_report_speed1.png"];
        }
        else if (20 <= speed)
        {
            imageView_bunbble.image = [UIImage imageNamed:@"map_report_speed2.png"];
        }
        else
        {
            imageView_bunbble.image = [UIImage imageNamed:@"map_report_speed3.png"];
        }
        newAnnotation.imageView_annotation = imageView_bunbble;
        newAnnotation.speed = [(TETrackAnno*)annotation speed];
        return newAnnotation;
    }else if ([annotation isKindOfClass:[TEEventAnno class]]){
        TEEventAnno* eventAnno = annotation;
        //        NSLog(@"index is %i",eventAnno.index);
        TETrackAnnoView* newAnnotation = [[TETrackAnnoView alloc]initWithOverlay:annotation];
        [newAnnotation setFrame:CGRectMake(0, 0, 45,45 )];
        newAnnotation.tag = 1050;
        UIImageView* imageView_bunbble = [[UIImageView alloc]init];
        //byzc注释掉了速度气泡的点击事件
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(eventOnClick:)];
        imageView_bunbble.userInteractionEnabled=YES;
        [imageView_bunbble addGestureRecognizer:singleTap];
        singleTap.view.tag = eventAnno.index;
        TEEvent *eventinfo = [eventArray objectAtIndex:eventAnno.index];
        imageView_bunbble.image = [UIImage imageNamed:[self getImageNameWithType:eventinfo.type andJamDegree:eventinfo.jamDegree]];
        newAnnotation.imageView_annotation = imageView_bunbble;
        return newAnnotation;
    }
    return nil;
}
#pragma -mark 自定义
//- (void)hideToolBar{
//    [self.timerToolBar invalidate];
//    [UIView beginAnimations:nil context:nil];
//    //设定动画持续时间
//    [UIView setAnimationDuration:1];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    
//    //动画的内容
//    CGRect frame = self.view_map_controll_button.frame;
//    frame.origin.x += 75;
//    [self.view_map_controll_button setFrame:frame];
//    //动画结束
//    [UIView commitAnimations];
//}
//- (void)displayToolBar{
//    self.timerToolBar = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(checkTimeToHideToolBar) userInfo:nil repeats:YES];
//    [UIView beginAnimations:nil context:nil];
//    //设定动画持续时间
//    [UIView setAnimationDuration:1];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    //动画的内容
//    CGRect frame = self.view_map_controll_button.frame;
//    frame.origin.x -= 75;
//    [self.view_map_controll_button setFrame:frame];
//    //动画结束
//    [UIView commitAnimations];
//}
//- (void)checkTimeToHideToolBar{
//    self.secondToHide--;
//    if(secondToHide == 0){
//        [self  hideToolBar];
//        [self.timerToolBar invalidate];
//        self.isToolBarOn = false;
//    }
//}
- (void)initViewsAndGesture{
//    UITapGestureRecognizer* tapRecognizer_onMap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMap:)];
//    tapRecognizer_onMap.cancelsTouchesInView = NO;
//    [self.mapView addGestureRecognizer:tapRecognizer_onMap];
    [self.view_switch_board setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
    UITapGestureRecognizer* tapRecognizer_switch = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideSwitchView:)];
    [self.view_switch_board addGestureRecognizer:tapRecognizer_switch];
    [self.view addSubview:self.view_switch_board];
    self.view_switch_board.hidden = YES;
}
- (void)hideSwitchView:(id)sender
{
    self.view_switch_board.hidden = YES;
}
-(void)trackOnClick:(UITapGestureRecognizer *)view
{
    int tag = view.view.tag;
    NSLog(@"tag is %i",tag);
    NSLog(@"这个track信息：%@",[self.trackArray objectAtIndex:tag]);
    TETrackInfoViewController* trackController = [[TETrackInfoViewController alloc]init];
    TETrack* track = [self.trackArray objectAtIndex:tag];
    trackController.trackid = track.trackid;
    trackController.track_uid = track.userID;
    trackController.username = track.username;
    trackController.avatar_url = track.avatar;
    trackController.speedValue = track.speed;
//    [self.navigationController pushViewController:trackController animated:YES];
    //社区功能
    TEEventDetailViewController* eventVC = [[TEEventDetailViewController alloc]init];
    eventVC.eventID = track.trackid;
    eventVC.type= @"track";
    [self.navigationController pushViewController:eventVC animated:YES];
}
-(void)eventOnClick:(UITapGestureRecognizer *)view
{
    int tag = view.view.tag;
    TEEventInfoViewController* eventController = [[TEEventInfoViewController alloc]init];
    TEEvent* event = [self.eventArray objectAtIndex:tag];
    eventController.eventid = event.eventID;
    eventController.type = event.type;
    eventController.jamDegree = event.jamDegree;
    eventController.avatar_url = event.avatar_url;
    eventController.nicname = event.username;
    eventController.event_uid = event.eventuid;
    //    [self.navigationController pushViewController:eventController animated:YES];
    
    //社区功能
    TEEventDetailViewController* eventVC = [[TEEventDetailViewController alloc]init];
    eventVC.eventID = event.eventID;
    eventVC.type= @"event";
    [self.navigationController pushViewController:eventVC animated:YES];
    
}
/**
 *用户位置改变响应
 */
- (void)mapView:(CNMKMapView *)mapView didUpdateUserLocation:(CNMKLocation *)newLocation {
    if (newLocation && self.mapView.showsUserLocation) {
        //        if (self.initLocation == NO) {
        //            NSLog(@"根据偏移坐标设置中心");
        //            [self.mapView setCenterCoordinate:CNMKGeoPointFromCLLocationCoordinate2D(newLocation.coordinate) animated:YES];
        //            self.initLocation = YES;
        //        }
        if (isFollow) {
            [self.mapView setCenterCoordinate:CNMKGeoPointFromCLLocationCoordinate2D(newLocation.coordinate) animated:YES];
        }
    }
}
- (void)requestTrack{
    [self.trackArray removeAllObjects];
    [self removeAllTracks];
    if(!self.switch_track.on)return;//没开轨迹switch不请求
    int zoomLevel = self.mapView.zoomLevel;
    if(11 > zoomLevel)return;//小于10等级，不请求
    if(self.isRequestingTrack)return;//正在请求，不请求
    CNMKGeoPoint centerPoint = self.mapView.centerCoordinate;
    [TEAppDelegate getApplicationDelegate].networkHandler.delegate_getTrack = self;
    [[TEAppDelegate getApplicationDelegate].networkHandler doRequest_getTrackWithLatitude:centerPoint.latitude Longitude:centerPoint.longitude Level:zoomLevel];
    self.isRequestingTrack = YES;
}
- (void)requestEvent{
    [self.eventArray removeAllObjects];
    [self removeAllEvents];
    if(!self.switch_event.on)return;//没开轨迹switch不请求
    int zoomLevel = self.mapView.zoomLevel;
    CNMKGeoPoint centerPoint = self.mapView.centerCoordinate;
    [TEAppDelegate getApplicationDelegate].networkHandler.delegate_getEvent = self;
    [[TEAppDelegate getApplicationDelegate].networkHandler doRequest_getEventWithLatitude:centerPoint.latitude Longitude:centerPoint.longitude Level:zoomLevel];
}
#pragma -mark get track delegate
- (void)getTrackDidFailed:(NSString *)mes{
    NSLog(@"获取轨迹失败：%@",mes);
    self.isRequestingTrack = NO;
}
- (void)getTrackDidSuccess:(NSArray*)array{
    NSLog(@"get track success");
    self.isRequestingTrack = NO;
    int i = 0;
    for(i = 0;i < [array count];i++){
        NSDictionary* dic = [array objectAtIndex:i];
        TETrack* track = [[TETrack alloc]init];
        track.trackid = [[dic objectForKey:@"id"]intValue];
        track.userID = [NSString stringWithFormat:@"%i",[[[dic objectForKey:@"user"]objectForKey:@"id"] intValue]];
        track.username = [[dic objectForKey:@"user"]objectForKey:@"username"];
        track.avatar = [[dic objectForKey:@"user"]objectForKey:@"avatar"];
        track.speed = [[dic objectForKey:@"speed"]floatValue];
        track.minute = [[dic objectForKey:@"minis"]intValue];
        if([TEUtil isStringNULL:track.username]){
            track.username = @"未登录用户";
        }
        if([TEUtil isStringNULL:track.avatar]){
            track.avatar = nil;
        }
        track.index = i;
        [track initPointsList:[dic objectForKey:@"linestring"]];
        [self.trackArray addObject:track];
        [self showTrack:track];
    }
}
#pragma -mark get event delegate
- (void)getEventDidFailed:(NSString *)mes{
    NSLog(@"获取轨迹失败：%@",mes);
    self.isRequestingEvent = NO;
}
- (void)getEventDidSuccess:(NSArray *)array{
    self.isRequestingEvent = NO;
    int i = 0;
    for(i = 0;i < [array count];i++){
        NSDictionary* dic = [array objectAtIndex:i];
        TEEvent* event = [[TEEvent alloc]init];
        event.eventID = [[dic objectForKey:@"id"]intValue];
        event.type = [[dic objectForKey:@"type"]intValue];
        event.jamDegree = [[dic objectForKey:@"jamdgree"]intValue];
        event.username = [[dic objectForKey:@"user"] objectForKey:@"username"];
        event.avatar_url = [[dic objectForKey:@"user"] objectForKey:@"avatar"];
        event.eventuid = [NSString stringWithFormat:@"%@",[[dic objectForKey:@"user"] objectForKey:@"id"]];
        if([TEUtil isStringNULL:event.username]){
            event.username = @"未登录用户";
        }
        if([TEUtil isStringNULL:event.avatar_url]){
            event.avatar_url = nil;
        }
        event.index = i;
        NSString* loc = [dic objectForKey:@"gps_point"];
        NSArray* lon_lat = [loc componentsSeparatedByString:@" "];
        TEGeoPoint* geoPoint = [[TEGeoPoint alloc]init];
        geoPoint.longitude = [[lon_lat objectAtIndex:0] intValue] * 1.0 / 1000000;
        geoPoint.latitude = [[lon_lat objectAtIndex:1] intValue] * 1.0 / 1000000;
        event.eventLocation = geoPoint;
        [self.eventArray addObject:event];
        [self showEvent:event];
    }
}
- (void)showTrack:(TETrack*)track{
    int pts_size = [track.pointsList count];
    CNMKGeoPoint* geoPoints = new CNMKGeoPoint[pts_size];
    for (int j = 0; j < pts_size; j++)
    {
        TEGeoPoint* oneLocation = [track.pointsList objectAtIndex:j];
        CLLocationCoordinate2D gisPoint;
        gisPoint.latitude = oneLocation.latitude;
        gisPoint.longitude = oneLocation.longitude;
        geoPoints[j] = CNMKGeoPointFromCLLocationCoordinate2D(gisPoint);
    }
    TEPolylineWithSpeed* polyline = [TEPolylineWithSpeed polylineWithGeoPoints:geoPoints count:pts_size];
    polyline.encrypted = YES;
    polyline.speed = track.speed;
    [self.mapView addOverlay:polyline];
    TETrackAnno* speedAnno_ = [[TETrackAnno alloc]init];
    speedAnno_.speed = track.speed;
    speedAnno_.encrypted = YES;
    TEGeoPoint* lastLocation = [track.pointsList lastObject];
    CLLocationCoordinate2D gisPoint_last;
    gisPoint_last.latitude = lastLocation.latitude;
    gisPoint_last.longitude = lastLocation.longitude;
    //        speedAnno_.coordinate = geoPoints[postion_middle];
    speedAnno_.coordinate = CNMKGeoPointFromCLLocationCoordinate2D(gisPoint_last);
    speedAnno_.index = track.index;
    [self.mapView addAnnotation:speedAnno_];
    [self.trackAnnoArray addObject:speedAnno_];
    [self.trackPolylineArray addObject:polyline];
}
- (void)showEvent:(TEEvent*)event{
    TEEventAnno* eventAnno = [[TEEventAnno alloc]init];
    eventAnno.encrypted = YES;
    TEGeoPoint* location = event.eventLocation;
    CLLocationCoordinate2D gisPoint_last;
    gisPoint_last.latitude = location.latitude;
    gisPoint_last.longitude = location.longitude;
    //        speedAnno_.coordinate = geoPoints[postion_middle];
    eventAnno.coordinate = CNMKGeoPointFromCLLocationCoordinate2D(gisPoint_last);
    eventAnno.index = event.index;
    [self.mapView addAnnotation:eventAnno];
    [self.eventAnnoArray addObject:eventAnno];
}
- (void)removeAllTracks
{
    for (int i = 0; i < [self.trackPolylineArray count]; i++)
    {
        TEPolylineWithSpeed* polyline = [self.trackPolylineArray objectAtIndex:i];
        if (nil != polyline)
        {
            [self.mapView removeOverlay:polyline];
        }
    }
    [self.trackPolylineArray removeAllObjects];
    
    for (int i = 0; i < [self.trackAnnoArray count]; i++)
    {
        TETrackAnno* annotation = [self.trackAnnoArray objectAtIndex:i];
        if (nil != annotation)
        {
            if ([annotation isKindOfClass:[TETrackAnno class]])
            {
                [self.mapView removeAnnotation:annotation];
            }
        }
    }
    [self.trackAnnoArray removeAllObjects];
}
- (void)removeAllEvents
{
    [self.eventArray removeAllObjects];
    for (int i = 0; i < [self.eventAnnoArray count]; i++)
    {
        TEEventAnno* annotation = [self.eventAnnoArray objectAtIndex:i];
        if (nil != annotation)
        {
            if ([annotation isKindOfClass:[TEEventAnno class]])
            {
                [self.mapView removeAnnotation:annotation];
            }
        }
    }
    [self.eventAnnoArray removeAllObjects];
}
- (NSString*)getImageNameWithType:(int) type andJamDegree:(int) jamDegree{
    NSString *imageName = @"";
    switch (type) {
        case 1:
        {
            imageName = [NSString stringWithFormat:@"map_report_jam%i",jamDegree+1];
            break;
        }
        case 2:
        {
            imageName = [NSString stringWithFormat:@"map_report_accident%i",jamDegree];
            break;
        }
        case 3:
        {
            imageName = [NSString stringWithFormat:@"map_report_construction%i",jamDegree];
            break;
        }
        case 4:
        {
            imageName = [NSString stringWithFormat:@"map_report_control%i",jamDegree];
            break;
        }
        case 5:
        {
            if(jamDegree == 1){
                imageName = [NSString stringWithFormat:@"map_report_street_view"];
            }
            else if(jamDegree == 2){
                imageName = [NSString stringWithFormat:@"map_report_yell"];
            }
            else if(jamDegree == 3){
                imageName = [NSString stringWithFormat:@"map_report_2b_driver"];
            }
            break;
        }
        default:
            break;
    }
    return imageName;
}
- (void)saveUserTocSetting{
    [self.tocStatus removeAllObjects];
    if([self.switch_traffic isOn]){
        [self.tocStatus addObject:@"1"];
    }else{
        [self.tocStatus addObject:@"0"];
    }
    if([self.switch_track isOn]){
        [self.tocStatus addObject:@"1"];
    }else{
        [self.tocStatus addObject:@"0"];
    }
    if([self.switch_event isOn]){
        [self.tocStatus addObject:@"1"];
    }else{
        [self.tocStatus addObject:@"0"];
    }
    NSString* filePath = [TEPersistenceHandler getDocument:@"MapToc.plist"];
    [self.tocStatus writeToFile:filePath atomically:YES];
    NSLog(@"leave map tocstatus is %@",self.tocStatus);
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:[NSString stringWithUTF8String:object_getClassName(self)]];
}

@end
