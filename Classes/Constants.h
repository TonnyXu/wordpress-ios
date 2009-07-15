//
//  Constants.h
//  WordPress
//
//  Created by Ganesh Ramachandran on 6/6/08.
//

// Blog archive file name
#define BLOG_ARCHIVE_NAME       WordPress_Blogs

// control dimensions
#define kStdButtonWidth         106.0
#define kStdButtonHeight        40.0

#define kTextFieldHeight        20.0
#define kTextFieldFontSize      18.0
#define kTextFieldFont          @"Arial"

#define kDisabledTextColor      [UIColor grayColor]

#define kLabelHeight            20.0
#define kLabelWidth             90.0
#define kLabelFont              @"Arial"

#define kProgressIndicatorSize  40.0
#define kToolbarHeight          40.0
#define kSegmentedControlHeight 40.0

// table view cell
#define kCellLeftOffset         4.0
#define kCellTopOffset          12.0
#define kCellRightOffset        32.0
#define kCellFieldSpacer        14.0
#define kCellWidth              300.0
#define kCellHeight             44.0
#define kSectionHeaderHight     25.0

#define REFRESH_BUTTON_HEIGHT   50

#define TABLE_VIEW_BACKGROUND_COLOR          [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1]
#define TABLE_VIEW_CELL_BACKGROUND_COLOR     [UIColor whiteColor]
#define TABLE_VIEW_CELL_ALT_BACKGROUND_COLOR [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1]

#ifdef DEBUGMODE
#define WPLog NSLog
#else
#define WPLog //NSLog
#endif

#define kBlogId                                 @"blogid"
#define kBlogHostName                           @"blog_host_name"
#define kCurrentBlogIndex                       @"CurrentBlogIndex"
#define kResizePhotoSetting                     @"ResizePhotoSetting"
#define kAsyncPostFlag                          @"async_post"
#define kSupportsPagesAndComments               @"SupportsPagesAndComments"
#define kVersionAlertShown                      @"VersionAlertShown"
#define kSupportsPagesAndCommentsServerCheck    @"SupportsPagesAndCommentsServerCheck"
#define kResizePhotoSettingHintLabel            @"Resizing will result in faster publishing \n but smaller photos. Resized photos \n will be no larger than 640 x 480."
#define kPasswordHintLabel                      @"Setting a password will require visitors to \n enter the above password to view this \n post and its comments."

#pragma mark Error Messages

#define kNoInternetErrorMessage                 @"No internet connection."
#define kBlogExistsErrorMessage                 @"Blog '%@' already configured on this iPhone."
