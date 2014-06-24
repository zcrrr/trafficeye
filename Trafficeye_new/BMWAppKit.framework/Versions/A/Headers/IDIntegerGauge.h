/*  
 *  IDIntegerGauge.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2013 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

#import "IDGauge.h"

@class IDIntegerGauge;

/*!
 @protocol IDIntegerGaugeDelegate
 @abstract Defines the protocol which the delgate of an @link IDIntegerGauge @/link needs to implement.
 */
@protocol IDIntegerGaugeDelegate <NSObject>

@optional

/*!
 @method gauge:didEndEditingValue:
 @abstract Called when the user clicks on the gauge to finish updating the value.
 @discussion NSInteger value is the new value.
 @param gauge The gauge object that changed its value.
 @param value The new value.
 */
- (void)gauge:(IDIntegerGauge *)gauge didEndEditingValue:(NSInteger)value;

/*!
 @method gauge:didChangeValue:
 @abstract Called when the user changes a gauge's value. Not called when gauge value is programmatically set via the value property.
 @param gauge The gauge object that changed its value.
 @param value The current value.
 */
- (void)gauge:(IDIntegerGauge *)gauge didChangeValue:(NSInteger)value;

@end

#pragma mark -

/*!
 @class IDIntegerGauge
 @discussion This class implements the behavior of HMI integer gauges in the Widget API.
 @updated 2012-04-03
 */
@interface IDIntegerGauge : IDGauge

/*!
 @property delegate
 @abstract The delegate that receives the callbacks for this gauge component.
 */
@property (assign, nonatomic) id<IDIntegerGaugeDelegate> delegate;

/*!
 @property value
 @abstract This property can be used to retrieve the current value of the component and to set the gauge component to a new value.
 @discussion This property is not KVO compliant
 */
@property (assign, nonatomic) NSInteger value;

@end
