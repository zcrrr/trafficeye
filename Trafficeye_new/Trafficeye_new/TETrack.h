//
//  TETrack.h
//  Trafficeye_new
//
//  Created by zc on 13-9-22.
//  Copyright (c) 2013年 张 驰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TETrack : NSObject
@property (assign, nonatomic) int index;
@property (assign, nonatomic) int trackid;
@property (strong, nonatomic) NSString* userID;
@property (strong, nonatomic) NSString* username;
@property (strong, nonatomic) NSString* avatar;
@property (assign, nonatomic) float speed;
@property (assign, nonatomic) int minute;
@property (strong, nonatomic) NSMutableArray* pointsList;

- (void)initPointsList:(NSString*)pointsStr;


@end
