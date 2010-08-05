//
//  WPPhotosListProtocol.h
//  WordPress
//
//  Created by JanakiRam on 27/10/08.
//

#import <UIKit/UIKit.h>

@protocol WPPhotosListProtocol

- (void)useImage:(UIImage *)theImage;
- (void)useVideo:(NSData *)video withThumbnail:(NSString *)thumbnailURL andFilename:(NSString *)filename;
- (id)photosDataSource;
- (void)updatePhotosBadge;
- (void)setHasChanges:(BOOL)aFlag;

@optional

// iPad additions
- (void)displayPhotoListImagePicker:(UIImagePickerController *)picker;
- (void)hidePhotoListImagePicker;

@end
