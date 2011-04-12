//
//  BlogSelectorButton.m
//  WordPress
//
//  Created by Jorge Bernal on 4/6/11.
//  Copyright 2011 WordPress. All rights reserved.
//

#import "BlogSelectorButton.h"
#import "WordPressAppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@interface BlogSelectorButton (PrivateMethods)
- (void)tap;
@end

@implementation BlogSelectorButton
@synthesize activeBlog;
@synthesize delegate;

- (void)dealloc
{
    self.activeBlog = nil;
    [blavatarImageView release]; blavatarImageView = nil;
    [blogTitleLabel release]; blogTitleLabel = nil;
    [selectorImageView release]; selectorImageView = nil;
    [super dealloc];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        active = NO;

        CGRect blavatarFrame = self.bounds;
        blavatarFrame.size.width = blavatarFrame.size.height;
        blavatarFrame.origin.x += 5;
        blavatarImageView = [[WPAsynchronousImageView alloc] initWithFrame:blavatarFrame];
        blavatarImageView.isBlavatar = YES;
        blavatarImageView.layer.cornerRadius = 20.0f;
        [self addSubview:blavatarImageView];
        
        CGRect blogTitleFrame = self.bounds;
        blogTitleFrame.origin.x = blavatarFrame.size.width + 15;
        blogTitleFrame.size.width -= blavatarFrame.size.width + 10 + 50;
        blogTitleLabel = [[UILabel alloc] initWithFrame:blogTitleFrame];
        blogTitleLabel.font = [UIFont boldSystemFontOfSize:20];
        [self addSubview:blogTitleLabel];
        
        CGRect selectorImageFrame = self.bounds;
        selectorImageFrame.origin.x = selectorImageFrame.size.width - 40;
        selectorImageFrame.size.width = 30;
        selectorImageView = [[UIImageView alloc] initWithFrame:selectorImageFrame];
        selectorImageView.contentMode = UIViewContentModeCenter;
        selectorImageView.image = [UIImage imageNamed:@"downArrow"];
        [self addSubview:selectorImageView];
        
        [self addTarget:self action:@selector(tap) forControlEvents:UIControlEventTouchUpInside];        
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [FileLogger log:@"%@ %@", self, NSStringFromSelector(_cmd)];
    [super drawRect:rect];
}
*/

#pragma mark -
#pragma mark Custom methods

- (NSString *)defaultsKey {
    switch (type) {
        case BlogSelectorButtonTypeQuickPhoto:
            return kBlogSelectorQuickPhoto;
            break;
            
        default:
            break;
    }
    
    return nil;
}

- (void)loadBlogsForType:(BlogSelectorButtonType)aType {
    NSString *defaultsKey = [self defaultsKey];

    type = aType;
    NSManagedObjectContext *moc = [[WordPressAppDelegate sharedWordPressApp] managedObjectContext];
    NSPersistentStoreCoordinator *psc = [[WordPressAppDelegate sharedWordPressApp] persistentStoreCoordinator];
    NSError *error = nil;

    if (defaultsKey != nil) {
        NSString *blogId = [[NSUserDefaults standardUserDefaults] objectForKey:defaultsKey];
        if (blogId != nil) {
            self.activeBlog = (Blog *)[moc existingObjectWithID:[psc managedObjectIDForURIRepresentation:[NSURL URLWithString:blogId]] error:nil];
            if (self.activeBlog == nil) {
                // The default blog was invalid, remove the stored default
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:defaultsKey];
            }
        }
    }
    
    if (self.activeBlog == nil) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:[NSEntityDescription entityForName:@"Blog" inManagedObjectContext:moc]];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"blogName" ascending:YES]]];
        [fetchRequest setFetchLimit:1];
        NSArray *results = [moc executeFetchRequest:fetchRequest error:&error];
        if (results && ([results count] > 0)) {
            self.activeBlog = [results objectAtIndex:0];
        }
    }
}

- (void)setActiveBlog:(Blog *)aBlog {
    if (aBlog != activeBlog) {
        [activeBlog release];
        activeBlog = [aBlog retain];
        blavatarImageView.isWPCOM = [activeBlog isWPcom];
        [blavatarImageView loadImageFromURL:[activeBlog blavatarURL]];
        blogTitleLabel.text = activeBlog.blogName;
        if ([blogTitleLabel.text isEqualToString:@""]) {
            blogTitleLabel.text = activeBlog.hostURL;
        }
    }
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    if (!active) {
        [selectorViewController.tableView removeFromSuperview];
    }
}

- (void)tap {
    [FileLogger log:@"%@ %@", self, NSStringFromSelector(_cmd)];
    active = ! active;
    
    if (self.delegate) {
        if (active) {
            if ([self.delegate respondsToSelector:@selector(blogSelectorButtonWillBecomeActive:)]) {
                [self.delegate blogSelectorButtonWillBecomeActive:self];
            }
        } else {
            if ([self.delegate respondsToSelector:@selector(blogSelectorButtonWillBecomeInactive:)]) {
                [self.delegate blogSelectorButtonWillBecomeInactive:self];
            }            
        }
    }
    
    UIView *selectionView = selectorViewController.tableView;
    if (active) {
        normalFrame = self.frame;
        // Setup selection view
        CGRect selectionViewFrame = self.superview.bounds;
        selectionViewFrame.origin.y += self.frame.size.height;
        selectionViewFrame.size.height -= self.frame.size.height;
        if (selectorViewController == nil) {
            selectorViewController = [[BlogSelectorViewController alloc] initWithStyle:UITableViewStylePlain];
            selectorViewController.selectedBlog = self.activeBlog;
            selectorViewController.delegate = self;
        }
        selectionView = selectorViewController.tableView;
        selectionView.frame = selectionViewFrame;
        [self addSubview:selectionView];
    }
    
    [UIView beginAnimations:@"activation" context:nil];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    [UIView setAnimationDuration:0.15];
    if (active) {
        self.frame = self.superview.bounds;
        selectorImageView.transform = CGAffineTransformMakeRotation(M_PI);
    } else {
        self.frame = normalFrame;
        selectorImageView.transform = CGAffineTransformMakeRotation(0);
    }
    [UIView commitAnimations];
    
    if (self.delegate) {
        if (active) {
            if ([self.delegate respondsToSelector:@selector(blogSelectorButtonDidBecomeActive:)]) {
                [self.delegate blogSelectorButtonDidBecomeActive:self];
            }
        } else {
            if ([self.delegate respondsToSelector:@selector(blogSelectorButtonDidBecomeInactive:)]) {
                [self.delegate blogSelectorButtonDidBecomeInactive:self];
            }            
        }
    }
}

#pragma mark - Blog Selector delegate
- (void)blogSelectorViewController:(BlogSelectorViewController *)blogSelector didSelectBlog:(Blog *)blog {
    if (self.delegate && [self.delegate respondsToSelector:@selector(blogSelectorViewController:didSelectBlog:)]) {
        [self.delegate blogSelectorButton:self didSelectBlog:blog];
    }
    self.activeBlog = blog;
    NSString *defaultsKey = [self defaultsKey];
    if (defaultsKey != nil) {
        NSString *objectID = [[[self.activeBlog objectID] URIRepresentation] absoluteString];
        [[NSUserDefaults standardUserDefaults] setObject:objectID forKey:defaultsKey];
    }
    [self tap];
}

@end