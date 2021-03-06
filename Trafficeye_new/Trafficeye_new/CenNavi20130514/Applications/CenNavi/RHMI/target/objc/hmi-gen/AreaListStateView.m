// ************************************************
//
// generated by RHMI Editor 2.0.5
// project name: CenNavi
//
// THIS IS GENERATED CODE, DON'T TOUCH!
//
// ************************************************

#import "AreaListStateView.h"

@implementation AreaListStateView

@synthesize lbl_area_list_state_city_name = _lbl_area_list_state_city_name;
@synthesize table_area_list_state_area_name = _table_area_list_state_area_name;

- (id)initWithHmiState:(NSInteger)hmiState
            titleModel:(IDModel *)titleModel
            focusEvent:(NSInteger)focusEvent
           hmiProvider:(id<IDHmiProvider>)hmiProvider
{
    if (self = [super initWithHmiState:hmiState titleModel:titleModel focusEvent:focusEvent])
    {
        _lbl_area_list_state_city_name = [[IDLabel alloc] initWithWidgetId:96
                                                                     model:[hmiProvider modelForId:97]];

        _table_area_list_state_area_name = [[IDTable alloc] initWithWidgetId:98
                                                                       model:[hmiProvider modelForId:99]
                                                                 targetModel:[hmiProvider modelForId:-1]
                                                                    actionId:100];


        [self addWidget:_lbl_area_list_state_city_name];
        [self addWidget:_table_area_list_state_area_name];
    }
    return self;
}

- (void)dealloc
{
    [self removeWidget:_lbl_area_list_state_city_name];
    [self removeWidget:_table_area_list_state_area_name];

    [_lbl_area_list_state_city_name release], _lbl_area_list_state_city_name = nil;
    [_table_area_list_state_area_name release], _table_area_list_state_area_name = nil;

    [super dealloc];
}


@end
