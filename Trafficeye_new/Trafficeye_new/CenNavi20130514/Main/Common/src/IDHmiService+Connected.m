//
//  IDHmiService+Connected.m
//  Connected
//
//  Created by Andreas Streuber on 20.10.11.
//  Copyright (c) 2011 BMW Group. All rights reserved.
//

#import "IDHmiService+Connected.h"

@implementation IDHmiService (Connected)


- (void)setDataModel:(NSInteger)modelId variantData:(IDVariantData*)data
{
    [self setDataModel:modelId variantData:data completionBlock:nil];
}

- (void)setListModel:(NSInteger)modelId tableData:(IDTableData*)data
{
    [self setListModel:modelId tableData:data completionBlock:nil];
}

- (void)setListModel:(NSInteger)modelId tableData:(IDTableData*)data fromRow:(NSUInteger)fromRow rows:(NSUInteger)rows fromColumn:(NSUInteger)fromColumn columns:(NSUInteger)columns
{
    [self setListModel:modelId tableData:data fromRow:fromRow rows:rows fromColumn:fromColumn columns:columns completionBlock:nil];
}

- (void)setListModel:(NSInteger)modelId tableData:(IDTableData*)data fromRow:(NSUInteger)fromRow rows:(NSUInteger)rows fromColumn:(NSUInteger)fromColumn columns:(NSUInteger)columns totalRows:(NSUInteger)totalRows totalColumns:(NSUInteger)totalColumns
{
    [self setListModel:modelId tableData:data fromRow:fromRow rows:rows fromColumn:fromColumn columns:columns totalRows:totalRows totalColumns:totalColumns completionBlock:nil];
}

- (void)setProperty:(IDPropertyType)propertyId forComponent:(NSInteger)componentId variantMap:(IDVariantMap*)map
{
    [self setProperty:propertyId forComponent:componentId variantMap:map completionBlock:nil];
}

- (void)setComponent:(NSInteger)modelId visible:(BOOL)visible
{
    [self setComponent:modelId visible:visible completionBlock:nil];
}

- (void)triggerHmiEvent:(NSUInteger)eventId
{
    [self triggerHmiEvent:eventId completionBlock:nil];
}

- (void)triggerHmiEvent:(NSUInteger)eventId parameterMap:(IDVariantMap *)params
{
    [self triggerHmiEvent:eventId parameterMap:params completionBlock:nil];
}

@end
