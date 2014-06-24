//
//  CNMKAnnotationView.h
//  cennavimapapi
//
//  Created by Lion on 12-2-13.
//  Copyright (c) 2012年 __CenNavi__. All rights reserved.
//


#import "CNMKAnnotation.h"

@interface CNMKAnnotationView : UIView {
    id <CNMKAnnotationOverlay> _overlay;
    BOOL _selected;
    
    int _zoomLevel;
    BOOL _animatesDrop;
}

- (id)initWithOverlay:(id <CNMKAnnotationOverlay>)overlay;

@property (nonatomic, readonly) id <CNMKAnnotationOverlay> overlay;
@property (nonatomic) BOOL selected;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated;


@property (nonatomic) int zoomLevel;

@property (nonatomic) BOOL animatesDrop;

- (void)updateAnnotationView;
- (void)appear;

@end
