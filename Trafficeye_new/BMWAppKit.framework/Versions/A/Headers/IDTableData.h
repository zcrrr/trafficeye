/*  
 *  IDTableData.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2013 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

#import <Foundation/Foundation.h>

@class IDTableRow;

/*!
 @class IDTableData
 @abstract This class describes the content of a table.
 @discussion It is a container for rows (IDTableRows). It can be initialized with a specific capacity and you can add rows.
 @updated 2011-08-16
 */
@interface IDTableData : NSObject
{
    NSMutableArray* rows;
    NSUInteger columns;
}

/*!
 @method tableDataWithCapacity:columns:
 @abstract Creates and returns empty table data.
 @param capacity The initial capacity of the new table data.
 @param maxColumns Tha maximum number of columns this table data can hold.
 @return A new IDTableData object.
 */
+ (id)tableDataWithCapacity:(NSUInteger)capacity columns:(NSUInteger)maxColumns;

/*!
 @method initWithCapacity:columns:
 @abstract Initializes newly allocated table data.
 @param capacity The initial capacity of the new table data.
 @param maxColumns Tha maximum number of columns this table data can hold.
 @return A new IDTableData object.
 */
- (id)initWithCapacity:(NSUInteger)capacity columns:(NSUInteger)maxColumns;

/*!
 @method addRow
 @abstract Adds an additional row to the table data object.
 @param row An instance of IDTableRow
 */
- (void)addRow:(IDTableRow*)row;

/*!
 @method isEqualToTableData:
 @abstract Compares the receiving table data object to another table data object.
 @discussion To be equal two table data objects need to have identical dimensions (i.e. same number of columns and same
 number of rows) and the table rows contained within the objects must be equal (i.e. the method isEqualToTableData: must
 return YES for each compared pair of rows).
 @param otherTableData A table data object
 @return YES if the contents of otherTableData are equal to the contents of the receiving table data, otherwise NO.
 */
- (BOOL)isEqualToTableData:(IDTableData *)otherTableData;

/*!
 @property columns
 @abstract An integer value representing the maximum number of columns this object can hold.
 */
@property (nonatomic, readonly) NSUInteger columns;

/*!
 @property rows
 @abstract An array of IDTableRow objects.
 */
@property (nonatomic, readonly) NSArray *rows;

@end
