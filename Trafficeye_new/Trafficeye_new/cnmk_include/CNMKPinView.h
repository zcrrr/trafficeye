//
//  CNMKPinView.h
//  cennavimapapi
//
//  Created by Lion on 12-2-13.
//  Copyright (c) 2012年 __CenNavi__. All rights reserved.
//

#import "CNMKAnnotationView.h"

typedef enum {
    CNMKPinColorGreen = 0,
    CNMKPinColorPurple,
    CNMKPinColorRed,
} CNMKPinColor;

@interface CNMKPinView : CNMKAnnotationView

@property (nonatomic) CNMKPinColor pinColor;

@end
