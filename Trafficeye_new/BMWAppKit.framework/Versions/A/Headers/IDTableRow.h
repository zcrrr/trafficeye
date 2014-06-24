/*  
 *  IDTableRow.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2013 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

#import <Foundation/Foundation.h>

@class IDVariantData;

/*!
 @class IDTableRow
 @abstract Representation of a single table row.
 @discussion A table row can be added to instances of IDTableData. Each cell of this row can hold an instance of
 IDVariantData
 @throws NSInvalidArgumentException or NSRangeException if setItem:atColumn: is called with invalid parameters.
 @updated 2012-11-21
 */
@interface IDTableRow : NSObject

/*!
 @method rowWithColumns:
 @abstract Returns a table row.
 @param columns Number of columns. The number of columns a row can hold can not be changed later on.
 @return The initialized table row.
 */
+ (IDTableRow*)rowWithColumns:(NSUInteger)columns;

/*!
 @method initWithColumns:
 @abstract Initialisation of the table row with specified amount of columns.
 @param columns Number of columns. The number of columns a row can hold can not be changed later on.
 @return The table row itself.
 */
- (id)initWithColumns:(NSUInteger)columns;

/*!
 @method setItem:atColumn:
 @abstract Sets an item for a specified column in a table row.
 @discussion If the specified column is not empty it will be replaced by the new item.
 @param data Data of item to set.
 Raises an NSInvalidArgumentException if data is nil.
 @param column Column in which the item will be set.
 Raises an NSRangeException if column exceeds the dimensions of the row.
 */
- (void)setItem:(IDVariantData *)data atColumn:(NSInteger)column;

/*!
 @method itemAtColumn:
 @abstract Returns an item at a specified column in a table row.
 @discussion If the column parameter is greater than or equal to the value returned by columns an NSRangeException is
 raised.
 @param column Index of column.
 @return The item of the specified column.
 */
- (IDVariantData *)itemAtColumn:(NSInteger)column;

/*!
 @method objectEnumerator:
 @abstract Returns an enumerator object that lets you access each object in the row.
 @discussion Returns an enumerator object that lets you access each object in the array, in order, starting with the element at index 0.
 @return An enumerator object that lets you access each object in the array, in order, from the element at the lowest index upwards.
 */
- (NSEnumerator *) objectEnumerator;

/*!
 @method isEqualToTableRow:
 @abstract Compares the receiving table row object to another table row object.
 @discussion To be equal two table rows need to have identical dimensions (i.e. same number of columns) and the items
 (i.e. variant data) which were added to the row must be equal (i.e. the method isEqualToVariantData: must
 return YES for each compared pair of cells).
 @param otherTableRow A table row object
 @return YES if the contents of otherTableRow are equal to the contents of the receiving table row, otherwise NO.
 */
- (BOOL)isEqualToTableRow:(IDTableRow *)otherTableRow;

/*!
 @property columns
 @abstract Number of columns.
 */
@property (nonatomic, readonly) NSUInteger columns;

@end
