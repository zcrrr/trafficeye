//
//  CNMKAnnotation.h
//  cennavimapapi
//
//  Created by Lion on 12-3-28.
//  Copyright (c) 2012年 __CenNavi__. All rights reserved.
//

#import "CNMKOverlay.h"

@interface CNMKAnnotation : NSObject <CNMKAnnotationOverlay> {
    CNMKGeoPoint _coordinate;
    BOOL _encrypted;
    NSString *_title;
    NSString *_subtitle;
}

@property (nonatomic) CNMKGeoPoint coordinate;
@property (nonatomic) BOOL encrypted;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

+ (id)annotationWithCoordinate:(CNMKGeoPoint)coordinate;

@end
