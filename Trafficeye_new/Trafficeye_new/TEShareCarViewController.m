//
//  TEShareCarViewController.m
//  Trafficeye_new
//
//  Created by zc on 14-5-21.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import "TEShareCarViewController.h"
#import "Toast+UIView.h"
#import "CLLocation+YCLocation.h"

@interface TEShareCarViewController ()

@end

@implementation TEShareCarViewController
@synthesize poiList;
@synthesize type;
@synthesize currentSelectedIndex;
@synthesize delegate_chooseLocation;

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
        self.mapView = [[CNMKMapView alloc] initWithFrame:CGRectMake(0, 0+IOS7OFFSIZE+45, 320, 278)];
    }else{
        self.mapView = [[CNMKMapView alloc] initWithFrame:CGRectMake(0, 0+IOS7OFFSIZE+45, 320, 190)];
    }
    UIImageView* imageview = [[UIImageView alloc]initWithFrame:CGRectMake(160-20, 0+IOS7OFFSIZE+45+self.mapView.frame.size.height/2-40, 40, 40)];
    [imageview setImage:[UIImage imageNamed:@"share_car_position.png"]];
    [self.mapView setMapType:CNMKMapTypeStandard];
    [self.mapView setShowsUserLocation:YES];
    [self.mapView setZoomLevel:16];
    [self performSelector:@selector(gotoUserLoc) withObject:nil afterDelay:0.5];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    [self.view sendSubviewToBack:self.mapView];
    [self.view addSubview:imageview];
    [self.view addSubview:self.loadingImage];
    [self.view addSubview:self.indicator];
    poiList = [[NSMutableArray alloc]init];
    currentSelectedIndex = 0;
}
- (void)viewDidDisappear:(BOOL)animated{
    self.mapView.delegate = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)mapViewDidEndDragging:(CNMKMapView *)mapView willDecelerate:(BOOL)decelerate {
    NSLog(@"移动地图！~~~~~~");
    NSLog(@"lat is %f",mapView.centerCoordinate.latitude);
    NSLog(@"lon is %f",mapView.centerCoordinate.longitude);
    [TEAppDelegate getApplicationDelegate].networkHandler.delegate_findPoi = self;
    [[TEAppDelegate getApplicationDelegate].networkHandler doRequest_findPoi:mapView.centerCoordinate.longitude :mapView.centerCoordinate.latitude];
    [self displayLoading];
}
- (void)findPoiDidSuccess:(NSDictionary *)dic{
    [self hideLoading];
    [self.poiList removeAllObjects];
    if(dic == nil){
        return;
    }
    NSMutableArray* poiArray = [[dic objectForKey:@"result"]objectForKey:@"pois"];
    if([poiArray count]<1){
        return;
    }
    NSMutableDictionary* myLocationDic = [[NSMutableDictionary alloc]init];
    [myLocationDic setObject:@"[位置]" forKey:@"name"];
    [myLocationDic setObject:[[dic objectForKey:@"result"]objectForKey:@"formatted_address"] forKey:@"addr"];
    NSMutableDictionary* lonlatDic = [[NSMutableDictionary alloc]init];
    [lonlatDic setObject:[[[dic objectForKey:@"result"]objectForKey:@"location"]objectForKey:@"lng"] forKey:@"x"];
    [lonlatDic setObject:[[[dic objectForKey:@"result"]objectForKey:@"location"]objectForKey:@"lat"] forKey:@"y"];
    [myLocationDic setObject:lonlatDic forKey:@"point"];
    [self.poiList addObject:myLocationDic];
    [self.poiList addObjectsFromArray:poiArray];
    
    self.currentSelectedIndex = 0;
    [self.tableview reloadData];
}
- (void)findPoiDidFailed:(NSString *)mes{
    [self hideLoading];
}
#pragma mark tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.poiList count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* poi_identifier = @"poiIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:poi_identifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:poi_identifier];
    }
    NSUInteger row = [indexPath row];
    cell.textLabel.text = [[self.poiList objectAtIndex:row]objectForKey:@"name"];
    cell.detailTextLabel.text = [[self.poiList objectAtIndex:row]objectForKey:@"addr"];
    cell.accessoryType = (row == currentSelectedIndex)?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
    return  cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    int newRow = [indexPath row];
    if(newRow != currentSelectedIndex){
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        NSIndexPath *temp = [NSIndexPath indexPathForRow:currentSelectedIndex inSection:0];
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:temp];
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        currentSelectedIndex = newRow;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)button_save_clicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    NSString* address;
    if([self.poiList count] == 0){
        return;
    }
    if(self.currentSelectedIndex == 0){
        address = [[self.poiList objectAtIndex:currentSelectedIndex] objectForKey:@"addr"];
    }else{
        address = [[self.poiList objectAtIndex:currentSelectedIndex] objectForKey:@"name"];
    }
    
    NSString* lon = [[[self.poiList objectAtIndex:currentSelectedIndex] objectForKey:@"point"]objectForKey:@"x"];
    NSString* lat = [[[self.poiList objectAtIndex:currentSelectedIndex] objectForKey:@"point"]objectForKey:@"y"];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setObject:self.type forKey:@"type"];
    NSLog(@"before lon is %@",lon);
    NSLog(@"before lat is %@",lat);
    CLLocation* location = [[CLLocation alloc]initWithLatitude:[lat doubleValue] longitude:[lon doubleValue]];
    CLLocation* location2 = [location locationMarsFromBaidu];
    NSLog(@"after lon is %f",location2.coordinate.longitude);
    NSLog(@"after lat is %f",location2.coordinate.latitude);
    NSString* afterLon = [NSString stringWithFormat:@"%f",location2.coordinate.longitude];
    NSString* afterLat = [NSString stringWithFormat:@"%f",location2.coordinate.latitude];
    [dic setObject:afterLon forKey:@"lon"];
    [dic setObject:afterLat forKey:@"lat"];
    [dic setObject:address forKey:@"addr"];
    [self.delegate_chooseLocation chooseLocationDidSuccess:dic];
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
    self.button_save.enabled = NO;
    self.button_back.enabled = NO;
}
- (void)enableAllButton{
    self.button_save.enabled = YES;
    self.button_back.enabled = YES;
}
- (void)gotoUserLoc{
    CLLocationCoordinate2D coordinate = [[self.mapView userLocation] coordinate];
    //如果当前的用户的位置为空时，中心的坐标为0，0，这时不进行跟踪
    if (0.001 > fabs(coordinate.latitude) || 0.001 > fabs(coordinate.longitude))
    {
        return;
    }
    [self.mapView setCenterCoordinate:CNMKGeoPointFromCLLocationCoordinate2D(coordinate)];
    [TEAppDelegate getApplicationDelegate].networkHandler.delegate_findPoi = self;
    [[TEAppDelegate getApplicationDelegate].networkHandler doRequest_findPoi:self.mapView.centerCoordinate.longitude :self.mapView.centerCoordinate.latitude];
    [self displayLoading];
}

- (IBAction)button_back_clicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
