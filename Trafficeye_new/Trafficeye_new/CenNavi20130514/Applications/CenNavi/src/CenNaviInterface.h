//
//  AISINInterface.h
//  CenNaviDemo
//
//  Created by Don Hao on 3/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CenNaviFeatureController.h"
#import "CenNaviCache.h"

@interface CenNaviFeatureController (CenNaviInterface)<ASIHTTPRequestDelegate>

#pragma mark - Init
-(void)CenNaviInterfaceInit;
-(void)CenNaviInterfaceDealloc;

#pragma mark - car gps
- (BOOL)isCarGpsAvailable;

#pragma mark - button did press
- (void)buttonMainScreenCityOverviewDidPress:(IDButton *)button;
- (void)buttonMainScreenAheadTrafficDidPress:(IDButton *)button;
- (void)buttonMainScreenSoundDidPress:(IDButton *)button;
- (void)buttonMainScreenBrowseAreasDidPress:(IDButton *)button;
- (void)buttonAreaStatePreviousDidPress:(IDButton *)button;
- (void)buttonAreaStateNextDidPress:(IDButton *)button;

#pragma mark - IDTableDelegate protocol method
- (void)table:(IDTable *)table didSelectItemAtIndex:(NSInteger)index;

#pragma mark - CDS
-(void)didReceiveSpeedActual:(NSDictionary*) response;
-(void)didRHMILanguageChanged:(NSDictionary*) response;
-(void)didSteeringWheel:(NSDictionary*) response;
-(void)didGear:(NSDictionary*) response;
-(void)didHeadLights:(NSDictionary*)response;
-(void)didLights:(NSDictionary*)response;

#pragma mark - get map
-(UIImage*)getCurrentCityMap;
-(UIImage*)getAheadTrafficMap;
-(UIImage*)getAreaMap;

#pragma mark - update map periodically
-(void)updateCurrentMap;

@end
