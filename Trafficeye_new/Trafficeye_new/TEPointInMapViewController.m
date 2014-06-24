//
//  TEPointInMapViewController.m
//  Trafficeye_new
//
//  Created by zc on 14-6-8.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import "TEPointInMapViewController.h"
#import "TEBusStationAnno.h"
#import "TEBusStationAnnoView.h"

@interface TEPointInMapViewController ()

@end

@implementation TEPointInMapViewController
@synthesize lon;
@synthesize lat;
@synthesize locationName;
@synthesize addr;
@synthesize type;
@synthesize mapView;
@synthesize delegate_confirmPoint;

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
    if(iPhone5){
        self.mapView = [[CNMKMapView alloc] initWithFrame:CGRectMake(0, 0+IOS7OFFSIZE+45, 320, 458)];
    }else{
        self.mapView = [[CNMKMapView alloc] initWithFrame:CGRectMake(0, 0+IOS7OFFSIZE+45, 320, 370)];
    }
    [self.mapView setMapType:CNMKMapTypeStandard];
    [self.mapView setShowsUserLocation:YES];
    self.mapView.delegate = self;
    [self.mapView setZoomLevel:12];
    [self.view addSubview:self.mapView];
    [self.view sendSubviewToBack:mapView];
    double lon_double = [self.lon doubleValue];
    double lat_double = [self.lat doubleValue];
    CNMKGeoPoint point = CNMKGeoPointMake(lon_double, lat_double);
    [self.mapView setCenterCoordinate:point];
    TEBusStationAnno* stationAnno = [[TEBusStationAnno alloc]init];
    stationAnno.encrypted = YES;
    stationAnno.coordinate = point;
    [self.mapView addAnnotation:stationAnno];
    
    if([self.type isEqualToString:@"1"]){
        [self.button_go setTitle:@"到这里去" forState:UIControlStateNormal];
        [self.button_go setTitle:@"到这里去" forState:UIControlStateHighlighted];
    }else if([self.type isEqualToString:@"2"]){
        [self.button_go setTitle:@"设为起点" forState:UIControlStateNormal];
        [self.button_go setTitle:@"设为起点" forState:UIControlStateHighlighted];
    }else if([self.type isEqualToString:@"3"]){
        [self.button_go setTitle:@"设为终点" forState:UIControlStateNormal];
        [self.button_go setTitle:@"设为终点" forState:UIControlStateHighlighted];
    }
    self.label_locationName1.text = self.locationName;
    self.label_locationName2.text = [NSString stringWithFormat:@"  %@",self.locationName];
    if([TEUtil isStringNULL:self.addr]){
        self.addr = @"暂无详细地址";
    }
    self.label_addr.text = [NSString stringWithFormat:@"  %@",self.addr];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)button_back_clicked:(id)sender {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setObject:lon forKey:@"lon"];
    [dic setObject:lat forKey:@"lat"];
    [dic setObject:locationName forKey:@"locationName"];
    [dic setObject:addr forKey:@"addr"];
    [dic setObject:@"0" forKey:@"type"];
    [self.delegate_confirmPoint confirmPointDidSuccess:dic];
    [self performSelector:@selector(goBack) withObject:nil afterDelay:0.5];
}

- (IBAction)button_go_clicked:(id)sender {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setObject:lon forKey:@"lon"];
    [dic setObject:lat forKey:@"lat"];
    [dic setObject:locationName forKey:@"locationName"];
    [dic setObject:addr forKey:@"addr"];
    [dic setObject:type forKey:@"type"];
    [self.delegate_confirmPoint confirmPointDidSuccess:dic];
    [self performSelector:@selector(goBack) withObject:nil afterDelay:0.5];
}

- (IBAction)button_clicked:(id)sender {
    switch ([(UIButton*)sender tag]) {
        case 1:
        {
            [self gotoUserLoc];
            break;
        }
        case 2:
        {
            [self.mapView zoomIn];
            break;
        }
        case 3:
        {
            [self.mapView zoomOut];
            break;
        }
        
            
        default:
            break;
    }
}
- (void)viewDidDisappear:(BOOL)animated{
    self.mapView.delegate = nil;
}
- (void)gotoUserLoc{
    CLLocationCoordinate2D coordinate = [[self.mapView userLocation] coordinate];
    //如果当前的用户的位置为空时，中心的坐标为0，0，这时不进行跟踪
    if (0.001 > fabs(coordinate.latitude) || 0.001 > fabs(coordinate.longitude))
    {
        return;
    }
    [self.mapView setCenterCoordinate:CNMKGeoPointFromCLLocationCoordinate2D(coordinate)];
}
- (CNMKAnnotationView *)mapView:(CNMKMapView *)mapView viewForAnnotation:(id <CNMKAnnotationOverlay>)annotation
{
    TEBusStationAnno* anno = annotation;
    TEBusStationAnnoView* stationAnnoView = [[TEBusStationAnnoView alloc]initWithOverlay:anno];
    stationAnnoView.tag = 1999;
    [stationAnnoView setFrame:CGRectMake(0, 0, 22,22 )];
    UIImageView* imageView_bunbble = [[UIImageView alloc]init];
    imageView_bunbble.image = [UIImage imageNamed:@"share_car_position.png"];
    stationAnnoView.imageView_annotation = imageView_bunbble;
    return stationAnnoView;
}
- (void)mapView:(CNMKMapView *)mapView didUpdateUserLocation:(CNMKLocation *)newLocation {
    if (newLocation && self.mapView.showsUserLocation) {
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
