//
//  Goods.h
//  TrafficEye_Clean
//
//  Created by 张 驰 on 13-7-2.
//
//

#import <Foundation/Foundation.h>

@interface Goods : NSObject

@property (nonatomic) int type;
@property (strong, nonatomic) NSString *name;
@property (nonatomic) float price;
@property (nonatomic) int count;
@property (nonatomic) float subtotal;

- (void)calSubtotal;

@end
