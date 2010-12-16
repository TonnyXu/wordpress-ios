//
//  PageViewController.h
//  WordPress
//
//  Created by Chris Boyd on 9/4/10.
//

#import <UIKit/UIKit.h>
#import "TransparentToolbar.h"
#import "WordPressAppDelegate.h"
#import "BlogDataManager.h"
#import "PostMediaViewController.h"
#import "PageManager.h"
#import "DraftManager.h"
#import "Post.h"

@protocol PageViewControllerProtocol

@property (nonatomic, retain) NSString *selectedPostID;
@property (nonatomic, retain) DraftManager *draftManager;
@property (nonatomic, retain) PageManager *pageManager;
@property (nonatomic, assign) BOOL canPublish, isPublished;

- (IBAction)saveAction:(id)sender;
- (IBAction)publishAction:(id)sender;
- (IBAction)cancelAction:(id)sender;
- (IBAction)dismiss:(id)sender;
- (void)refreshButtons:(BOOL)hasChanges keyboard:(BOOL)isShowingKeyboard;

@end

@class EditPageViewController;

@interface PageViewController : UIViewController <PageViewControllerProtocol, UITabBarDelegate> {
	IBOutlet UITabBarController *tabController;
	
	NSString *selectedPostID;
	int selectedBDMIndex;
	BOOL isPublished, canPublish;
	
	BlogDataManager *dm;
	WordPressAppDelegate *appDelegate;
	DraftManager *draftManager;
	PageManager *pageManager;
	PostMediaViewController *mediaViewController;
}

@property (nonatomic, retain) IBOutlet UITabBarController *tabController;
@property (nonatomic, assign) BlogDataManager *dm;
@property (nonatomic, assign) WordPressAppDelegate *appDelegate;
@property (nonatomic, retain) IBOutlet PostMediaViewController *mediaViewController;

- (void)setupBackButton;

@end
