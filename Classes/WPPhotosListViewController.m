#define PhotoSize 124.0
#define PhotoOffSet 4.0

#define NUM_COLS 4
#define TAG_OFFSET 100

#import "WPPhotosListViewController.h"
#import "BlogDataManager.h"

@implementation WPPhotosListViewController

static inline double radians (double degrees) {return degrees * M_PI/180;}

@synthesize postDetailViewController, tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		// Initialization code
	}
	return self;
}

- (IBAction)showPhotoUploadScreen:(id)sender;
{
	[self showPhotoPickerActionSheet];
}

- (IBAction)addPhotoFromLibraryAction:(id)sender
{
	[self pickPhotoFromPhotoLibrary:nil];
}

- (IBAction)addPhotoFromCameraAction:(id)sender
{
	[self pickPhotoFromCamera:nil];		
}

- (UIImagePickerController*)pickerController
{
	if( pickerController == nil )
	{
		pickerController = [[UIImagePickerController alloc] init];
		pickerController.delegate = self;
		pickerController.allowsImageEditing = NO;
	}
//	NSLog(@"pickerController %@", pickerController);
	return pickerController;
}

- (void)clearPickerContrller
{
	[pickerController release];
	pickerController = nil;
}

- (void)showPhotoPickerActionSheet
{
	isShowPhotoPickerActionSheet = YES;
	// open a dialog with two custom buttons
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
																													 delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
																									otherButtonTitles:@"Add Photo from Library", @"Take Photo with Camera", nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	[actionSheet showInView:postDetailViewController.view];
	[actionSheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex 
{
	if( isShowPhotoPickerActionSheet )
	{
		if (buttonIndex == 0)
			[self pickPhotoFromPhotoLibrary:nil];
		else if(buttonIndex == 1 )
			[self pickPhotoFromCamera:nil];
		
		//cancel
	}
	else 
	{
		if (buttonIndex == 0) //add
		{
			[self useImage:currentChoosenImage];
		}
		else if (buttonIndex == 1) //add and return
		{
			[self useImage:currentChoosenImage];
			//	[picker popViewControllerAnimated:YES];
			UIImagePickerController* picker = [self pickerController];
			[[picker parentViewController] dismissModalViewControllerAnimated:YES];
			[self refreshData];
		}
		else 
		{
			//do nothing
		}
		[currentChoosenImage release];
		currentChoosenImage = nil;
	}
}

- (void)pickPhotoFromCamera:(id)sender {
//	[[BlogDataManager sharedDataManager] makeNewPictureCurrent];
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		UIImagePickerController* picker = [self pickerController];
		picker.sourceType = UIImagePickerControllerSourceTypeCamera;
		
		// Picker is displayed asynchronously.
		[[postDetailViewController navigationController] presentModalViewController:picker animated:YES];
	}
}

- (void)pickPhotoFromPhotoLibrary:(id)sender {
//	[[BlogDataManager sharedDataManager] makeNewPictureCurrent];
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
		UIImagePickerController* picker = [self pickerController];
		picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//		NSLog(@"pickPhotoFromPhotoLibrary ... %@", picker);
		// Picker is displayed asynchronously.
		[postDetailViewController.navigationController presentModalViewController:picker animated:YES];
	}
}

- (UIImage *)fixImageOrientation:(UIImage *)img
{
	
	CGSize size = [img size];
	
	UIImageOrientation imageOrientation = [img imageOrientation];
	NSLog(@"Image orientation : %d", imageOrientation);
	
	if (imageOrientation == UIImageOrientationUp)
		return img;
	
	CGImageRef imageRef = [img CGImage];
	CGContextRef bitmap = CGBitmapContextCreate(
												NULL,
												size.width,
												size.height,
												CGImageGetBitsPerComponent(imageRef),
												4*size.width,
												CGImageGetColorSpace(imageRef),
												CGImageGetBitmapInfo(imageRef));
	
	CGContextTranslateCTM( bitmap, size.width, size.height );
	
	switch (imageOrientation) {
		case UIImageOrientationDown:
			// rotate 180 degees CCW
			CGContextRotateCTM( bitmap, radians(180.) );
			break;
		case UIImageOrientationLeft:
			// rotate 90 degrees CW
			CGContextRotateCTM( bitmap, radians(-90.) );
			break;
		case UIImageOrientationRight:
			// rotate 90 degrees CCW
			CGContextRotateCTM( bitmap, radians(90.) );
			break;
		default:
			break;
	}
	
	CGContextDrawImage( bitmap, CGRectMake(0,0,size.width,size.height), imageRef );

	CGImageRef ref = CGBitmapContextCreateImage( bitmap );	
	CGContextRelease( bitmap );
	UIImage *oimg = [UIImage imageWithCGImage:ref];
	CGImageRelease( ref );

	return oimg;
}



- (UIImage *)scaleAndRotateImage:(UIImage *)image
{
	int kMaxResolution = 640; // Or whatever
	
	CGImageRef imgRef = image.CGImage;
	
	CGFloat width = CGImageGetWidth(imgRef);
	CGFloat height = CGImageGetHeight(imgRef);
	
	
	CGAffineTransform transform = CGAffineTransformIdentity;
	CGRect bounds = CGRectMake(0, 0, width, height);
	if (width > kMaxResolution || height > kMaxResolution) {
		CGFloat ratio = width/height;
		if (ratio > 1) {
			bounds.size.width = kMaxResolution;
			bounds.size.height = bounds.size.width / ratio;
		}
		else {
			bounds.size.height = kMaxResolution;
			bounds.size.width = bounds.size.height * ratio;
		}
	}
	
	CGFloat scaleRatio = bounds.size.width / width;
	CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
	CGFloat boundHeight;
	UIImageOrientation orient = image.imageOrientation;
	switch(orient) {
			
		case UIImageOrientationUp: //EXIF = 1
			transform = CGAffineTransformIdentity;
			break;
			
		case UIImageOrientationUpMirrored: //EXIF = 2
			transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
			transform = CGAffineTransformScale(transform, -1.0, 1.0);
			break;
			
		case UIImageOrientationDown: //EXIF = 3
			transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
			transform = CGAffineTransformRotate(transform, M_PI);
			break;
			
		case UIImageOrientationDownMirrored: //EXIF = 4
			transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
			transform = CGAffineTransformScale(transform, 1.0, -1.0);
			break;
			
		case UIImageOrientationLeftMirrored: //EXIF = 5
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
			transform = CGAffineTransformScale(transform, -1.0, 1.0);
			transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
			break;
			
		case UIImageOrientationLeft: //EXIF = 6
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
			transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
			break;
			
		case UIImageOrientationRightMirrored: //EXIF = 7
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeScale(-1.0, 1.0);
			transform = CGAffineTransformRotate(transform, M_PI / 2.0);
			break;
			
		case UIImageOrientationRight: //EXIF = 8
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
			transform = CGAffineTransformRotate(transform, M_PI / 2.0);
			break;
			
		default:
			[NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
			
	}
	
	UIGraphicsBeginImageContext(bounds.size);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
		CGContextScaleCTM(context, -scaleRatio, scaleRatio);
		CGContextTranslateCTM(context, -height, 0);
	}
	else {
		CGContextScaleCTM(context, scaleRatio, -scaleRatio);
		CGContextTranslateCTM(context, 0, -height);
	}
	
	CGContextConcatCTM(context, transform);
	
	CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
	UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return imageCopy;
}


- (void)imagePickerController:(UIImagePickerController *)picker
				didFinishPickingImage:(UIImage *)image
									editingInfo:(NSDictionary *)editingInfo
{
	NSLog(@"imagePickerController editingInfo %@",editingInfo);
//in case of photo library also we have to do our transformations.
//	if( picker.sourceType == UIImagePickerControllerSourceTypeCamera )
		image = [self scaleAndRotateImage:image];

	[self useImage:image];
	[[picker parentViewController] dismissModalViewControllerAnimated:YES];
	[self clearPickerContrller];
	[self refreshData];
	
//	currentChoosenImage = [image retain];
//	isShowPhotoPickerActionSheet = NO;
//	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
//																													 delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
//																									otherButtonTitles:@"Add and Select More", @"Add and Continue Editing", nil];
//	actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
//	[actionSheet showInView:picker.view];
//	[actionSheet release];	
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
//	NSLog(@"imagePickerControllerDidCancel");
	[[picker parentViewController] dismissModalViewControllerAnimated:YES];
	[self clearPickerContrller];
	[tableView reloadData];
}

// Implement this method in your code to do something with the image.
- (void)useImage:(UIImage*)theImage
{
//	NSLog(@"useImage %@",theImage);
	
	BlogDataManager *dataManager = [BlogDataManager sharedDataManager];
	//	NSString *url = [dataManager pictureURLBySendingToServer:theImage];
	//	if( !url )
	//		return;
	
	//	NSString *curText = textView.text;
	//	curText = ( curText == nil ? @"" : curText );
	//	textView.text = [curText stringByAppendingString:[NSString stringWithFormat:@"<img src=\"%@\"></img>",url]];
	//	[dataManager.currentPost setObject:textView.text forKey:@"description"];
	postDetailViewController.hasChanges = YES;
	
	id currentPost = dataManager.currentPost;
	if (![currentPost valueForKey:@"Photos"])
		[currentPost setValue:[NSMutableArray array] forKey:@"Photos"];
	
	[[currentPost valueForKey:@"Photos"] addObject:[dataManager saveImage:theImage]];
	[postDetailViewController updatePhotosBadge];
//	NSLog(@"post detail currentPost %@",currentPost);
}

- (void)refreshData {
//	NSLog(@"photos refreshData");
	
	//clean up of images
//	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"photsSelectionRow"];
//	if (cell != nil) {
//		int i;
//		WPImageView *imageView;
//		for( i=0;1; i++ )
//		{
//			imageView = (WPImageView*)[cell viewWithTag:i+TAG_OFFSET];
//			if( !imageView )
//				break;
//			[imageView setImage:nil];
//		}
//	}
//				
	[tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[tableView reloadData];
	[postDetailViewController updatePhotosBadge];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
	// plus one to because we add a row for "Local Drafts"
	//
//	NSLog(@"photos count %d",[[[[BlogDataManager sharedDataManager] currentPost] valueForKey:@"Photos"] count]);
	int count = [[[[BlogDataManager sharedDataManager] currentPost] valueForKey:@"Photos"] count];
	countField.text = [NSString stringWithFormat:@"%d Photos", count];
	return (count/NUM_COLS)+( count%NUM_COLS ? 1 : 0 ) ;
}

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	float psize = (CGRectGetWidth([aTableView frame]) - (PhotoOffSet * (NUM_COLS+1))) / NUM_COLS; 
	return psize + 2 *PhotoOffSet ;
}

- (void)imageViewSelected:(WPImageView *)iv
{
	int index = [iv tag]-TAG_OFFSET;
	id array = [[BlogDataManager sharedDataManager].currentPost valueForKey:@"Photos"];
	if( index >=0 && index < [array count] )
	{
		WPPhotoViewController *photoViewController = [[WPPhotoViewController alloc] initWithNibName:@"WPPhotoViewController" bundle:nil];
		photoViewController.currentPhotoIndex = index;
		photoViewController.photosListViewController = self;
		[postDetailViewController.navigationController presentModalViewController:photoViewController animated:YES];	
		[photoViewController release];		
	}
}


- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	//WordPressAppDelegate *appController = [[UIApplication sharedApplication] delegate];
	NSString *selectionTableRowCell = [NSString stringWithFormat:@"photsSelectionRow%d", indexPath.row];
	
	UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:selectionTableRowCell];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:selectionTableRowCell] autorelease];
	}
	
	BlogDataManager *dataManager = [BlogDataManager sharedDataManager];
	id array = [dataManager.currentPost valueForKey:@"Photos"];
	
	float psize = (CGRectGetWidth([aTableView frame]) - (PhotoOffSet * (NUM_COLS+1))) / NUM_COLS; 
	int i;
	WPImageView *imageView;
	for( i=0; i < NUM_COLS; i++ )
	{
		int index = (indexPath.row*NUM_COLS+i);
		
		imageView = (WPImageView*)[cell viewWithTag:index+TAG_OFFSET];
		if( !imageView && index < [array count] )
		{
			imageView = [[WPImageView alloc] initWithFrame:CGRectMake(((i+1)*PhotoOffSet)+(i*psize), PhotoOffSet, psize, psize)];
			imageView.contentMode = UIViewContentModeScaleAspectFit; 
			[imageView setDelegate:self operation:@selector(imageViewSelected:)];
			imageView.userInteractionEnabled = YES;		
			[cell addSubview:imageView];
			imageView.tag = TAG_OFFSET+index;
			[imageView release];			
		}
		
		if( index < [array count] )
		{	
			imageView.image = [dataManager thumbnailImageNamed:[array objectAtIndex:index] forBlog:dataManager.currentBlog];
			[imageView setBackgroundColor:[UIColor colorWithRed:0.8f green:0.8f blue:0.8f alpha:0.5]];
		}
		else
		{
			imageView.image = nil;
			[imageView setBackgroundColor:[UIColor whiteColor]];
		}
	}
	
	return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	return nil;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)aTableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath 
{
	return UITableViewCellAccessoryNone;	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
	NSLog(@"%@ %@", self, NSStringFromSelector(_cmd));
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
}


- (void)dealloc {
	[pickerController release];
	[super dealloc];
}


@end
