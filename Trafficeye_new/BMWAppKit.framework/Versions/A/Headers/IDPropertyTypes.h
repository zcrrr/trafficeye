/*  
 *  IDPropertyTypes.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2013 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

/*!
 @enum IDPropertyTypes
 @constant IDPropertyEnabled
    This property sets the enabled state of a component. A disabled
    component can not be activated
    Parameters
        bool enabled: enabled state
        Applicable for: all components
 @constant IDPropertySelectable
    This property sets the selectable state of a component. A non selectable
    component can not be selected and so not be activated
    Parameters: 
        bool selectable: selectable state
        Applicable for: all components
 @constant IDPropertyVisible
    This property sets the visible state of a component. Invisible 
    components do not appear to the user at all
    Parameters: 
        bool visible: visible state
        Applicable for: all components
 @constant IDPropertyValid
    This property validates or invalidates a list. An invalidated list
    will try to get new data by a content provider applied to its listmodel.
    Parameters: 
        bool valid: valid state
        Applicable for: list
 @constant IDPropertyToolbarHmiStatePaging
    This property enables paging on an hmiState with a toolbar. The first and last
    button in the toolbar will be used for page up and down
    Parameters: 
        bool paging: paging enabled state
        Applicable for: toolbarHmiState
 */
typedef enum IDPropertyTypes
{
    IDPropertyEnabled = 1,
    IDPropertySelectable = 2,
    IDPropertyVisible = 3,
    IDPropertyValid = 4,
    IDPropertyToolbarHmiStatePaging = 5,
    
    /*!
     @constant IDPropertyListColumnWidth
     This property set the widths for the table columns
     Parameters: 
          String with a list of int-values: the widths for the columns, in xml separate with commas
     Applicable for: list
    */
    IDPropertyListColumnWidth = 6,
    
    /*!
     @constant IDPropertyListHasIdColumn
     This property enables an invisible id column of a list. The value of 
     the first column is interpretated as id and is delivered back by the list
     action instead of the column index. The column is not visible to the user.
     Parameters: 
          bool hasIdColumn: hasIdColumn state
     Applicable for: list
    */
    IDPropertyListHasIdColumn = 7,
    
    /**
     * This property enables an animation of a button that indicates a 
     * loading process.
     * Parameters: 
     *      bool waitingAnimation: waitingAnimation state
     * Applicable for: label
     */
    IDPropertyLabelWaitingAnimation = 8,
    
    /**
     * This property sets the width of a component.
     * Parameters: 
     *      int width: component width
     * Applicable for: image
     */
    IDPropertyWidth = 9,
    
    /**
     * This property sets the height of a component.
     * Parameters: 
     *      int height: component height
     * Applicable for: image
     */
    IDPropertyHeight = 10,
    
    /**
     * This property sets the video viewport for the terminalUI component.
     * Parameters: 
     *      int x: x position
     *      int y: y position
     *      int width: width of video viewport
     *      int height: height of video viewport
     * Applicable for: terminalUI
     */
    IDPropertyTerminalUIVideoViewport = 11,
    
    /**
     * This property sets the screen viewport for the terminalUI component.
     * Parameters: 
     *      int x: x position
     *      int y: y position
     *      int width: width of screen viewport
     *      int height: height of screen viewport
     * Applicable for: terminalUI
     */
    IDPropertyTerminalUIScreenViewport = 12,
    
    /**
     * This property sets the fullscreen mode of the terminalUI component.
     * Parameters: 
     *      bool fullscreen: fullscreen state
     * Applicable for: terminalUI
     */
    IDPropertyTerminalUIFullScreen = 13,
    
    /**
     * This property requests or disables an audio connection for the terminalUI component.
     *      bool audiomode: request / disable audio
     * Applicable for: terminalUI
     */
    IDPropertyTerminalUIAudioMode = 14,
    
    /**
     * This property requests or disables a video connection for the terminalUI component.
     *      bool audiomode: request / disable video
     * Applicable for: terminalUI
     */
    IDPropertyTerminalUIVideoMode = 15,
    
    /**
     * This property forces the terminalUI component to close.
     * Applicable for: terminalUI
     */
    IDPropertyTerminalUILeave = 16,
    
    /**
     * This property sets the alignment of a component. 
     * Parameters
     *      int alignment:
     0: Left_Top
     1: Center_Top
     2: Right_Top
     3: Left_Center
     4: Center_Center
     5: Right_Center
     6: Left_Bottom
     7: Center_Bottom
     8: Right_Bottom
     * Applicable for: all components
     */
    IDPropertyAlignment = 17,
    
    /**
     * This property sets the x offset of a component.
     * Parameters: 
     *      int height: component height
     * Applicable for: image
     */
    IDPropertyOffsetX = 18,
    
    /**
     * This property sets the y offset of a component.
     * Parameters: 
     *      int height: component height
     * Applicable for: image
     */
    IDPropertyOffsetY = 19,
    
    /**
     * This property sets the x position of a component.
     * Parameters: 
     *      int x: component x position
     * Applicable for: image
     */
    IDPropertyPositionX = 20,
    
    /**
     * This property sets the y position of a component.
     * Parameters: 
     *      int y: component y position
     * Applicable for: image
     */
    IDPropertyPositionY = 21,
    
    /**
     * This property sets the bookmarkable state of a component. If a
     * component is bookmarked, is can be activated by the bookmark
     * buttons in the car at any time if the application is available
     * Parameters
     *      bool bookmarkable: bookmarkable state
     * Applicable for: all components
     */
    IDPropertyBookmarkable = 22,
    
    /**
     * This property sets the spekable state of a component. If a
     * component is spekable, is can be activated by the speech dialogue 
     * system.
     * Parameters
     *      int speakable: speakable state
     0: not speakable
     1: speakable locally when user is on screen of component
     2: speakable globally in any screen
     * Applicable for: all components
     */
    IDPropertySpeakable = 23,
    
    /**
     * This property sets the table type of an hmistate.
     * Parameters
     *      int tabletype: 
     2: normal
     3: wide
     * Applicable for: all components
     */
    IDPropertyHmiStateTableType = 24,
    
    /**
     * This property sets the cursor width.
     * Parameters
     *      int cursorwidth
     * Applicable for: all components
     */
    IDPropertyCursorWidth = 25,
    
    /**
     * This property sets the table type of an hmistate.
     * Parameters
     *      Int32 layouttype: 
     0: eLayoutType_7Items  = 0
     1: eLayoutType_8Items  = 1
     4: eLayoutType_Paging  = 4
     Int32 begin: begin row to start for layoutmanager
     Int32 end: end row to start for layoutmanager
     * Applicable for: hmistates
     */
    IDPropertyHmiStateTableLayout = 26,
    
    /**
     * This property sets the X Axis Min Value in a Chart.
     * Parameters
     *      UINT32 xminvalue
     * Applicable for: chart
     */
    IDPropertyChartXAxisMinValue = 27,

    /**
     * This property sets the X Axis Max Value in a Chart.
     * Parameters
     *      UINT32 xmaxvalue
     * Applicable for: chart
     */
    IDPropertyChartXAxisMaxValue = 28,

    /**
     * This property sets the X Axis Step in a Chart.
     * Parameters
     *      UINT32 xstep
     * Applicable for: chart
     */
    IDPropertyChartXAxisStep = 29,

    /**
     * This property sets the Y Axis Max Value in a Chart.
     * Parameters
     *      UINT32 yminvalue
     * Applicable for: chart
     */
    IDPropertyChartYAxisMinValue = 30,

    /**
     * This property sets the Y Axis Max Value in a Chart.
     * Parameters
     *      UINT32 ymaxvalue
     * Applicable for: chart
     */
    IDPropertyChartYAxisMaxValue = 31,

    /**
     * This property sets the Y Axis Step in a Chart.
     * Parameters
     *      UINT32 xstep
     * Applicable for: chart
     */
    IDPropertyChartYAxisStep = 32,

    /**
     * This property sets the X Axis Label in a Chart.
     * Parameters
     *      String xlabel
     * Applicable for: chart
     */
    IDPropertyChartXAxisLabel = 33,

    /**
     * This property sets the X Axis Label in a Chart.
     * Parameters
     *      String ylabel
     * Applicable for: chart
     */
    IDPropertyChartYAxisLabel = 34,

    /**
     * This property enables paging on an hmiState with a toolbar. The first and last
     * button in the toolbar will be used for page up and down
     * Parameters: 
     *      bool paging: paging enabled state
     * Applicable for: toolbarHmiState
     */
    IDPropertyToolbarHmiStatePagingLimited = 35,
    
    /**
     * This property enables a speedlock for components. If the vehicle is driving
     * faster than a defined value the component will no longer be usable /visible
     * Parameters: 
     *      bool speedlock: enable speedlock
     * Applicable for: all components
     */
    IDPropertySpeedlock = 36,
    
    /**
     * This property sets the cutting style of a cell. 
     * Parameters
     *      uint32 cuttype:
     0: eCuttingStyle_CutDots,
     1: eCuttingStyle_NoCut,
     2: eCuttingStyle_CutWordsDots, // cut words at spaces and hyphens and add dots if it does not fit
     3: eCuttingStyle_CutBackwardsDots, // cut words as cut words dots but backwards
     4: eCuttingStyle_CutWordsAutoStaticText,
     5: eCuttingStyle_CutWordsAutoDynamicText
     * Applicable for: list
     */
    IDPropertyCuttingStyle = 37,
    
    /**
     * This property sets the tab stop offset. 
     * Parameters
     *      uint32 tobstopoffset
     * Applicable for: label, button
     */
    IDPropertyTabstopOffset = 38,
    
    /**
     * This property sets the type of background. 
     * Parameters
     *      uint32 background
     * Applicable for: label, button, image
     */
    IDPropertyBackground = 39,
    
    /**
     * These properties register/deregister input events for the TerminalUI widget
     * Applicable for: terminalUI
     */
    IDPropertyTerminalUIRegisterInputEvent = 40,
    IDPropertyTerminalUIDeregisterInputEvent = 41,
    
    /**
     * This property sets the max row count. 
     * Parameters
     *      int32 row count
     * Applicable for: list
     */
    IDPropertyListRichtextMaxRowCount = 42,
    
    /**
     * This property sets replaces content of line[index] with "...". 
     * All lines after line[index] are removed
     * Parameters
     *      int32 row index
     * Applicable for: list
     */
    IDPropertyListRichtextLastLineWithThreeDots = 43,
    
    /**
     * These properties set the respective video properties for the TerminalUI video widget
     * Applicable for: terminalUI
     */
    IDPropertyTerminalUISetContrast = 44,
    IDPropertyTerminalUISetBrightness = 45,
    IDPropertyTerminalUISetColor = 46,
    IDPropertyTerminalUISetTint = 47,
    IDPropertyTerminalUIStatusbar = 48,
    IDPropertyTerminalUIVideoVisible = 49,
    IDPropertyTerminalUISetMode = 50,
    IDPropertyGetValues = 51,
    IDPropertyTerminalUISetUser = 52, //JIRA A4A-1577: fix SKIP handling for TUI LUM

    /**
     * This property can be used to set/clear a checkmark within a toolbar.
     */
    IDPropertyChecked = 53

} IDPropertyType;
