/*  
 *  IDDateGauge.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2013 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

#import "IDGauge.h"

@class IDDateGauge;

/*!
 @protocol IDDateGaugeDelegate
 @abstract Delegate protocol for handling gauge updates.
 */
@protocol IDDateGaugeDelegate <NSObject>

@optional

/*!
 @method gauge:didEndEditingDate:
 @abstract Called when the user confims the entered date by finally clicking the gauge component.
 @param date The new value.
 */
- (void)gauge:(IDDateGauge *)gauge didEndEditingDate:(NSDate *)date;

/*!
 @method gauge:didChangeDate:
 @abstract Called every time a gauge's value changes.
 @discussion Not called when gauge value is programmatically set via the value property.
 @param date The current value.
 */
- (void)gauge:(IDDateGauge *)gauge didChangeDate:(NSDate *)date;

@end

#pragma mark -

/*!
 @class IDDateGauge
 @discussion This class implements the behavior of HMI date gauges in the Widget API.
 @updated 2012-04-03
 */
@interface IDDateGauge : IDGauge

/*!
 @property delegate
 @abstract The delegate that receives the callbacks for this gauge component.
 */
@property (assign, nonatomic) id<IDDateGaugeDelegate> delegate;

/*!
 @property date
 @abstract This property can be used to retrieve the current date value of the component and to set the gauge component to a new value.
 @discussion Only day, month and year of the date components are considered. This property is not KVO compliant.
 */
@property (retain, nonatomic) NSDate *date;

@end
