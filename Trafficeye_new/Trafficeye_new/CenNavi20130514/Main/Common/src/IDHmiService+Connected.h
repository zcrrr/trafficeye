//
//  IDHmiService+Connected.h
//  Connected
//
//  Created by Andreas Streuber on 20.10.11.
//  Copyright (c) 2011 BMW Group. All rights reserved.
//

#import <BMWAppKit/BMWAppKit.h>

/*!
 @protocol IDHmiService (Connected)
 @abstract Category on IDHmiService to provide convenience methods.
 @discussion This category on IDHmiService contains convenience methods required by different features within the fat app.
 @updated 2011-10-20
 */

@interface IDHmiService (Connected)

/*!
 The following methods are convenience methods. Each method has an equivalent method in BMWAppKit that take a completionBlock as additional input parameter. The implementation of the following methods will call the equivalent method in BMWAppKit and automatically provide a completion block. The completion block takes an NSError as its only parameter. The error is set by the BMWAppKit framwork. The only thing this completion block does is log the error. For further documentation of the method called internally see BMWAppKit framework.
 */

- (void)setDataModel:(NSInteger)modelId variantData:(IDVariantData*)data;
- (void)setListModel:(NSInteger)modelId tableData:(IDTableData*)data;
- (void)setListModel:(NSInteger)modelId tableData:(IDTableData*)data fromRow:(NSUInteger)fromRow rows:(NSUInteger)rows fromColumn:(NSUInteger)fromColumn columns:(NSUInteger)columns;
- (void)setListModel:(NSInteger)modelId tableData:(IDTableData*)data fromRow:(NSUInteger)fromRow rows:(NSUInteger)rows fromColumn:(NSUInteger)fromColumn columns:(NSUInteger)columns totalRows:(NSUInteger)totalRows totalColumns:(NSUInteger)totalColumns;
- (void)setProperty:(IDPropertyType)propertyId forComponent:(NSInteger)componentId variantMap:(IDVariantMap*)map;
- (void)setComponent:(NSInteger)modelId visible:(BOOL)visible;
- (void)triggerHmiEvent:(NSUInteger)eventId;
- (void)triggerHmiEvent:(NSUInteger)eventId parameterMap:(IDVariantMap *)params;

@end
