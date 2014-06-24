//
//  Goods.m
//  TrafficEye_Clean
//
//  Created by 张 驰 on 13-7-2.
//
//

#import "Goods.h"

@implementation Goods
@synthesize type;
@synthesize name;
@synthesize count;
@synthesize price;
@synthesize subtotal;

- (void)calSubtotal{
    self.subtotal = self.price * self.count;
}
@end
