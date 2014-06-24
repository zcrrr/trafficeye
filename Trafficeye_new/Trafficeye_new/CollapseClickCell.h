//
//  CollapseClickCell.h
//  CollapseClick
//
//  Created by Ben Gordon on 2/28/13.
//  Copyright (c) 2013 Ben Gordon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollapseClickArrow.h"

#define kCCHeaderHeight 50

@interface CollapseClickCell : UIView

// Header
@property (strong, nonatomic) IBOutlet UIView *TitleView;
@property (strong, nonatomic) IBOutlet UILabel *TitleLabel;
@property (strong, nonatomic) IBOutlet UIButton *TitleButton;
@property (strong, nonatomic) IBOutlet UIButton *TitleArrow;

// Body
@property (strong, nonatomic) IBOutlet UIView *ContentView;

// Properties
@property (nonatomic, assign) BOOL isClicked;
@property (nonatomic, assign) int index;

// Init
+ (CollapseClickCell *)newCollapseClickCellWithTitle:(NSString *)title index:(int)index content:(UIView *)content;

@end
