//
//  CNMKOverlayView.h
//  cennavimapapi
//
//  Created by Lion on 12-2-12.
//  Copyright (c) 2012年 __CenNavi__. All rights reserved.
//

#import "CNMKOverlay.h"

@interface CNMKOverlayView : UIView {
@package
    id <CNMKOverlay> _overlay;
    int _zoomLevel;
}

- (CNMKOverlayView *)initWithOverlay:(id <CNMKOverlay>)overlay;

@property (nonatomic, readonly) id <CNMKOverlay> overlay;

@property (nonatomic) int zoomLevel;

- (void)updateOverlayViewRect:(CNMKScrRect)visibleRect;

@end
