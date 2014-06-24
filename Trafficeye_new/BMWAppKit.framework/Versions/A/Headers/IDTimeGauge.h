/*  
 *  IDTimeGauge.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2013 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

#import "IDGauge.h"

// TODO: header documentation

@class IDTimeGauge;

/*!
 @protocol IDTimeGaugeDelegate
 @abstract This class implements the behavior of HMI time gauges in the Widget API.
 @discussion <#This is a more detailed description of the protocol.#>
 */
@protocol IDTimeGaugeDelegate <NSObject>

@optional

/*!
 @method gauge:didEndEditingTime:
 @abstract Called when the user clicks on the gauge to finish updating the value.
 @param gauge The gauge which was clicked.
 @param date The new value.
 */
- (void)gauge:(IDTimeGauge *)gauge didEndEditingTime:(NSDate *)date;

/*!
 @method gauge:didChangeTime:
 @abstract Called when the user changes a gauge's value. Not called when gauge value is programmatically set via the value property.
 @param gauge The gauge which the user changed.
 @param date The new value after the gauge has updated.
 */
- (void)gauge:(IDTimeGauge *)gauge didChangeTime:(NSDate *)date;

@end

/*!
 @class IDTimeGauge
 @abstract Delegate object for handling gauge update & change events must implement IDTimeGaugeDelegate protocol.
 @discussion Everytime the time value of the gauge is updated, following method of the delegate object will be triggered [self.delegate gauge:self didEndEditingTime:self.date]. When a new time value is set to the gauge, following method of the delegate object will be triggered [self.delegate gauge:self didChangeTime:self.date].
 @updated 2012-04-03
 */
@interface IDTimeGauge : IDGauge

/*!
 @property delegate
 @abstract <#This is an introductory explanation about the property.#>
 @discussion <#This is a more detailed description of the property.#>
 */
@property (assign, nonatomic) id<IDTimeGaugeDelegate> delegate;

/*!
 @property time
 @abstract time property used to store/retreive the value of the gauge in NSDate datatype.
 @discussion Only hour and minute of the date components are considered in the setter. This property is not KVO compliant.
 */
@property (retain, nonatomic) NSDate *time;

@end
