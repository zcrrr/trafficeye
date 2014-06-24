//
//  TrafficMap.h
//  CenNavi
//
//  Created by Lin Renton on 13-3-20.
//
//

#import <Foundation/Foundation.h>

@interface TrafficMap : NSObject
@property (strong, nonatomic) NSString* mapId;
@property (strong, nonatomic) UIImage* image;
@property (assign, nonatomic) long time;
@property (assign, nonatomic) int refreshTime;
@property (strong, nonatomic) NSString* text;

@end
